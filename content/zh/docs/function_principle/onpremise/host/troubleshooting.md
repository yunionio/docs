---
title: "Host服务问题排查"
date: 2021-11-11T15:59:40+08:00
weight: 6
description: >
    介绍一些常见Host服务错误问题排查方法
---

Host服务可能因为各种原因启动失败，现象为Host服务重启之后，在云平台宿主机列表，宿主机的状态一直为离线。

本文介绍一般的排查问题的思路。

## Host服务对应容器Pod介绍

首先，我们需要了解Host服务对应的Pod。

Host服务由k8s的onecloud命名空间下的Daemonset default-host定义，在每个节点上都会运行一个名为 default-host-xxxxx 的容器，其中 xxxxx 为随机的字符串。

default-host pod中有三个容器：

| 容器名称       | 功能                                                                           |
|----------------|--------------------------------------------------------------------------------|
| host           | Host服务的主服务进程，实现和控制器的通信，控制qemu虚拟机进程，管理存储和网络   |
| ovn-controller | ovn在每个节点的控制进程，从ovn-northd维护的数据库同步节点配置信息，并下发到ovs |
| sdnagent       | 实现经典网络的安全组和流控，VPC网络辅助ovn-controller实现VPC网络功能           |

## 定位宿主机的host容器

通过如下命里找到在指定宿主机上运行的Host容器

```bash
kubectl -n onecloud get pods -o wide | grep <ip_of_host>
```

例如：
```bash
# kubectl -n onecloud get pods -o wide | grep office-03-host01
default-host-xc2t5                                  3/3     Running            0          4h7m    192.168.222.3     office-03-host01           <none>           <none>
default-host-deployer-zv6tk                         1/1     Running            0          5d15h   10.40.33.249      office-03-host01           <none>           <none>
default-host-image-cql69                            1/1     Running            132        128d    192.168.222.3     office-03-host01           <none>           <none>
default-telegraf-q8fl9                              2/2     Running            40         128d    192.168.222.3     office-03-host01           <none>           <none>
```

这几个Pod的功能解释如下：

| Pod                         | 说明                                                                |
|-----------------------------|---------------------------------------------------------------------|
| default-host-xxxxx          | DaemonSet default-host 的pod                                        |
| default-host-deployer-xxxxx | DaemonSet default-host-deployer 的pod，实现虚拟机磁盘的初始化和识别 |
| default-host-image-xxxxx    | DaemonSet default-host-image 的pod，实现本地虚拟机磁盘的读取        |
| default-telegraf-xxxxx      | DaemonSet default-telegraf 的pod，实现宿主机的监控数据采集          |

## 重启Host服务

有时候，重启就能解决问题，重启host服务只需要删除对应的pod，k8s会立即重建对应pod，实现host服务的重启.

```bash
kubectl -n onecloud delete pods default-host-xxxxx
```

## 查看Host服务的日志

采用如下命令查看Host服务的日志。由于host pod中有三个容器，因此需要用 -c 参数指定容器（-c host）。如下命令查看从过去10分钟开始（--since 10m）的host容器的日志，并且不退出（-f），持续输出日志到控制台。

```bash
kubectl -n onecloud logs default-host-xxxxx -c host --since 10m -f
```

Host服务在启动时会执行如下检查：

* 设置和优化内核参数，例如io调度器参数
* 检查关键软件，例如qemu，内核nbd模块，openvswitch等
* 初始化并配置网络
* 初始化并配置存储
* ...

在每一步都可能出错，此时可以通过查看输出日志，定位原因。

## 常见问题

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

### 存储介质识别不准，例如机械盘识别成固态

例如用户使用SSD 做lvmcache 等情况，可能造成宿主机本地存储介质识别不准，可自行前往对应宿主机->存储->对应存储介质 修改属性，选择介质类型修改即可。
