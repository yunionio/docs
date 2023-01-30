---
title: VMware
weight: 2
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

## 将纳管的VMware主机迁移到KVM私有云

云平台支持将纳管的VMware主机迁移到内置KVM私有云主机。其工作原理为：

1. 前提条件

* VMware主机对接的经典网络IP子网在KVM私有云中也能分配给虚拟机使用
* KVM内置私有云的宿主机和VMware的ESXi宿主机之间网络可以互相访问
* VMware主机处于关机状态

2. 迁移方法

通过climc命令迁移，执行

```bash
climc server-convert-to-kvm <sid>
```

其中，<sid>为纳管的VMware主机的名称或ID。

3. 迁移过程

1) 在KVM平台创建和VMware主机同配置的虚拟机，并且将VMware主机的虚拟网卡卸载，挂载到新建的KVM虚拟机上，创建虚拟磁盘，并且将VMware主机的磁盘作为KVM虚拟机磁盘的backing file
2）启动KVM虚拟机，远程挂载VMware主机的磁盘，作为KVM虚拟机的磁盘的backing file
3）启动成功后，KVM虚拟机的磁盘内容为VMware虚拟机的磁盘，网络IP是VMware主机的IP。同时，将VMware主机设置为Freeze状态，禁止VMware主机启动
4）启动后，开始磁盘数据同步，会将KVM虚拟磁盘底层的VMware虚拟机磁盘数据同步到KVM虚拟机的上层磁盘文件，磁盘数据同步完成后，KVM虚拟机不再依赖VMware虚拟机
5) 磁盘数据同步完成后，可以删除原来的VMware虚拟机，完成迁移

4. 迁移回滚

如果迁移失败，则需要删除KVM虚拟机(需确保在回收站清理)。删除后，会自动将虚拟网卡挂载回VMware虚拟机，并且解除VMware主机Freeze状态

