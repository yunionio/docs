---
title: "部署EIP网关"
weight: 59
description: >
  介绍如何部署弹性公网IP网关。
---

当用户环境使用VPC网络时，由于VPC网络是一块网络隔离的地址空间，在VPC网络中的虚拟机如果需要与外部通信，需要绑定弹性公网IP（EIP）。EIP是经典网络可路由访问的一段IP地址。EIP网关负责将EIP和VPC的虚拟机IP进行IP地址转换（NAT），实现外部通过EIP访问VPC内的虚拟机IP。

系统部署后，默认不部署EIP网关。需要手工部署。本节介绍如何部署EIP网关。

## 在计算节点部署EIP网关

EIP网关需要依赖ovn-controller, sdnagent等软件包，都已经在计算节点部署好了，因此在计算节点部署EIP网关，只需要配置即可，比较方便。

### 单节点EIP网关

这是最简单的场景，只需要修改/etc/yunion/host.conf，将 sdn_enable_eip_man 设置为 true，重启该计算节点的 default-host pod，即可生效。

### 主备高可用EIP网关

在该场景，则需要使用ansible脚本实现自动化部署。

部署之前，需要为两台计算节点申请一个VIP。

Ansible脚本位于[sdnagent代码仓库](https://github.com/yunionio/sdnagent)的 build/sdnagent/root/usr/share/sdnagent/ansible/ 目录下。

将inventory文件复制一份，根据实际的环境，调整其中的变量值

```yaml
sdnagent_rpm					sdnagent.rpm在当前机器中的位置.  keepalived将从目标机器配置的yum仓库中直接部署

oc_region						"oc_"前缀的变量用于向keystone认证，访问API服务。可以从default-climc pod
oc_auth_url						通过"env | grep ^OS_"命令获得相应的值
oc_admin_project
oc_admin_user
oc_admin_password

vrrp_router_id					keepalived的virtual router id值。主备必须相同。若环境中有其他keepalived部署，必须不能冲突
vrrp_priority					keepalived实例的priority，数值大的为MASTER，小的为BACKUP
vrrp_interface					keepalived进行VRRP通信的网卡，这里为计算节点的管理网卡，一般为br0
vrrp_vip						keepalived实例间相互通告的vip，可用作访问eip的下一跳地址
```

inventory配置好以后，执行ansible playbook

```bash
ansible-playbook -i a-inventory playbook.yaml
```


## 在非计算节点部署EIP网关

EIP网关也可部署到单独的宿主机、虚拟机中，只要满足EIP的流量可以路由到EIP网关的三层网络通信需求即可。

需要使用ISO中的.rpm安装包预先安装、配置好网关所需组件。以下对这部分进行描述

以3.8为例，所需安装的包的名字和所在位置如下

```bash
# https://iso.yunion.cn/3.8/rpms/packages/kernel
linux-firmware
kernel-lt

# https://iso.yunion.cn/3.8/rpms/packages/host
kmod-openvswitch
unbound
openvswitch
openvswitch-ovn-common
openvswitch-ovn-host
```

安装完内核之后，需要重启机器使之效

```bash
# 启动openvswitch
systemctl enable --now openvswitch

# 配置ovn
ovn_encap_ip=xx							# 隧道外层IP地址，EIP网关用它与其它计算节点通信
ovn_north_addr=yy:32242					# ovn北向数据库的地址，yy一般选择某台宿主机ip地址；端口默认为32242，对应k8s default-ovn-north service中的端口号
ovs-vsctl set Open_vSwitch . \
	external_ids:ovn-bridge=brvpc \
	external_ids:ovn-encap-type=geneve \
	external_ids:ovn-encap-ip=$ovn_encap_ip \
	external_ids:ovn-remote="tcp:$ovn_north_addr"
# 启动ovn-controller
systemctl enable --now ovn-controller
```

部署结束后，应当可以看到至少一个名为brvpc的openvswitch网桥，ovs-vsctl show命令的输出中可以看到名为ovn-xx，类型为geneve的隧道port，remote-ip指向计算节点的ovn-encap-ip。

部署完成后，用上述ansible脚本进行部署。

样例inventory的hosts描述了两台主机用作主备高可用，如果无需高可用，可将其中的一个主机描述删除，仅部署一台。
