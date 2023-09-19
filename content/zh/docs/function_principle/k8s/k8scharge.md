---
title: "容器计费"
weight: 82
description: >
  介绍如何对自建容器进行计费。
---

容器主要对容器组（Pod）和存储声明（Persistentvolumeclaim）两种资源进行计量和计费。

{{% alert title="说明" %}}
- 目前仅支持对{{<oem_name>}}自建K8S集群进行计费。
- 容器组（Pod）和存储声明（Persistentvolumeclaim）的费率需要在费用/高级设置/费率集中进行修改。
{{% /alert %}}

![](../../../function_principle/k8s/pre_env/images/podpvc.png)

## 容器组（Pod）的计量计费

1. 根据Pod的 cpu 和 memory 来计费。
2. Pod的状态为Running开始计费，不是Running停止计费。
3. Pod的费率支持按照cpu+memory的套餐计费，也支持对Pod的 cpu 和 memory 单独进行计费。

## 存储声明（Persistentvolumeclaim）的计量计费

1. 根据存储声明（Persistentvolumeclaim）的 capacity_mb 来计费。
2. 存储声明（Persistentvolumeclaim）的状态为Bounding时开始计费，不是Bounding时停止计费。

