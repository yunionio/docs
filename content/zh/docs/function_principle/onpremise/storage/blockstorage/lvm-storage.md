---
title: "使用 LVM 本地存储"
weight: 30
description: >
---

## LVM 是什么

LVM（Logical Volume Manager）是一种逻辑卷管理器，可以将一个或多个物理存储设备抽象为一个或多个逻辑卷，并将逻辑卷分配给文件系统和其他应用程序使用。


## cloudpods 如何添加 LVM 存储

1. 修改/etc/yunion/host.conf，在 lvm_volume_groups 的字符串数组中添加新的 VG：

```yaml
lvm_volume_groups:
- storage1 # vgname
```

当然需要提前确保这个 VG 是存在的

```
$ vgs
  VG                                        #PV #LV #SN Attr   VSize    VFree
  storage1                                    1   1   0 wz--n- <200.00g <170.00g
```

2. 重启host服务

host服务重启后，稍等片刻，查看宿主机的存储列表，就能看到这个新的存储注册上来了。

```bash
climc storage-list --host <host_id>
```

eg:
```
climc storage-list --host 12880086-034d-46b0-89ca-6d4f51d2de6a
+--------------------------------------+--------------------------------------+----------+----------------------+--------+--------------+-------------+---------+--------------+
|                  ID                  |                 Name                 | Capacity | Actual_capacity_used | Status | Storage_type | Medium_type | Enabled | public_scope |
+--------------------------------------+--------------------------------------+----------+----------------------+--------+--------------+-------------+---------+--------------+
| 86259ab3-cf7b-4f19-8fd6-0c49094638aa | host_192.168.222.102_lvm_storage_0   | 204796   | 0                    | online | lvm          | rotate      | true    | none         |
+--------------------------------------+--------------------------------------+----------+----------------------+--------+--------------+-------------+---------+--------------+
```

## 如何创建一个 VG

以下是一个简要的流程：
```bash
# 如: /dev/sdb 是可以给虚机使用的磁盘，首先创建 PV.
pvcreate /dev/sdb
# storage1 则是我们创建的 VG.
vgcreate storage1 /dev/sdb
```

## 如何删除 LVM 存储

和删除本地存储的步骤类似：

1. 需要确保所有的虚拟磁盘都被删除，特别需要留意被伪删除的磁盘，以及被标记为系统资源的磁盘:

```bash
# 查看所有的磁盘，包括不再执行命令用户所在项目下的所有磁盘，以及被标记为系统资源的磁盘
climc disk-list --storage <storage_id> --scope system --system
# 查看所有的未删除的磁盘
climc disk-list --storage <storage_id> --scope system --system --pending-delete
```

2. 解除存储和宿主机的关联关系：

```bash
climc host-storage-detach <host_id> <storage_id>
```

3. 删除存储

```bash
climc storage-delete <storage_id>
```

4. 到宿主机，修改 /etc/yunion/host.conf，将该存储所在路径从 lvm_volume_groups 删除

5. 重启host服务
