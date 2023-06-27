---
title: "暂停集群服务"
date: 2022-11-22T18:38:00+08:00
weight: 200
description: >
    介绍暂停集群服务的方法
---

在运维维护集群过程中，例如维护集群数据库等，需要暂停集群服务。本文介绍如何不影响虚拟机正常运行的前提下暂停 {{<oem_name>}} 服务的方法。

## 停止服务

平台服务由 operator 管理，可以通过给 operator 添加 '-stop-services' 启动参数，停止大部分控制服务。为了不影响虚拟机的正常运行，部分控制服务应保持继续运行，比如：default-ovn-north、default-influxdb和default-host。

```bash
$ kubectl edit deployment -n onecloud onecloud-operator
  template:
    metadata:
      creationTimestamp: null
      labels:
        k8s-app: onecloud-operator
    spec:
      containers:
      - command:
        - /bin/onecloud-controller-manager
        - -stop-services # 改这个地方，加上 '-stop-services' 参数
```

然后 operator 会重建，开始删除控制服务，最终还保留的 pod 如下：

```bash
$ kubectl get pods -n onecloud
NAME                                 READY   STATUS    RESTARTS   AGE
default-etcd-swbzmncg2x              1/1     Running   0          16d
default-host-xqwr6                   3/3     Running   0          19h
default-influxdb-7476dbb84c-6qhqm    1/1     Running   0          10d
default-ovn-north-67b97ffcfd-54lvp   1/1     Running   0          10d
onecloud-operator-6967685b4-6p2qx    1/1     Running   0          80s
```


## 恢复服务

删除 onecloud-operator deployment command 里面的 '-stop-services' 启动参数，operator 会重建之前删除的服务。

```bash
$ kubectl edit deployment -n onecloud onecloud-operator
```
