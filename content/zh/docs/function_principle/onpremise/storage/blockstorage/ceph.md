---
title: "Ceph存储"
weight: 1
description: >
  如何配置和使用Ceph存储
---

Ceph是著名的开源分布式存储，一个存储集群可以同时提供块存储（RBD），对象存储（RadosGw）和文件存储（CephFs）三种接口。本文介绍虚拟机使用Ceph块存储的配置和使用方法。

## 支持Ceph版本

平台部署一台宿主机时，会默认安装 ceph-common 包，其中包含了开源版本的 ceph的客户端。安装的 ceph-common 版本如下：

* CentOS 7: 10.2.5
* CentOS 8: 12.2.8
* Kylin V10: 12.2.8
* Debian 10: 12.2.11
* Debian 11: 14.2.21
* OpenEuler 22.03 SP1: 16.2.7

如果用户需要其他版本的 ceph-common，例如用户对接的商用ceph，则需要自行手动在宿主机安装对应的 ceph-common。

## 网络要求

需要挂载是用Ceph的宿主机，需要能够直接网络访问Ceph集群。

## Ceph认证

每次在宿主机执行ceph的命令，会使用存储在storage的ceph秘钥生成临时ceph凭证文件，用于访问ceph存储。不会使用保存在宿主机/etc/ceph的凭证文件。