---
title: "操作指南"
date: 2022-01-20T15:06:26+08:00
weight: 20
description: >
    介绍标签相关操作
---

**标签说明**

- 标签是一组键值对（key-value）。
- 一个资源支持绑定20个标签。
- 一个资源上的任一标签的键必须唯一，相同键的值将会覆盖。
- ![](../images/label1.png)：暂无标签。
- ![](../images/labelon1.png)：已有标签。

{{% alert title="说明" %}}
- 目前支持与公有云平台双向同步标签的资源：虚拟机、LB、NAT、CDN、NAS、RDS、Redis、MongoDB、Kafka、Elasticsearch等。
- 安全组、DNS、SSL证书等配置类资源由于与公有云平台存在一对多的关系，仅支持在{{<oem_name>}}平台管理标签，不支持与公有云平台双向同步标签。
{{% /alert %}}