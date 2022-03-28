---
title: "清理无用镜像"
date: 2021-12-08T19:12:33+08:00
weight: 37
description: >
    包括清理docker镜像以及平台内的镜像
---

### 清理无用docker镜像

```bash
# 清理docker image
$ docker system prune --all --force --volumes
```

### 清理平台镜像

以下为平台镜像、镜像缓存、快照的存放目录，当存储不足时，用户可手动删除对应资源。

- 镜像默认上传到控制节点目录：/opt/cloud/workspace/data/glance/images，可通过镜像ID查找对应的镜像文件，并进行删除。

![](../images/image.png)

- 镜像缓存到宿主机的缓存目录：/opt/cloud/workspace/disks/image_cache，可通过镜像ID查找对应的镜像缓存并进行删除。

![](../images/imagecache.png)

- 宿主机上虚拟机快照目录：/opt/cloud/workspace/disks/snapshots，可通过硬盘ID搜索对应的快照文件进行删除。

![](../images/snapshot.png)
