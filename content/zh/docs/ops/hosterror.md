---
title: "Host服务问题排查"
date: 2021-11-11T15:59:40+08:00
weight: 100
description: >
    介绍一些常见Host服务错误问题排查方法
---

### 宿主机安装Host服务完成后，默认处于禁用状态，需要启用后使用。宿主机启用方法如下：

- 在云管平台的宿主机列表中启用该宿主机；

- 在控制节点使用climc命令启用该宿主机；

    ```bash
    $ climc host-enable id
    ```
### Host服务为什么会变成离线？

region的HostPingDetectionTask将超过3分钟未收到ping的host服务置为offline，并将宿主机上的虚拟机状态设置为unknown。

### 宿主机的Host服务启动失败，且报错“Fail to get network info：no networks”，该怎么解决？

该问题一般是没有为宿主机网卡的IP地址注册IP子网，云平台根据此信息判断宿主机对接的二层网络信息。为解决这个问题，需要在云管平台为宿主机创建一个包含宿主机IP地址的IP子网或使用climc命令在控制节点创建一个网络。

```bash
$ climc network-create bcast0 host02  10.168.222.226  10.168.222.226 24 --gateway 10.168.222.1
```
### 宿主机MAC改变会导致Host服务离线，需要更改宿主机在平台注册的MAC地址，具体步骤如下

- 例如，宿主机IP地址为100.91.1.22，其MAC从18:9b:a5:81:4f:17变为18:9b:a5:81:4f:16

    ```bash
    # 092231af-eebc-456f-8a21-3ab7c944f20c为宿主机id，97e29a73-6615-4d5b-8b67-96bb13b80b90为宿主机所在二层网络的id
    $ climc host-remove-netif 092231af-eebc-456f-8a21-3ab7c944f20c 18:9b:a5:81:4f:17
    $ climc host-add-netif --ip 100.91.1.22 092231af-eebc-456f-8a21-3ab7c944f20c 97e29a73-6615-4d5b-8b67-96bb13b80b90 18:9b:a5:81:4f:16 0
    ```

### 宿主机网卡刚开始没有做bonding，做了bonding之后，如何不重启宿主机变更配置？

假设刚开始宿主机用物理网卡 eth0 作为管理网网卡接入云平台，其IP地址为192.168.201.20。对应/etc/yunion/host.conf配置为：

```yaml
networks:
- eth0/br0/192.168.201.20
```

云平台部署完成后，管理员将 eth0 和 eth1 绑定设置为 bond0，IP地址仍然是 192.168.201.20，则需要修改 /etc/yunion/host.conf 配置为：

```yaml
networks:
- bond0/br0/192.168.201.20
```

由于openvswitch会记忆配置在ovsdb中，此时，网桥br0已经将eth0加入，如果不做配置，则br0依然还会将eth0加入网桥。因此需要手动将eth0从br0删除：

```bash
ovs-vsctl del-port br0 eth0
```

此时，为了让配置生效，比较简便的方法是重启宿主机。

如果宿主机不方便重启，则需要手动执行以下操作：

1、拉起bond0

首先确保bond0的配置(/etc/sysconfig/network-scripts/ifcfg-bond0,ifcfg-eth0,ifcfg-eth1)已经正确配置。重启网络：

```bash
systemctl restart network
```

2、清除bond0上的IP地址

重启网络后，IP地址配置在bond0上，同时br0上也有同样的IP地址。则需要清除bond0的IP：

```bash
ifconfig bond0 0
```

3、将eth0从br0移除，并将bond0加入br0

```bash
ovs-vsctl del-port br0 eth0
ovs-vsctl add-port br0 bond0
```

