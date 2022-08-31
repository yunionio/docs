---
title: "新建备份存储"
date: 2022-03-15T16:24:54+08:00
weight: 10
description: >
    介绍如何添加备份存储
---

目前仅支持添加NFS共享存储作为备份存储。

<big>**climc操作**</big>

```bash
# 添加备份存储，目前--capacity-mb字段无意义，可随便填写
$ climc backupstorage-create [--storage-type {nfs}] [--nfs-host NFS_HOST] [--nfs-shared-dir NFS_SHARED_DIR] [--capacity-mb CAPACITY_MB] [--description <DESCRIPTION>] <NAME>

# 举例，将存储地址`192.168.1.1`，文件路径`/data/nfs`的nfs存储添加到备份存储
$ climc backupstorage-create --storage-type nfs --nfs-host 192.168.1.1 --nfs-shared-dir /data/nfs --capacity-mb 100000 backupstorage

```
