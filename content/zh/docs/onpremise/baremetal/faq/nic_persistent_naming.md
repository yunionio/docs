---
title: "裸金属网卡命名"
date: 2021-09-09T22:25:05+08:00
weight: 2
---

## 为什么物理机的网卡名称总是命名为en0, en1, ...?

传统的Linux网卡命名规则为按照内核探测网卡的顺序，把网卡依次命名为eth0, eth1, ...。这种命名方式导致的问题时在添加/删除网卡设备后，导致网卡的名称发生变化（例如将eth0的网卡移除，重启之后，原来命名为eth1的网卡会变成eth0）。为了让网卡的名称和内核探测网卡的顺序无关，从systemd/udev v197开始引入了Predictable-Network-Interface-Names的机制，采用网卡的firmware/topology/location信息来命名网卡，例如 eno1， ens1，enp2s0等。具体参见 https://www.freedesktop.org/wiki/Software/systemd/PredictableNetworkInterfaceNames/ 。

采用新机制避免了因为网卡的检测顺序、增删网卡等导致的网卡名称不持久，但却导致网卡的名称没有规律可循，而云平台初始化裸金属时需要能够明确地配置指定物理机网卡的IP配置。

为此，{{<oem_name>}}按照YunionOS探测网卡的顺序给网卡依次命名为en0, en1, ...

为了实现网卡的自定义命名，{{<oem_name>}}做了如下操作：

1) 关闭 Predictable-Network-Interface-Names 机制，需要修改 /etc/default/grub，在内核启动参数添加 "net.ifnames=0 biosdevnames=0"

2) 修改 /etc/udev/rules.d/70-persistent-net.rules ，一次写入网卡的mac和名称映射关系，udev将按照mac对网卡进行命名

```bash
KERNEL=="*", SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?*", ATTR{address}=="00:22:a6:48:39:10", ATTR{type}=="1", NAME="en0"
KERNEL=="*", SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?*", ATTR{address}=="00:22:a6:48:39:11", ATTR{type}=="1", NAME="en1"
```

## 物理机更换网卡后的注意事项

物理机如果更换网卡，首先需要同时更新{{<oem_name>}}对应物理机的网卡数据，具体操作请参见{{< ref "../tutorial/change_netif.md" >}}。

同时，由于采用了如上自定义命名网卡的机制，新加入的网卡的mac不在udev的规则中，会出现新网卡的命名不遵循enX的命名规律，导致网卡的IP配置不生效。因此需要采用如下措施修改udev的命名规则：

1) 手动修改 /etc/udev/rules.d/70-persistent-net.rules

2) 如果允许物理机重启，可以执行如下命令，让物理机重启boot进入YunionOS，初始化一系列配置文件，包括udev的配置文件：

```bash
climc server-deploy <baremetal_server_id>
```
