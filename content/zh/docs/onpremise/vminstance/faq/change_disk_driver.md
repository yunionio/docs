---
title: "修改磁盘驱动"
weight: 45
description: >
  介绍如何修改虚拟机磁盘的驱动。
---

## 介绍

默认情况下，虚拟机的磁盘驱动是 scsi 的，这种驱动在 Linux 虚拟机内部看到的磁盘就是 '/dev/sd' 开头的块设备。可以通过一些命令设置磁盘的驱动，比如 Windows 虚拟机在没有安装 virtio 驱动的时候，只能使用 ide 驱动的方式启动。

## 查看虚拟机磁盘驱动

首先通过 server-disk-list 命令查看虚拟机所有磁盘的驱动，比如虚拟机的名称是 vm1 。

```bash
# server-disk-list 命令查看虚拟机和关联磁盘的关系
#   --details: 显示详细信息
#   --server: 指定对应的虚拟机名称或者 ID
#   --scope system: 表示显示系统里面所有资源
$ climc server-disk-list --details --server vm1 --scope system
+--------------------------------------+-------+--------------------------------------+-------------------------------+-----------+--------+------------+-------+--------+-----------+--------------+
|               Guest_ID               | Guest |               Disk_ID                |             Disk              | Disk_size | Driver | Cache_mode | Index | Status | Disk_type | Storage_type |
+--------------------------------------+-------+--------------------------------------+-------------------------------+-----------+--------+------------+-------+--------+-----------+--------------+
| 84090287-9dc5-4d6b-854d-24f99ad6f170 | vm1   | 968d9285-6353-4bce-8a6f-bf540efad3f5 | data-disk                     | 10240     | scsi   | none       | 1     | ready  | data      | local        |
| 84090287-9dc5-4d6b-854d-24f99ad6f170 | vm1   | 5448ea7d-5c64-47a2-847d-06060e187a47 | vdisk-vm1-1624970026002516731 | 30720     | scsi   | none       | 0     | ready  | sys       | local        |
+--------------------------------------+-------+--------------------------------------+-------------------------------+-----------+--------+------------+-------+--------+-----------+--------------+
```

其中 Index 为 0 表示虚拟机的第一块磁盘，对应到 Linux 系统里面的 '/dev/sda'，Driver 表示对应驱动为 scsi，Disk_type 为 sys 表示系统盘。

Index 为 1 表示第二块磁盘，对应 Linux 系统里面的 '/dev/sdb'，驱动也为 scsi ，Disk_type 为 data 表示数据盘。

## 修改驱动

通过 server-disk-update 命令更新虚拟机上的磁盘驱动。

先看下 server-disk-update 命令的帮助信息。

```bash
$ climc server-disk-update --help
Usage: climc server-disk-update [--cache {writethrough,none,writeback}] [--aio {native,threads}] [--index INDEX] [--driver {virtio,ide,scsi,pvscsi}] <SERVER> <DISK>

Update details of a virtual disk of a virtual server

Positional arguments:
    <SERVER>
        ID or Name of server
    <DISK>
        ID or Name of Disk

Optional arguments:
    # 对应 qemu/kvm 虚拟机磁盘 cache mode
    [--cache {writethrough,none,writeback}]
        Cache mode of vDisk
    # 对应 qemu/kvm 虚拟机磁盘的 aio
    [--aio {native,threads}]
        Asynchronous IO mode of vDisk
    # 磁盘索引顺序
    [--index INDEX]
        Index of vDisk
    # 对应 qemu/kvm 虚拟机磁盘 driver
    [--driver {virtio,ide,scsi,pvscsi}]
        Driver of vDisk
```

从帮助信息可以看到支持的 driver 为 virtio, ide, scsi 或者 pvscsi ，请根据自己的需要进行选择。

```bash
# 把虚拟机 vm1 的系统盘 5448ea7d-5c64-47a2-847d-06060e187a47 驱动改为 virtio
$ climc server-disk-update --driver virtio vm1 5448ea7d-5c64-47a2-847d-06060e187a47

# 查看记录，发现已经改成 virtio 了
$ climc server-disk-list --details --server vm1 --scope system | grep 5448ea7d-5c64-47a2-847d-06060e187a47
| 84090287-9dc5-4d6b-854d-24f99ad6f170 | vm1   | 5448ea7d-5c64-47a2-847d-06060e187a47 | vdisk-vm1-1624970026002516731 | 30720     | virtio | none       | 0     | ready  | sys       | local        |
```

修改了磁盘驱动后，需要重启虚拟机才能生效，使用 server-stop 和 server-start 命令重启虚拟机 vm1 。

```bash
# 停止虚拟机
$ climc server-stop vm1

# 调用 server-list 查看虚拟机状态，等到状态变为 ready
$ climc server-list --search vm1 --scope system
+--------------------------------------+------+--------------+---------+------------+-----------+-----------+-----------------------------+------------+---------+-----------+
|                  ID                  | Name | Billing_type | Status  | vcpu_count | vmem_size | Secgrp_id |         Created_at          | Hypervisor | os_type | is_system |
+--------------------------------------+------+--------------+---------+------------+-----------+-----------+-----------------------------+------------+---------+-----------+
| 84090287-9dc5-4d6b-854d-24f99ad6f170 | vm1  | postpaid     | ready   | 1          | 1024      | default   | 2021-06-29T12:33:45.000000Z | kvm        | Linux   | false     |
+--------------------------------------+------+--------------+---------+------------+-----------+-----------+-----------------------------+------------+---------+-----------+

# 启动虚拟机
$ climc server-start vm1

# 之后再重复查看虚拟机状态，知道变为 running
```

然后通过前端的 vnc 或者 ssh 登录虚拟机，用 lsblk 之类的磁盘工具查看磁盘，发现里面的磁盘块设备名称已经从 '/dev/sda' 变成 '/dev/vda' 了。

```bash
[cloudroot@vm1 ~]$ lsblk 
NAME   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sr0     11:0    1 1024M  0 rom  
vda    253:0    0   30G  0 disk 
├─vda1 253:1    0    1M  0 part 
├─vda2 253:2    0  512M  0 part /boot
└─vda3 253:3    0 29.5G  0 part /
```
