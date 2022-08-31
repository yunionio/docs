---
title: "添加接收人"
date: 2021-12-03T14:49:22+08:00
weight: 10
description: >
    添加接收订阅消息的接收人或机器人
---

### 前提条件

- 已[新建接收人](../../../recipient/create)
- 已[新建机器人](../../../bot/create)

### 操作步骤

该功能用于新建接收消息通知的接收人或机器人等。

1. 在左侧导航栏，选择 **_"认证与安全/消息中心/消息订阅设置"_** 菜单项，进入消息订阅设置页面。
2. 单击消息右侧操作列 **_"接收管理"_** 按钮，进入详情-接收管理页面。
2. 单击列表上方 **_"新建"_** 按钮，弹出新建接收人对话框。
3. 配置以下参数：
    - 资源范围：限定发送消息通知的资源范围。
        - 当资源范围为“系统”时，则系统内所有资源变化都将发送消息通知。
        - 当资源范围为“域”并选择指定域时，仅指定域下的资源变化才会发送消息通知。
        - 当资源范围为“项目”并选择指定项目时，仅指定项目下的资源变化才会发送消息通知。
    - 类型：选择接收消息通知的类型，包括接收人、角色、机器人。
    - 接收人：当类型选择“接收人”时，需要选择接收资源消息通知的用户。
    - 角色：当类型选择“角色”时，需要指定角色的范围和角色。
        - 当范围为“全局”时，将会通知全系统中对应角色的用户。
        - 当范围为“域”时，将会通知资源所在域下对应角色的用户。
        - 当范围为“项目”时，将会通知资源所在项目下对应角色的用户。
    - 机器人：当类型选择“机器人”时，需要选择接收资源消息通知的机器人。
4. 单击 **_"确定"_** 按钮，完成操作。