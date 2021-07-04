---
title: "ARM(AArch64) 部署"
weight: 101
description: >
  介绍如何在 ARM(AArch64) 架构的机器上部署“Cloudpods”服务
---

## 简介

从 v3.6.10 版本开始，可以将”Cloudpods“部署到 ARM(AArch64) 架构的机器上，目前我们适配的 Linux 发行版是 [Debian 10(buster)](https://www.debian.org/releases/stable/arm64/) 和 [统信 UOS](https://www.chinauos.com/) 。

因为服务是容器化运行在 Kubernetes 之上的，为了在 ARM 架构的机器上运行容器，我们使用了 [docker buildx](https://github.com/docker/buildx/) 和交叉编译的技术编译打包了同时支持 x86_64 和 arm64 的统一容器镜像。这样的可以让 Kubernetes 屏蔽 CPU 架构的差异性，我们制作的支持多架构的容器镜像可以在不同架构的机器上运行服务，实现 X86 和 ARM 机器混合部署的效果。

## 部署

部署方式和原来的 X86 部署并没有太大差别，唯一的区别是我们 X86 上使用的 Linux 发行版是 CentOS 7 ，但在 ARM 架构的机器上需要安装 [Debian 10(buster)](https://www.debian.org/releases/stable/arm64/) 或者 [统信 UOS](https://www.chinauos.com/) 发行版。其它部署方式是一致的，使用我们编写的 https://github.com/yunionio/ocboot 部署工具来统一部署，这个工具里面包含了在 Debian 和 UOS 上部署的 ansible playbook 。

### 前提条件

- ARM 机器必须提前安装好 Debian 10 或者 UOS 操作系统
- ARM 机器能够访问公网
- ARM 机器开启 ssh 服务，保证运行 ocboot 的节点能够免密登录待部署的 ARM 机器

### 单节点 All in One 部署

单节点 All in One 部署是指把整个”Cloudpods“全部部署到一个节点，ARM 的部署和 X86 的部署没有任何区别，准备好环境后，直接参考 [All in One 安装](../../quickstart/allinone) 的部署流程即可。

### 多节点混合部署

多节点部署请先参考 [多节点安装](../../quickstart/nodes) 了解多节点安装准备工作和配置。接下来以一台 X86 和一台 ARM 机器演示混合部署的流程。

| 架构   | 操作系统  | IP            | 登录用户 | 角色                               |
|--------|-----------|---------------|----------|------------------------------------|
| X86_64 | CentOS 7  | 10.127.40.252 | root     | mariadb_node & primary_master_node |
| ARM64  | Debian 10 | 10.127.100.8  | root     | worker_nodes                       |

编写如下部署配置:

```bash
# 编写配置
$ vim ./config-hybrid.yml
# mariadb_node 表示要在 10.127.40.252 这台节点上部署 mariadb 数据库
mariadb_node:
  hostname: 10.127.40.252
  user: root
  db_user: root
  db_password: your-sql-password
# primary_master_node 表示将 10.127.40.252 作为第一个部署的 master 节点
# 上面会运行Cloudpods必要的控制服务
primary_master_node:
  onecloud_version: v3.6.15
  hostname: 10.127.40.252
  user: root
  db_host: 10.127.40.252
  db_user: root
  db_password: your-sql-password
  controlplane_host: 10.127.40.252
  controlplane_port: "6443"
  # onecloud 登录用户
  onecloud_user: admin
  # onecloud 登录用户密码
  onecloud_user_password: admin@123
  # as_host 表示将这个 master 节点作为私有云计算节点
  as_host: true
# worker_nodes 表示在 10.127.100.8 上部署内置私有云计算服务
# 同时会将 worker_nodes 角色的节点作为私有云计算节点
worker_nodes:
  hosts:
  # 如果有多台节点，可以在这里按照 YAML 数组的格式填写多个节点的 IP
  - hostname: 10.127.100.8
    user: root
  controlplane_host: 10.127.40.252
  controlplane_port: "6443"
```

使用 ocboot 安装 config-hybrid.yml 配置部署:

```bash
$ ./run.py ./config-hybrid.yml
....
# 部署完成后会有如下输出，表示运行成功
# 浏览器打开 https://10.127.40.252
# 使用 admin/admin@123 用户密码登录就能访问前端界面
Initialized successfully!
Web page: https://10.127.40.252
User: admin
Password: admin@123
```

部署完成后，登入前端就能发现混合部署的两台 X86 和 ARM 的宿主机，截图如下，aarch64 和 x86_64 分别对应 ARM64 和 X86_64 的 CPU 架构宿主机。

![宿主机前端列表](../images/host-hybrid-list.png)

## 创建 ARM 虚拟机

基于 ARM 的机器部署完服务后，请先阅读 [All in One/FAQ](../../quickstart/allinone/#faq) 和 [All in One/创建第一台虚拟机](../../quickstart/allinone/#创建第一台虚拟机) 了解创建虚拟机需要创建网络、启用宿主机和导入镜像等步骤。

### 导入镜像

对于 ARM(AArch64) 虚拟机来说需要使用对应的 ARM(AArch64) 虚拟机镜像，这里分别导入 ARM64 和 X86_64 的 CentOS 7 虚拟机镜像进行测试。

- ARM64 镜像 CentOS-7-aarch64-GenericCloud-2003.qcow2: https://cloud.centos.org/centos/7/images/CentOS-7-aarch64-GenericCloud-2003.qcow2
- X86_64 镜像 CentOS-7-x86_64-GenericCloud-1503.qcow2: https://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud-1503.qcow2

导入镜像后的截图如下:

![镜像列表](../images/image-hybrid-list.png)

### 创建虚拟机

镜像和对应的网路准备完成后，就可以到虚拟机创建界面根据需要选择不同 CPU 架构创建虚拟机。创建界面截图如下：

![虚拟机创建页面](../images/vm-hybrid-create.png)

分别创建 aarch64 和 x86_64 架构的虚拟机后，可以在虚拟机的列表页面看到每台虚拟机的 CPU 架构，截图如下:

![虚拟机列表页面](../images/vm-hybrid-list.png)
