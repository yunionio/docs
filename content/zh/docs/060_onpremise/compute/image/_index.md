---
title: "镜像"
weight: 60
description: >
  镜像服务
---

- 镜像(image): 是用于新建云服务器(虚拟机)、裸金属(物理机)使用的模板文件，常用类型为 qcow2, vmdk, raw, vhd, iso。

- 镜像服务(glance): 云平台的镜像服务叫做 glance，用于存储转换用户上传或外部导入的镜像，提供下载功能。

- 缓存镜像(cached-image): 创建公/私有云虚拟机时，可以直接使用各个云平台已有的镜像，这些镜像不会存储在 glance，云平台只是保存元信息，创建机器时会直接使用。

image 和 cached-image 两种资源的区别如下：

- image: glance 管理的镜像，由用户上传或者外部导入;
- cached-image:
  - 包括公有云和其他私有云的镜像，不由 glance 管理，一般在创建 Cloudpods 之外的公/私有云主机的时候用到;
  - 不提供创建接口，只能查询，刷新和删除;

