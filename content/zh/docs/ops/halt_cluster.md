---
title: "暂停集群服务"
date: 2022-11-22T18:38:00+08:00
weight: 81
description: >
    介绍暂停集群服务的方法
---

在运维维护集群过程中，例如维护集群数据库等，需要暂停集群服务。本文介绍如何不影响虚拟机正常运行的前提下暂停 {{<oem_name>}} 服务的方法。

## 停止服务

### 停止onecloud-operator

集群由onecloud-operator创建并维护，为了暂停集群服务，需要暂时停止operator的运行。方法为修改deployment onecloud-operator，修改pod的replicas为0，从而删除operator的实例

```
kubectl -n onecloud edit deployment onecloud-operator
```

### 停止部分控制服务

通过删除控制服务的deployment实现停止控制服务。然而，为了不影响虚拟机的正常运行，部分控制服务应保持继续运行：default-ovn-north、default-influxdb。

```
kubectl -n onecloud get deployments | awk '{print $1}' | grep -v default-ovn-north | grep -v default-influxdb | xargs kubectl -n onecloud delete deployments
```

### 停止部分daemonset服务

还有部分daemonset服务需要停止：default-region-dns、default-yunionagent。

```
kubectl -n onecloud delete daemonsets default-region-dns default-yunionagent
```

## 恢复服务

通过恢复onecloud-operator实例来恢复服务。修改onecloud-operator的replicas为1，保存退出后，等待集群服务恢复。

