---
title: "扩容镜像后端存储"
date: 2021-10-09
weight: 90
description: >
  介绍如何对后端镜像存储进行扩容
---

## 扩容适用于以下两种情况
- 新部署的环境 **/opt/cloud/workspace/data/glance** 空间太小，不足以存储所需要的镜像
- 已有环境已经耗尽存储空间，无法存储新的镜像，且已有镜像正在使用都不能清理释放

## 新环境
- 目标是将**空的** /opt/cloud/workspace/data/glance 进行扩容，以保证可以存储所需要的镜像文件
    1. 新磁盘 /dev/sdd
        - 将/dev/sdd分区并格式化
        - 将/dev/sdd1挂载到 /opt/cloud/workspace/data/glance 目录, 并且将挂载信息写入/etc/fstab
        - mount /dev/sdd1 /opt/cloud/workspace/data/glance
    2. 大空间目录 /home/glance/images
        - 将 /home/glance/images 目录挂载到 /opt/cloud/workspace/data/glance 目录, 并且将挂载信息写入/etc/fstab
        - mount --bind /home/glance/images /opt/cloud/workspace/data/glance

## 已有环境扩容
- 目标是将**已有镜像** /opt/cloud/workspace/data/glance 进行扩容
    1. 新磁盘 /dev/sdd
        - 将/dev/sdd分区并格式化
        - 将/dev/sdd1挂载到/mnt目录(mount /dev/sdd1 /mnt)
        - 将/opt/cloud/workspace/data/glance镜像转移至/mnt(rsync -avp /opt/cloud/workspace/data/glance/* /mnt/)
        - 卸载/dev/sdd1(unmount /dev/sdd1)
        - 将/dev/sdd1挂载到 /opt/cloud/workspace/data/glance 目录, 并且将挂载信息写入/etc/fstab
        - mount /dev/sdd1 /opt/cloud/workspace/data/glance
    2. 大空间目录 /home/glance/images
        - 将 /opt/cloud/workspace/data/glance 镜像文件转移至/home/glance/images目录(rsync -avp /opt/cloud/workspace/data/glance/* /home/glance/images/)
        - 将 /home/glance/images 目录挂载到 /opt/cloud/workspace/data/glance 目录, 并且将挂载信息写入/etc/fstab
        - mount --bind /home/glance/images /opt/cloud/workspace/data/glance
