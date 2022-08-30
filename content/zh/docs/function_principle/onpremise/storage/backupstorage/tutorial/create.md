---
title: "新建备份存储"
date: 2022-03-15T16:24:54+08:00
weight: 10
description: >
    介绍如何添加备份存储
---

目前仅支持添加NFS共享存储作为备份存储。

<big>**界面操作**</big>

1. 在左侧导航栏，选择 **_"存储/备份存储/备份存储"_** 菜单项，进入备份存储页面。
2. 单击列表上方 **_"新建"_** 按钮，弹出新建备份存储对话框。
3. 配置以下参数：
    - 指定域：备份存储的所属域。
    - 名称：备份存储的名称。
    - 备注：备份存储的备注信息。
    - 存储类型：默认为NFS。
    - NFS Host：NFS服务器的IP地址。
    - NFS Shared Dir：NFS服务器设置的共享目录。
4. 单击 **_"确定"_** 按钮，添加共享存储。

<big>**climc操作**</big>

```bash
# 添加备份存储，目前--capacity-mb字段无意义，可随便填写
$ climc backupstorage-create [--storage-type {nfs}] [--nfs-host NFS_HOST] [--nfs-shared-dir NFS_SHARED_DIR] [--capacity-mb CAPACITY_MB] [--description <DESCRIPTION>] <NAME>

# 举例，将存储地址`192.168.1.1`，文件路径`/data/nfs`的nfs存储添加到备份存储
$ climc backupstorage-create --storage-type nfs --nfs-host 192.168.1.1 --nfs-shared-dir /data/nfs --capacity-mb 100000 backupstorage

```
