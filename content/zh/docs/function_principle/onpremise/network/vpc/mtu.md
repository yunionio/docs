---
title: "MTU"
weight: 74
description: >
  介绍修改VPC内虚拟机MTU
---

VPC网络是一个虚拟网络，通过隧道技术在物理网络上构建，因此每个VPC网络报文需要在头部预留出一定的空间给隧道协议使用，这个预留字节数在 pkg/apis/compute/vpcs_ovn.go 的常量 VPC_OVN_ENCAP_COST 定义，默认值为60字节。(注意：3.8版本之前默认值为58字节)。同时，物理网络的MTU一般是1500字节，因此VPC内虚拟机的MTU默认是1440字节。本文介绍在默认情况下，1440字节MTU对应用的影响和解决方案。同时，也介绍如何设置将VPC虚拟机的MTU调整为1500。

## 1440字节MTU对虚拟机应用的影响

目前看对绝大部分应用，MTU设置是透明的，没有影响。除了以下应用：

### Docker

从用户反馈看，当虚拟机的MTU为1440时，Docker内运行的应用会受到影响。

对于常规Docker应用，需要修改 /etc/docker/daemon.json ，添加如下配置：

```json
{
  "mtu": 1440
}
```

修改后，重启Docker容器。

注意：云平台默认会自动注入该配置。

### Docker Compose

以上修改只会设置Docker的默认网桥docker0的MTU。对于使用Docker Compose的应用，Docker Compose会为每个应用创建一个网桥。需要在每个Docker Compose的配置文件 docker-compose.yml 中添加如下的配置，使得每个Docker Compose添加的网桥MTU也被正确设置：

```yaml
...
networks: 
  default:
    driver: bridge
    driver_opts:
      com.docker.network.driver.mtu: 1440
```
修改后，需要重建Docker Compose应用，使得该应用对应网桥的MTU设置为1440。

具体请参考这篇文章：https://mlohr.com/docker-mtu/

## 设置虚拟机MTU

以下介绍如何设置平台参数，使得虚拟机可以使用自定义的MTU值，例如使用1500字节的MTU。

### 控制节点配置

云平台定义了一个全局的配置 ovn_underlay_mtu 用于设置云平台底层承载VPC流量的物理网络的MTU，该值默认为1500。需要修改该值为 虚拟机MTU + VPC_OVN_ENCAP_COST。例如虚拟机MTU为1500，则 ovn_underlay_mtu = 1560。

需要修改如下服务的配置文件的 ovn_underlay_mtu 参数：

1. 修改 region 服务的 ovn_underlay_mtu

```bash
climc service-config-edit region2
```

修改后，无需重启服务，立即生效。

2. 修改 vpcagent 服务的 ovn_underlay_mtu

```bash
kubectl -n onecloud edit configmaps default-vpcagent
```

修改后，需要重启 vpcagent 服务。

```bash
kubectl -n onecloud rollout restart deployments default-vpcagent
```

### 计算节点设置

1. 修改网卡MTU

首先需要将计算节点ovn_encap_ip对应的物理网卡的MTU值设置为 ovn_underlay_mtu 。

```bash
ip link set eth0 mtu 1560 
```

这里 eth0 为物理网卡的名称。

如果该物理网卡加入了Openvswitch的网桥，则同时需要执行如下命令，将ovs网桥的MTU也设置为跟物理网卡一致：

```bash
ovs-vsctl set int br0 mtu_request=1560
```

这里br0是eth0加入的ovs网桥。

同时，需要将改MTU值持久化，这样下次服务器重启的时候自动生效。

在CentOS系统，持久化方法为:

修改 /etc/sysconfig/network-scripts/ifcfg-eth0，增加 MTU=1560 的配置。

以上修改需要针对每个计算节点进行。

2. 修改 sdnagent 服务的 ovn_underlay_mtu

需要修改每个计算节点的配置文件 /etc/yunion/host.conf。设置 ovn_underlay_mtu。

3. 重启生效

以上修改完成后，需要重启default-host容器生效。

```bash
kubectl -n onecloud rollout restart daemonsets default-host
```

### EIP网关设置

如果EIP网关复用计算节点，则无需配置。如果EIP网关独立部署，则同样需要设置 eip网关的 sdnagent 配置文件 (/etc/yunion/sdnagent.conf) 的 ovn_underlay_mtu 设置。

修改完成后，需要重启 yunion-sdnagent-eipgw 服务。
