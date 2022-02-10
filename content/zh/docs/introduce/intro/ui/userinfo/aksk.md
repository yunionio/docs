---
title: "访问凭证"
date: 2022-02-09T16:07:12+08:00
edition: ee
weight: 50
description: >
    提供AKSK作为访问平台的凭证以及作为其他系统的认证提供者
---

### AccessKey管理

云管平台支持Accesskey，第三方应用可通过Accesskey和AccessSecret来连接访问云管平台。

1. 单击顶部区域右上角用户图标，选择下拉菜单 **_"访问凭证"_** 菜单项，进入访问凭证页面。
2. 默认为AccessKey管理页签，支持以下操作。
   - 新建AccessKey：单击列表上方 **_"新建"_** 按钮，新建用户AccessKey，请妥善保存用户的AccessKey Secret信息，该信息仅在创建时显示一次。
   - 启用AccessKey：单击"禁用"状态的AccessKey右侧操作列 **_"启用"_** 按钮，启用"禁用"状态的AccessKey。
   - 禁用AccessKey：单击"启用"状态的AccessKey右侧操作列 **_"禁用"_** 按钮，禁用"启用"状态的AccessKey。
   - 删除AccessKey：
      - 单个删除：单击AccessKey右侧操作列 **_删除_** 按钮，在弹出的删除确认对话框中单击 **_"确定"_** 按钮，删除AccessKey信息。
      - 批量删除：在列表中选择一个或多个AccessKey，单击列表上方 **_删除_** 按钮，在弹出的删除确认对话框中单击 **_"确定"_** 按钮，删除AccessKey信息。

##### OpenID Connect/OAuth2管理

云管平台支持作为其他系统的认证提供者，例如Grafana、Kubernetes等。

1. 单击顶部区域右上角用户图标，选择下拉菜单 **_"访问凭证"_** 菜单项，进入访问凭证页面。
2. 单击“OpenID Connect/OAuth2”页签，进入OpenID Connect/OAuth2页面。
3. 列表上方将显示OpenID Connect连接信息，支持复制。
4. 支持以下操作。
   - 新建OpenID Connect/OAuth2： 单击列表上方 **_新建_** 按钮，弹出新建OpenID Connect/OAuth2对话框，设置回调地址，单击 **_"确定"_** 按钮
   - 启用OpenID Connect/OAuth2：单击"禁用"状态的OpenID Connect/OAuth2右侧操作列 **_"启用"_** 按钮，启用"禁用"状态的OpenID Connect/OAuth2。
   - 禁用OpenID Connect/OAuth2：单击"启用"状态的OpenID Connect/OAuth2右侧操作列 **_"禁用"_** 按钮，禁用"启用"状态的OpenID Connect/OAuth2。
   - 删除OpenID Connect/OAuth2：
       - 单个删除：单击OpenID Connect/OAuth2右侧操作列 **_删除_** 按钮，在弹出的删除确认对话框中单击 **_"确定"_** 按钮，删除OpenID Connect/OAuth2信息。
       - 批量删除：在列表中选择一个或多个OpenID Connect/OAuth2，单击列表上方 **_删除_** 按钮，在弹出的删除确认对话框中单击 **_"确定"_** 按钮，删除OpenID Connect/OAuth2信息。