---
title: "操作指南"
date: 2022-01-04T10:57:23+08:00
weight: 20
description: >
    介绍全局VPC的相关操作
---

谷歌云VPC在没有访问控制的情况下各区域的IP子网之间可以互相通信。谷歌云VPC与其它公有云平台VPC不同，属于“全局”资源，没有“区域”属性，因此在{{<oem_name>}}平台将谷歌云VPC定义为全局VPC。并将VPC下的IP子网虚拟出{{<oem_name>}}平台上的VPC记录。

- 在{{<oem_name>}}创建全局VPC即创建谷歌云VPC。
- 在{{<oem_name>}}创建谷歌云VPC即在谷歌云VPC下创建IP子网。

