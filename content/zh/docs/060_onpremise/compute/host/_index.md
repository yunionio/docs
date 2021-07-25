---
title: "宿主机"
date: 2019-07-17T11:35:12+08:00
weight: 20
---

宿主机(host): 指运行虚拟机的机器，云平台的抽象的宿主机根据 hypervisor 字段判断不同平台的宿主机。现在支持的类型如下：

|    类型    |          平台          |
|:----------:|:----------------------:|
| hypervisor |  Cloudpods 私有云宿主机 |
| baremetal |  Cloudpods 私有云物理机 |
|    esxi    |      vmware 宿主机     |
|  openstack | openstack 私有云宿主机 |
|   zstack   |   zstack 私有云宿主机  |
