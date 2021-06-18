---
title: "制作镜像"
date: 2019-07-19T11:12:40+08:00
weight: 10
---

你可能需要自己定制发行版的镜像，用于给不同的业务使用。本文介绍如何制作镜像。

可以通过下载发行版操作系统的 iso , 然后本地启动虚拟机，将 iso 安装到虚拟机的磁盘，然后保存该磁盘，这个磁盘就可以作为镜像上传到 glance，但是这种方法人工参与的步骤太多，容易出错。

推荐使用 [packer](https://www.packer.io/intro/getting-started/install.html) 这个工具来自动化制作镜像，详细操作可以参考对应的文档 https://www.packer.io/docs/index.html 。


https://github.com/yunionio/service-images 仓库包含了一些我们使用 packer 制作镜像的配置，可以参考使用。
