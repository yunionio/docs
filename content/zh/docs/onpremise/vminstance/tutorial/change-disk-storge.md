---
title: "迁移磁盘存储"
weight: 42
description: >
  介绍如何把虚拟机的磁盘迁移到另一个存储。
---

在 v3.8.4 版本后可以把虚拟机的磁盘迁移到另一个存储，应用场景如下：

- Ceph RBD 磁盘迁移到本地存储
- 本地磁盘迁移到 Ceph 存储
- Ceph RBD 磁盘迁移到另一个 Ceph 存储

另外限制条件如下：

- 虚拟机必须是关机状态，运行状态迁移磁盘存储功能还未实现
- 互相迁移的两个存储必须挂载到虚拟机所在的宿主机

假设环境中一台名叫 x86-node01-11-10-1-180-11 的宿主机分别挂载了一个 Ceph 存储和一个本地存储，用下面的命令可以查训到这台宿主机上挂载的存储：

```bash
$ climc host-storage-list --host x86-node01-11-10-1-180-11 --details
+----------------------------------+----------------------------+-----------+---------------+----------------+
|             Storage              |        Mount_point         | Capacity  | Used_capacity | Waste_capacity |
+----------------------------------+----------------------------+-----------+---------------+----------------+
| wz_rbd                           | rbd:rbd                    | 241013618 | 1556480       | 30720          |
| host_10.1.180.11_local_storage_0 | /opt/cloud/workspace/disks | 681664    | 696320        | 0              |
+----------------------------------+----------------------------+-----------+---------------+----------------+
```

通过上面的 `climc host-storage-list` 命令找到 x86-node01-11-10-1-180-11 这台宿主机上面有 2 个存储，Ceph RBD 存储为 wz_rbd，本地存储为 host_10.1.180.11_local_storage_0 。

## Ceph RBD 磁盘迁移到本地存储

下面命令测试创建一台虚拟机到 wz_rbd Ceph 存储，然后把磁盘迁移到 host_10.1.180.11_local_storage_0 本地存储。

```bash
# 首先创建一个名为 tvm-wz 虚拟机，磁盘使用 rbd，指定创建到宿主机
$ climc server-create --disk CentOS-7.6.1810-20190430.qcow2:rbd \
    --net vm-test-net \
    --mem-spec 1g \
    --ncpu 1 \
    --allow-delete \
    --auto-start \
    --prefer-host x86-node01-11-10-1-180-11 \
    tvm-wz

# 查看虚拟机的磁盘信息
# 找到对应的磁盘名称为 vdisk-tvm-wz-1636100820075603665
$ climc server-disk-list --server tvm --details
+-------+--------------------------------------+-------------------------------+-----------+--------+------------+-------+--------+-----------+--------------+
| Guest |               Disk_ID                |             Disk              | Disk_size | Driver | Cache_mode | Index | Status | Disk_type | Storage_type |
+-------+--------------------------------------+-------------------------------+-----------+--------+------------+-------+--------+-----------+--------------+
| tvm-wz| 65ca88b1-186f-440a-8930-b4914e62cb3d | vdisk-tvm-wz-1636100820075603665 | 30720     | scsi   | none       | 0     | ready  | sys       | rbd       |
+-------+--------------------------------------+-------------------------------+-----------+--------+------------+-------+--------+-----------+--------------+

# 查看磁盘 vdisk-tvm-wz-1636100820075603665 所在的存储为 h3c_blockpool1
$ climc disk-show vdisk-tvm-wz-1636100820075603665 | grep storage
| storage                   | wz_rbd                                                                  |
| storage_status            | online                                                                  |
| storage_type              | rbd                                                                     |
```

现在已经创建好使用 wz_rbd Ceph 存储的虚拟机了，接下来把这个 tvm-wz 虚拟机的 vdisk-tvm-wz-1636100820075603665 磁盘迁移到本地存储，命令如下：

