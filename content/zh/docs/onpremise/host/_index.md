---
title: "宿主机"
date: 2019-07-17T11:35:12+08:00
weight: 20
description: >
  宿主机是运行虚拟机的物理服务器。
---

{{<oem_name>}} 原生提供基于 kvm 的私有云虚拟机管理功能，运行 kvm 虚拟机的机器叫做宿主机，这种宿主机也叫作 "计算节点"，上面会运行管理虚拟机、网络和存储的一系列服务。云平台的抽象的宿主机根据 hypervisor 字段判断不同平台的宿主机。现在支持的类型如下：

|    类型    |          平台          |
|:----------:|:----------------------:|
| hypervisor |  Cloudpods 私有云宿主机 |
| baremetal |  Cloudpods 私有云物理机 |
|    esxi    |      vmware 宿主机     |
|  openstack | openstack 私有云宿主机 |
|   zstack   |   zstack 私有云宿主机  |


