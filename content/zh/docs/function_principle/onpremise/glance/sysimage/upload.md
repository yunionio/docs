---
title: "上传镜像"
date: 2019-07-19T11:34:14+08:00
weight: 1
description: >
  介绍如何上传自定义镜像到平台。
---

## 获取镜像

上传镜像之前需要先获取镜像，途径有多种，比如从发行版官网下载用于云平台的镜像，或者自己制作。

### 发行版镜像

根据自己对发行版的需要下载发行版镜像，常用的 Linux 发行版会提供云平台虚拟机使用的镜像，地址如下:

- [centos](http://cloud.centos.org/centos/7/images/): http://cloud.centos.org/centos/7/images/
- [ubuntu](https://cloud-images.ubuntu.com/): https://cloud-images.ubuntu.com/

### 制作镜像

参考: [制作镜像](../create/)

## 上传镜像

下载或者制作完镜像后，可以通过界面操作和Climc命令行的形式将镜像上传到平台的 glance 服务。

### Climc命令

使用 `climc image-upload` 上传到云平台的 glance 服务，下面以下载 CentOS 提供的 CentOS-7-x86_64-GenericCloud-1711 举例:

```bash
# 下载 CentOS-7-x86_64-GenericCloud-1711.qcow2 
$ wget http://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud-1711.qcow2

# 上传镜像到云平台并名为 CentOS-7-x86_64-GenericCloud-1711.qcow2
$ climc image-upload --format qcow2 --os-type Linux --os-arch x86_64 --standard CentOS-7-x86_64-GenericCloud-1711.qcow2 ./CentOS-7-x86_64-GenericCloud-1711.qcow2
```

上传时间长短取决于网络环境和镜像大小，上传完成后需要查询镜像的状态，当状态变为 'active' 时，就可以拿来使用了。( 更多的关于镜像的查询参考: [镜像查询](../show/#查询镜像) )

```bash
$ climc image-show CentOS-7-x86_64-GenericCloud-1711.qcow2 | grep status
| status          | active |
```
使用 `climc image-upload --help` 获取各个参数解释。



