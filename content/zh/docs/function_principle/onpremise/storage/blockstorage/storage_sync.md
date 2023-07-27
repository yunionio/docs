---
title: "存储信息采集"
weight: 2000
description: >
  介绍存储信息的同步
---

一个存储被平台纳管后，平台的周期性采集存储的信息。

## 工作原理

块存储的信息采集由宿主机的host服务负责。

配置一个存储后，平台会从关联的宿主机中根据一致性Hash算法选择一台MastHost用于这个存储的信息采集。

该Host周期性调用GetStorageInfo的接口，获取存储的容量信息

## 采集频率

host服务采集存储信息的频率由host的配置项 sync_storage_info_duration_second 控制，默认为每120秒采集一次。