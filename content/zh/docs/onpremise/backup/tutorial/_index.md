---
title: "操作指南"
date: 2022-02-17T15:26:05+08:00
weight: 20
description: >
    介绍如何备份、恢复虚拟机和硬盘
---

仅支持为 {{<oem_name>}} 平台的虚拟机、硬盘进行备份恢复的操作。


### 前提条件

在为虚拟机、硬盘进行备份恢复之前请先添加备份存储。目前暂不支持在界面添加备份存储，可通过climc命令添加备份存储。

```bash
# 添加备份存储
$ climc backupstorage-create [--storage-type {nfs}] [--nfs-host NFS_HOST] [--nfs-shared-dir NFS_SHARED_DIR] [--capacity-mb CAPACITY_MB] [--description <DESCRIPTION>] <NAME>

# 举例，将存储地址`192.168.1.1`，文件路径`/data/nfs`的nfs存储添加到备份存储
$ climc backupstorage-create --storage-type nfs --nfs-host 192.168.1.1 --nfs-shared-dir /data/nfs --capacity-mb 100000 backupstorage

```
