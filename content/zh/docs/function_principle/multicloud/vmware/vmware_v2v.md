---
title: VMware迁移到KVM
weight: 20
description: >
    将纳管的VMware主机迁移到KVM私有云
---

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

