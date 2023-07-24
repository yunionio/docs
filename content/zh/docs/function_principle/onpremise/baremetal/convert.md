---
title: "物理机与宿主机互相转换"
weight: 9
description: >
  介绍物理机与宿主机之间如何互相转换
---

### 转换为宿主机

该功能用于将物理机设备转换成宿主机。物理机用于创建裸金属服务器，宿主机用于创建虚拟机。

#### 准备工作

1. 宿主机即安装了host服务的计算节点，在云管平台上将物理机转换为宿主机时需要使用由我司提供的专门制作的宿主机镜像，镜像可从下面地址获取：
    - v3.9 镜像：https://iso.yunion.cn/vm-images/host-convert-v39-20230404.qcow2
    - v3.9 UEFI 镜像(宿主机如果是 UEFI 启动)：https://iso.yunion.cn/vm-images/host-convert-uefi-v39-20230404.qcow2
2. 将该镜像上传到管理平台，并记录该镜像的id信息。
3. 在控制节点上通过climc命令设置物理机转换宿主机的默认镜像。

```bash
# 设置默认镜像的镜像id
$ climc service-config --config convert_hypervisor_default_template=a9b67435-8c08-4063-8ea6-d885ea26aa79 region2
```

4. 将物理机转换为宿主机时可直接选择磁盘RAID设置参数，进行转换宿主机操作。或通过自定义设置选择宿主机镜像，进行转换宿主机操作。

#### 操作步骤

<big>**climc操作**</big>

```bash
# 转换为宿主机
climc host-convert-hypervisor
```

### 回收为物理机

该功能用于将宿主机回收成物理机。当宿主机类型为KVM且包含IPMI信息时可转为宿主机。物理机用于创建裸金属服务器，宿主机用于创建虚拟机。

<big>**climc操作**</big>

```bash
# 回收为物理机
climc host-undo-convert <host_id>
```
