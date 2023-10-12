---
title: "Webhook"
weight: 100
description:
  介绍平台事件回调机制
---

平台的通知服务(notify)提供了回调webhook机制，允许外部系统实时接收平台的事件以及事件相关的资源信息。

## 如何启用Webhook通知

### 1. 创建webhook机器人

在认证与安全->消息中心->机器人管理页面中点击新建按钮,选择类型为Webhook的机器⼈。

### 2. 配置Webhook

关于header,body,msg_key字段的说明：
```

  header: 特指额外附加的webhook请求头，可为空。
  body: 特指额外附加的webhook报文，可为空。
  msg_key: 特指对于所需文案的key，可为空，为空时默认key为Msg

  注: 当body与msg_key同名时，body优先，会导致文案主体信息丢失，故msg_key与body不得同名。

```
例：

webhook配置: 

![](../images/webhook_config.jpg)

配置完成后点击确定，后确认webhook机器人状态为启用。

### 3. 启用消息订阅并指定接受人

在认证与安全->消息中心->消息订阅设置页面中，在你感兴趣消息的接收管理中新建机器⼈类型的接收⼈，并选择上述新创建的Webhook机器⼈。

⽬前⽐较统⼀的是配置
“资源创建、删除发送通知”,“资源调整配置发送通知”,“资源属性变更(含密码变更)发送通知”以及“资源同步发送通知”（也可能叫做“resource sync”）。

 - 资源属性变更(含密码变更)发送通知: 指在修改资源基础属性时会发送通知，如：修改资源名称，修改资源备注等。
 - 资源操作失败发送通知: 代表的是资源在执行操作时失败会发送通知，如：资源新建失败，资源调整配置失败等。
 - ...

配置完成后点击确定，后确认消息订阅状态为启用。

### 4. 最终Webhook效果
webhook接收到消息如下：

```

response header:
Host: xxx
User-Agent: yunioncloud-go/201708
Accept: */*
Accept-Encoding: *
Content-Type: application/json
Test: test // 此处为附加请求头
X-Request-Id: 60ec3e
X-Yunion-Event: HOST/UPDATE
X-Yunion-Parent-Id: 0
X-Yunion-Peer-Service-Name: notify
X-Yunion-Span-Id: 0.0
X-Yunion-Span-Name:
X-Yunion-Strace-Debug: true
X-Yunion-Strace-Id: e7b586c9

response body:
{
    "body_test":"test", // 此处为附加报文
    "test":"{\"action\":\"update\",\"resource_details\":{\"access_ip\":\"\",\"access_mac\":\"\",\"name\":"yunion",...\"}, \"resource_type\":\"host\",\"result\":\"succeed\"}", // 当msg_key为空时key默认为Msg
    "action":"update",
    "resource_details":{ // 此处为资源详细信息
        "access_ip":"",
        "access_mac":"",
        "is_baremetal":false,
        "is_emulated":false,
        "is_import":false,
        "is_maintenance":false,
        "is_prepaid_recycle":false,
        "is_public":true,
        "isolated_device_count":0,
        "manager_uri":"",
        "mem_cmtbound":1,
        "mem_commit":0,
        "mem_commit_bound":1,
        "mem_commit_rate":0,
        "mem_reserved":1328,
        "mem_size":11957,
        "metadata":{},
        "name":"yunion",
        ...
    },
    "resource_type":"host",
    "result":"succeed"
}

```

## 支持Webhook事件通知的资源

* 云管平台⽀持创建、删除、更新、删除的资源：宿主机，虚拟机、硬盘、RDS、Redis、LB、EIP、VPC、IP⼦⽹、安全组、证书、DNS、NAT、对象存储OSS、NAS；
* 云管平台支持更新的资源：虚拟机，用户，宿主机
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
  资源同步发送通知: 代表的是云账号同步触发的本地资源数据与云上资源数据的同步。

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

### 模板启用

目前还可通过climc命令调整webhook是否启用模板: climc notify-robot-update <robot-id> --use-template true

启用模板后，发出的报文将与常规机器人通知一致，将不再返回json数据，而是返回文案信息。


## 消息没有正常发送的可能原因

1、确认消息订阅、接受人、机器人是否启用，若为接受人，确保通知渠道是否正常。

2、确认资源是否在消息订阅的范围内。

3、确认是否模板异常导致通知失败
```
查看操作日志：climc action-show --type notification --fail

若出现template关键字，可通过删除notify.topic_tbl表后重启notify服务，重新覆盖模板文案（注：会导致丢失所有消息订阅关联关系）。
或修改notify.topic_tbl中的title_cn,title_en,content_cn,content_en字段，相关语法可参考go-template。
```

其他异常情况可通过issue反馈