---
title: VMware
weight: 30
description: >
    VMware 对接常见问题。
---

## VMware同步后主机没有IP

可能有两种原因：

1) 因为VMware主机的IP是通过虚拟机内的vmtools获取的，如果同步的时候虚拟机处于关机状态，或者虚拟机内vmtools未安装，或者虚拟机内vmtools未正确运行，则无法获取IP。

2) 能正常通过vmtools获取虚拟机的IP，但是该IP在平台没有对应的IP子网，导致无法判定虚拟机归属的IP子网。（此时，会将主机的IP信息保存在主机的标签中。前端会展示该IP，但是提示”该IP地址无归属IP子网！请添加包含该IP地址的IP子网并重新同步云账号“。）

因此，为了让VMware的主机在同步后有IP地址，需要满足两个条件：

1）主机正在运行，且主机内已安装vmtools，并且vmtools正常运行

2）主机IP在云台有归属的经典网络（Default VPC）的IP子网

## VMware同步后缺少主机

云平台同步资源时，要求VMware主机的UUID全局唯一，会自动忽略UUID相同的所有主机。可以从同步日志发现UUID相同的主机同步日志。

为了让UUID相同的主机能正常同步，需要手动修改主机的UUID，保证全局唯一。方法为：

在VMware平台，编辑主机的.vmx配置文件，修改bios.uuid字段。

