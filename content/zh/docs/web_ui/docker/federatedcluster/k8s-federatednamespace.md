---
title: "命名空间"
weight: 1
description: 命名空间用于逻辑上隔离Kubernetes集群中的资源。
---

命名空间用于逻辑上隔离Kubernetes集群中的资源。多集群命名空间支持将命名空间关联到多个集群，并在集群中创建相同名称的命名空间。

**入口**：在云管平台单击左上角![](../../../images/intro/nav.png)导航菜单，在弹出的左侧菜单栏中单击 **_"容器/多集群资源/命名空间"_** 菜单项，进入命名空间页面。

![](../../../images/docker/federatednamespace.png)

## 新建命名空间

该功能用于新建多集群命名空间。

1. 在命名空间页面，单击列表上方 **_"新建"_** 按钮，进入新建命名空间页面。
2. 设置命名空间的名称，单击 **_"新建"_** 按钮，创建多集群命名空间。

## 删除命名空间

该功能用于删除命名空间。当命名空间已绑定集群时，不能删除。

**单个删除**

1. 在命名空间页面，单击命名空间右侧操作列 **_"删除"_** 按钮，弹出操作确认对话框。
2. 单击 **_"确定"_** 按钮，完成操作。

**批量删除**

1. 在列表中选择一个或多个命名空间，单击列表上方 **_"删除"_** 按钮，弹出操作确认对话框。
2. 单击 **_"确定"_** 按钮，完成操作。

## 查看命名空间详情

该功能用于查看命名空间的详细信息。

1. 在命名空间页面，单击命名空间名称项，进入命名空间详情页面。
2. 查看以下信息：包括云上ID、ID、名称、域、项目、状态、创建时间、更新时间、备注。

## 已绑定集群资源管理

该功能用于将命名空间绑定或解绑到集群。

### 绑定到集群

该功能用于将命名空间关联到集群，在对应集群上创建对应的命名空间。

1. 在命名空间页面，单击命名空间名称项，进入命名空间详情页面。
2. 单击“已绑定集群资源”页签，进入已绑定资源页面。
3. 单击列表 **_"绑定到集群"_** 按钮，弹出绑定到集群对话框。
4. 选择集群，单击 **_"确定"_** 按钮，完成操作。

### 解绑

该功能用于解除多集群命名空间与集群的绑定关系，目前解绑后，集群不会删除对应的命名空间。

1. 在命名空间页面，单击命名空间名称项，进入命名空间详情页面。
2. 单击“已绑定集群资源”页签，进入已绑定资源页面。
3. 单击集群右侧操作列 **_"解绑"_** 按钮，弹出操作确认对话框。
4. 单击 **_"确定"_** 按钮，完成操作。

## 查看操作日志

该功能用于查看多集群命名空间相关的操作日志。

1. 在命名空间页面，单击命名空间名称项，进入命名空间详情页面。
2. 单击“操作日志”页签，进入操作日志页面。
    - 加载更多日志：列表默认显示20条操作日志信息，如需查看更多操作日志，请单击 **_"加载更多"_** 按钮，获取更多日志信息。
    - 查看日志详情：单击操作日志右侧操作列 **_"查看"_** 按钮，查看日志的详情信息。支持复制详情内容。
    - 查看指定时间段的日志：如需查看某个时间段的操作日志，在列表右上方的开始日期和结束日期中设置具体的日期，查询指定时间段的日志信息。
    - 导出日志：目前仅支持导出本页显示的日志。单击右上角![](../../../images/system/download.png)图标，在弹出的导出数据对话框中，设置导出数据列，单击 **_"确定"_** 按钮，导出日志。
