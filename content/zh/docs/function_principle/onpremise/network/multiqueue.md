---
title: "网卡多队列"
weight: 120
description: >
  网卡多队列
---

平台支持虚拟机的虚拟网卡开启多队列特性。

## Qemu命令行参数

```bash
-netdev type=tap,id=GUESTNET1-219,queues=4,ifname=GUESTNET1-219,vhost=on,vhostforce=off,script=if-up-br1-GUESTNET1-219.sh,downscript=if-down-br1-GUESTNET1-219.sh -device virtio-net-pci,mq=on,vectors=9,id=netdev-GUESTNET1-219,netdev=GUESTNET1-219,mac=00:22:02:a1:0f:da
```

参数设置：

* queues

queues 是队列数量，包括收发包；一般来说队列数为 cpu的数量的一半，最多16个队列。 如 8C  4个队列，16C 8个队列，32C 及以上 16个队列。如果需要更好的网络性能可以自定义队列数量，但数量不是越大越好，和虚机CPU的数量挂钩

* vectors

vectors是该设备中断向量的数量，一般为 queues * 2 + 1，每个个队列有两个向量，分别对应收包和发包，再加上配置空间的中断向量

## 宿主机上验证

当设置虚拟网卡queues=4之后，宿主机上，可以看到该网卡对应的4个vhost线程。这四个线程独立于 VCPU线程，需要占用 宿主机 CPU，网络繁忙的时候CPU使用率较高，没有绑核的话可能会对其他虚机造成干扰。如果需要更好的网络性能可以分配一些 CPU 给这部分线程使用。

## 虚拟机内验证

在虚拟机内，通过ethtool查看虚拟网卡的队列数：

```
# ethtool -l eth0
Channel parameters for eth0:
Pre-set maximums:
RX:             0
TX:             0
Other:          0
Combined:       4
```

如果有必要配置队列数

```bash
# ethtool -L eth0 combined 4
```

查看网卡设备的中断处理CPU

```bash
# cat /proc/interrupts | grep virtio
```

检查虚拟机镜像中是否带了irqbalance服务来打散多队列的中断到不同的CPU上：

```bash
systemctl status irqbalance
```