```bash
# 将虚拟机关机才能进行磁盘迁移存储
$ climc server-stop tvm-wz

# 执行下面的 server-change-disk-storage 命令把 tvm 虚拟机的 vdisk-tvm-1636100820075603665 磁盘迁移到本地存储
$ climc server-change-disk-storage tvm-wz vdisk-tvm-wz-1636100820075603665 host_10.1.180.11_local_storage_0

# 然后查看虚拟机的状态，磁盘迁移存储虚拟机会处于 disk_change_storage 的状态
$ climc server-list --search tvm-wz --details
| 329bfce5-135f-4113-861e-bd44b8aaf9e0 | tvm-wz | postpaid     | 10.2.18.252 | 30720 | disk_change_storage      | 1          | 1024      | Default  | default  |

# 等待虚拟机状态变为 ready 表示迁移完毕
# 然后再查看虚拟机的磁盘为 vdisk-tvm-wz-1636103786977105704
$ climc server-disk-list --server tvm-wz --details                                                                                    
+--------+--------------------------------------+----------------------------------+-----------+--------+------------+-------+--------+-----------+--------------+
| Guest  |               Disk_ID                |               Disk               | Disk_size | Driver | Cache_mode | Index | Status | Disk_type | Storage_type |
+--------+--------------------------------------+----------------------------------+-----------+--------+------------+-------+--------+-----------+--------------+
| tvm-wz | 61e4f0e4-597a-4aa9-8cde-0369879b9236 | vdisk-tvm-wz-1636103786977105704 | 30720     | scsi   | none       | 0     | ready  | sys       | local        |
+--------+--------------------------------------+----------------------------------+-----------+--------+------------+-------+--------+-----------+--------------+

# 查看新的磁盘 vdisk-tvm-wz-1636103786977105704 的存储，发现已经变为本地存储了
$ climc disk-show  vdisk-tvm-wz-1636103786977105704 | grep storage
| storage                   | host_10.1.180.11_local_storage_0                                                 |
| storage_id                | 4484274b-8483-4166-8e3f-f3c37c4b4997                                             |
| storage_status            | online                                                                           |
| storage_type              | local                                                                            |
```

## 本地磁盘迁移到 Ceph RBD 存储

还是利用之前创建好的 tvm-wz 虚拟机，现在虚拟机的磁盘为本地的 vdisk-tvm-wz-1636103786977105704 磁盘，执行下面的命令把该磁盘迁移到 wz_rbd Ceph 存储。

```bash
# 迁移本地磁盘到 wz_rbd
$ climc server-change-disk-storage tvm-wz vdisk-tvm-wz-1636103786977105704 wz_rbd

# 等待迁移完成后，再执行之前的命令查看先在虚拟机的磁盘，发现已经使用 wz_rbd 存储了
# 新的磁盘为 vdisk-tvm-wz-1636104909252150575
$ climc server-disk-list --server tvm-wz --details                                                                                    
+--------+----------------------------------+-----------+--------+------------+-------+--------+-----------+--------------+
| Guest  |               Disk               | Disk_size | Driver | Cache_mode | Index | Status | Disk_type | Storage_type |
+--------+----------------------------------+-----------+--------+------------+-------+--------+-----------+--------------+
| tvm-wz | vdisk-tvm-wz-1636104909252150575 | 30720     | scsi   | none       | 0     | ready  | sys       | rbd          |
+--------+----------------------------------+-----------+--------+------------+-------+--------+-----------+--------------+

$ climc disk-show vdisk-tvm-wz-1636104909252150575 | grep storage
| storage                   | wz_rbd                                |
| storage_id                | 061342a6-8f5a-4bc6-8757-8bb6c12bda83  |
| storage_status            | online                                |
| storage_type              | rbd                                   |
```

测试迁移完成后，把虚拟机开机，能够正常启动，并且里面没有数据丢失，就没有问题。

## Ceph RBD 磁盘迁移到另一个 Ceph 存储

**注意**：目前 Ceph 迁移到另一个 Ceph 存储要求两边的版本相同，依赖的 rbd 动态库一致才行，不然会失败。

假设环境中有另外一个叫做 wz_rbd 的 Ceph 存储，下面命令测试创建一台虚拟机到 h3c_blockpool1 Ceph 存储，然后把磁盘迁移到一个名为 wz_rbd 的 Ceph 存储。

