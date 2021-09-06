---
title: "健康检查"
date: 2021-07-05T08:22:33+08:00
weight: 1
description: >
    健康检查是通过余额信息判断云账号是否可以正常创建资源。
---


## 功能描述

- 部分公有云有消费限制,例如阿里云余额低于100则不能进行资源创建操作
- 为了尽可能的保证资源创建成功，系统默认会根据云账号余额信息, 自动设置云账号健康状态
- 云账号健康异常不会影响资源的同步，仅会限制资源创建操作，请尽快充值或关闭健康检查功能


## 特殊情况

- 由于部分企业可能与公有云签订协议，或者使用代金券，即使账号异常也依然可以创建资源，此项功能则极大限制了云平台的使用
- 用户可以根据需求自行开启关闭此功能

## 功能开关

```bash
# 此功能开关影响所有云账号

# 关闭云账号健康检查
$ climc service-config --config cloudaccount_health_status_check=false region2

# 开启云账号健康检查
$ climc service-config --config cloudaccount_health_status_check=true region2

```

{{% alert title="注意" color="warning" %}}
功能的开关不会立刻影响云账号状态，可以等待几分钟后云账号状态会更新
或者到云账号列表选定云账号，点击连接状态，云账号健康状态会随即更新
{{% /alert %}}
 
