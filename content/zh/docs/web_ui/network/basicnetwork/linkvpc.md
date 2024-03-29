---
title: "VPC互联"
weight: 4
description: VPC互联实现两个及以上私有网络VPC互通，实现资源互通及访问Internet。
---

当VPC互联在云上创建后，云管平台VPC互联页面显示对应的记录，目前仅支持阿里云、腾讯云。

**入口**：在云管平台单击左上角![](../../../images/intro/nav.png)导航菜单，在弹出的左侧菜单栏中单击 **_"网络/基础网络/VPC互联"_** 菜单项，进入VPC互联页面。

  ![](../../../images/network/linkvpc1.png)

## 同步状态

该功能用于获取VPC互联的当前状态。

1. 单击VPC互联右侧操作列 **_"同步状态"_** 按钮，同步VPC互联状态。

## 管理VPC

该功能用于关联VPC实现资源互通及Internet访问。

1. 单击VPC互联右侧操作列  **_"管理VPC"_** 按钮，弹出管理VPC对话框，单击 **_"关联VPC"_** 按钮，进入配置VPC互联页面。
2. 配置以下参数：
   - 区域：选择平台及相应的区域。
   - VPC：选择云上VPC，同时展示对应的云订阅。
3. 单击 **_"确定"_** 按钮完成操作。

## VPC互联路由

该功能用于启用、禁用VPC互联路由。

1. 在VPC互联详情页面，单击“路由”页签，进入路由页面。
2. 启用、禁用VPC互联路由。

## 删除VPC互联

该功能用于删除VPC互联。

1. 单击VPC互联右侧操作列 **_"删除"_** 按钮，弹出操作确认对话框。
2. 单击 “确定” 按钮，完成操作。