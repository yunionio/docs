---
title: "Kubernetes运维"
date: 2023-06-28T14:45:50+08:00
weight: 145
description: >
    介绍平台底座Kubernetes的运维管理
---

{{<oem_name>}} 运行在Kubernetes上，本章介绍Kubernetes集群的运维相关知识和技巧。

每个服务二进制都运行在Kubernetes的Pod种，如何诊断Pod内服务组件的问题，请参考 [排查pod异常](./poderror)

Pod与Pod之间的容器网络采用的是Calico网络插件，如何排查Pod网络问题，请参考 [排查Pod网络问题](./dnserror)

Kubernetes设计了驱逐容器(Eviction)的机制，在宿主机CPU，内存和存储被占用达到一定阈值后，Kubernetes会主动停止容器。这个机制对于无状态服务是有益的，能够提前规避因为宿主机资源不足导致的服务降级。但是对于有状态服务，例如每台宿主机的host服务，则该机制会放大资源不足的危害，本来只是资源不足导致可能的服务能力降级，却因为Eviction机制变为彻底的服务不可用。因此，我们应尽量避免Kubernetes触发Eviction。[调整Kubernetes节点驱逐的阈值](./eviction_threshold)介绍了调整Kubenetes容器集群的Eviction机制的方法。

Kubernetes并不具备systemd停止和启动服务的控制能力，[暂停集群服务](./halt_cluster.md)介绍了通过operator暂停和恢复服务的方法。