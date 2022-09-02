---
title: "Webhook"
weight: 100
description:
  介绍平台事件回调机制
---

平台的通知服务(notify)提供了回调webhook机制，允许外部系统实时接收平台的事件以及事件相关的资源信息。

## 配置Webhook

⾸先需要在机器⼈管理界⾯，增加⼀个Webhook类型的机器⼈。

然后在消息订阅管理界⾯，在你感兴趣消息的接收管理中新建机器⼈类型的接收⼈，并选择上述新创建Webhook机器⼈。

⽬前⽐较统⼀的是配置
“资源创建、删除发送通知”,“资源调整配置发送通知”以及“资源同步发送通知”（也可能叫做“resource sync”）。

## 支持Webhook时间通知的资源

* 云管平台⽀持创建、删除、更新、删除的资源：虚拟机、硬盘、RDS、Redis、LB、EIP、VPC、IP⼦⽹、安全组、证书、DNS、NAT、对象存储OSS、NAS；
* 云管平台支持更新的资源：虚拟机，用户
* 云管平台只⽀持同步的资源：Webapp、Azure LB；
* 云管平台⽀持同步加删除的资源：CDN、WAF、Kafka、Elasticsearch、MongDB、TDSQL(RDS)、 Memcached(RDS )

## Webhook消息格式

Webhook回调请求都携带http header 'X-Yunion-Event'，代表触发Webhook回调通知的事件类型。

除"验证事件"外，reponse body示例如下：

```json
{
  "action": "<action>",
  "resource_type": "<resource_type>",
  "resource_details": {...}
}
```

都包含如下三个字段：

* action: 表示动作（create/update/delete 等等）
* resource_type: 表示资源类型，⽐如 server, user等
* resource_details: 表示资源的详情信息，其的内容与通过API获取的资源详细信息一致

### 资源同步事件

有三种特殊的action事件：sync_create/sync_update/sync_delete 代表的是云账号同步触发的本地资源数据与云上资源数据的同步。

* sync_create 同步了⼀个新的云上资源
* sync_update 本地资源根据云上资源更新
* sync_delete 本地资源对应的云上资源已经被删除

### 验证事件

添加webhook时，平台会向webhook发起VALIDATE类型的调用，webhook需要处理这类请求，返回200的成功响应。

```
Method: POST
Header:
 Content-Type: application/json
 X-Yunion-Event: VALIDATE
 User-Agent: yunioncloud-go/201708
 Content-Length: 37
 Accept: */*
 Accept-Encoding: *
Body:
{
 "Msg": "This is a validate message."
}
```