```bash
# 首先创建一个名为 tvm 虚拟机，磁盘使用 rbd，指定创建到宿主机
$ climc server-create --disk CentOS-7.6.1810-20190430.qcow2:rbd \
    --net vm-test-net \
    --mem-spec 1g \
    --ncpu 1 \
    --allow-delete \
    --auto-start \
    --prefer-host x86-node03-13-10-1-180-13 \
    tvm

# 查看虚拟机的磁盘信息
# 找到对应的磁盘名称为 vdisk-tvm-1636100820075603665
$ climc server-disk-list --server tvm --details
+-------+--------------------------------------+-------------------------------+-----------+--------+------------+-------+--------+-----------+--------------+
| Guest |               Disk_ID                |             Disk              | Disk_size | Driver | Cache_mode | Index | Status | Disk_type | Storage_type |
+-------+--------------------------------------+-------------------------------+-----------+--------+------------+-------+--------+-----------+--------------+
| tvm   | 65ca88b1-186f-440a-8930-b4914e62cb3d | vdisk-tvm-1636100820075603665 | 30720     | scsi   | none       | 0     | ready  | sys       | rbd          |
+-------+--------------------------------------+-------------------------------+-----------+--------+------------+-------+--------+-----------+--------------+

# 查看磁盘 vdisk-tvm-1636100820075603665 所在的存储为 h3c_blockpool1
$ climc disk-show vdisk-tvm-1636100820075603665 | grep storage
| storage                   | h3c_blockpool1                                                                  |
| storage_id                | 0bf0cf3c-8cc8-47bb-8d1e-ab97f103e267                                            |
| storage_status            | online                                                                          |
| storage_type              | rbd                                                                             |
```

现在已经创建好使用 h3c_blockpool1 Ceph 存储的虚拟机了，接下来把这个 tvm 虚拟机的 vdisk-tvm-1636100820075603665 磁盘迁移到另一个 Ceph 存储 wz_rbd，命令如下：

```bash
# 首先需要把 wz_rbd 存储挂载到虚拟机所在的宿主机 x86-node03-13-10-1-180-13
$ climc host-storage-attach x86-node03-13-10-1-180-13 wz_rbd

# 查看宿主机上挂载的存储，会发现多一块存储 wz_rbd
$ climc host-storage-list --host x86-node03-13-10-1-180-13 --details
+----------------------------------+----------------------------+-----------+---------------+----------------+---------------+----------+
|             Storage              |        Mount_point         | Capacity  | Used_capacity | Waste_capacity | Free_capacity | cmtbound |
+----------------------------------+----------------------------+-----------+---------------+----------------+---------------+----------+
| wz_rbd                           | rbd:rbd                    | 241018691 | 1525760       | 30720          | 239462208     | 1        |
| h3c_blockpool1                   | rbd:.HDDdisk.rbd           | 192653544 | 122880        | 0              | 192530656     | 1        |
| host_10.1.180.13_local_storage_0 | /opt/cloud/workspace/disks | 681664    | 61440         | 0              | 620224        | 1        |
+----------------------------------+----------------------------+-----------+---------------+----------------+---------------+----------+

# 将虚拟机关机才能进行磁盘迁移存储
$ climc server-stop tvm

# 执行下面的 server-change-disk-storage 命令把 tvm 虚拟机的 vdisk-tvm-1636100820075603665 磁盘迁移到 wz_rbd 存储
$ climc server-change-disk-storage tvm vdisk-tvm-1636100820075603665 wz_rbd
```

## 其他注意事项

- 更改存储的旧磁盘会删除到回收站，会占用实际的物理空间，如果确定这些旧的磁盘不使用了，可以在回收站里面清理。

## 磁盘更改存储的原理

目前磁盘更改存储底层使用了 `qemu-img convert` 的命令来进行磁盘底层存储变更，在云平台执行了 `climc server-change-disk-storage` 命令后，可以登录到虚拟机所在的宿主机，执行下面的命令，就可以看到这个 `qemu-img convert` 的进程：

```bash
$ ps faux | grep qemu-img | grep convert
root     3701532 13.8  0.1 1516864 102056 ?      Ssl  17:35   0:00  \_ /usr/local/qemu-2.12.1/bin/qemu-img convert -f qcow2 -O raw /opt/cloud/workspace/disks/61e4f0e4-597a-4aa9-8cde-0369879b9236 rbd:rbd/d55671c1-ec1b-4c2c-87cb-aa4aa517744e:mon_host=172.16.2.31\;172.16.2.32\;172.16.2.33:key=AQBBi1RhiSvXChAAnFzGrpAGM5N8dWb3rTdQwQ\=\=:rados_osd_op_timeout=1200:client_mount_timeout=120:rados_mon_op_timeout=5
```
