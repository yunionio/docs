---
title: "制作主机镜像"
date: 2019-07-19T11:12:40+08:00
weight: 11
description: >
  介绍如何制作主机系统镜像
---

主机镜像可以通过如下几种方式制作。

## 基于虚拟主机创建

保存虚拟机镜像时，可以选择保存主机镜像，即把主机所有磁盘都分别保存为镜像，并且组成一个主机镜像。

## 基于已有磁盘镜像创建

可以将多个磁盘镜像组成一个主机镜像。

climc命令如下：

```bash
climc guest-image-create <name> --image <id_of_root_image> --image <id_of_data_image> --image ...
```

要求所有镜像的状态都是active状态，并且第一个镜像要求设置了os_type。

### Tip： 如何将vmware的ova虚拟机文件导入 {{<oem_name>}} 成为主机镜像？

首先将ova解压缩为一个目录，内部包含ovf描述虚拟机的配置信息，以及诺干vmdk磁盘文件。将vmdk磁盘文件分别上传 {{<oem_name>}}。然后创建一个主机镜像，按顺序包含这些上传的vmdk镜像。