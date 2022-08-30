---
title: "Host服务问题排障技巧"
weight: 10
description: >
---

Host服务可能因为各种原因启动失败，现象为Host服务重启之后，在云平台宿主机列表，宿主机的状态一直为离线。

本文介绍一般的排查问题的思路。

## Host服务对应容器Pod介绍

首先，我们需要了解Host服务对应的Pod。

Host服务由k8s的onecloud命名空间下的Daemonset default-host定义，在每个节点上都会运行一个名为 default-host-xxxxx 的容器，其中 xxxxx 为随机的字符串。

Default-host Pod中有三个容器：

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
