---
title: "Elasticsearch"
weight: 2
description: >
 Elasticsearch是一个基于Lucene的实时分布式的搜索与分析引擎。
---

Elasticsearch是一个基于Lucene的实时分布式的搜索与分析引擎，集成了安全、SQL、机器学习、告警、监控等高级特性，被广泛应用于实时日志分析处理、信息检索、以及数据的多维查询和统计分析等场景。

目前仅支持只读对接腾讯云的Elasticsearch。

**入口**：在云管平台单击左上角![](../../images/intro/nav.png)导航菜单，在弹出的左侧菜单栏中单击 **_"中间件/数据分析/Elasticsearch"_** 菜单项，进入Elasticsearch列表。

![](../../images/middleware/elasticsearch.png)


## 同步状态

该功能用于获取Elasticsearch的当前状态。

**单个同步状态**

1. 在Elasticsearch页面，单击列表右侧操作列 **_"同步状态"_** 按钮，同步Elasticsearch状态。

**批量同步状态**

1. 在Elasticsearch页面，单击列表上方操作列 **_"同步状态"_** 按钮，同步Elasticsearch状态。

## 设置删除保护

该功能用于设置Elasticsearch的删除保护。当Elasticsearch启用删除保护后，Elasticsearch无法被删除；当Elasticsearch禁用删除保护后，Elasticsearch才可以被删除。

**单个Elasticsearch设置删除保护**

1. 禁用删除保护：
    - 单击Elasticsearch名称右侧带有![](../../images/computing/delprotect1.png)图标时，单击Elasticsearch右侧操作列 **_"更多"_** 按钮，选择下拉菜单 **_"设置删除保护"_** 菜单项，弹出设置删除保护对话框。
    - 选择"禁用"删除保护，单击 **_"确定"_** 按钮。
2. 启用删除保护：
    - 当Elasticsearch名称右侧不带![](../../images/computing/delprotect1.png)图标时，单击Elasticsearch右侧操作列 **_"更多"_** 按钮，选择下拉菜单 **_"设置删除保护"_** 菜单项，弹出设置删除保护对话框。
    - 选择"启用"删除保护，单击 **_"确定"_** 按钮。

**批量设置删除保护**

1. 禁用删除保护：
    - 在Elasticsearch列表中勾选一个或多个Elasticsearch，单击列表上方 **_"批量操作"_** 按钮，选择下拉菜单 **_"设置删除保护"_** 菜单项，弹出设置删除保护对话框。
    - 选择"禁用"删除保护，单击 **_"确定"_** 按钮，批量为Elasticsearch禁用删除保护。
2. 启用删除保护：
    - 在Elasticsearch列表中勾选一个或多个Elasticsearch，单击列表上方 **_"批量操作"_** 按钮，选择下拉菜单 **_"设置删除保护"_** 菜单项，弹出设置删除保护对话框。
    - 选择"启用"删除保护，单击 **_"确定"_** 按钮，批量为Elasticsearch启用删除保护。

## 删除

该功能用于删除Elasticsearch，当Elasticsearch名称项右侧有![](../../images/computing/delprotect1.png)图标，表示Elasticsearch启用了删除保护，无法删除Elasticsearch，如需删除Elasticsearch，需要先禁用删除保护。

**单个删除**

1. 在Elasticsearch页面，单击Elasticsearch右侧操作列 **_"更多"_** 按钮，选择下拉菜单 **_"删除"_** 菜单项，弹出操作确认对话框。
2. 单击 **_"确定"_** 按钮，完成操作。

**批量删除**

1. 在Elasticsearch列表中选择一个或多个Elasticsearch，单击列表上方 **_"批量操作"_** 按钮，选择下拉菜单 **_"删除"_** 菜单项，弹出操作确认对话框。
2. 单击 **_"确定"_** 按钮，完成操作。

## 查看Elasticsearch详情

该功能用于查看Elasticsearch的详细信息。

1. 在Elasticsearch页面，单击Elasticsearch名称项，进入Elasticsearch详情页面。
2. 查看以下信息。
    - 基本信息：包括云上ID、ID、名称、状态、域、项目、共享范围、平台、区域、可用区、云账号、云订阅、创建时间、更新时间、备注。
    - 配置信息：包括类型、配置、版本、存储。
    - 其他信息：支持开启或关闭删除保护。

## 查看Elasticsearch操作日志

该功能用于查看Elasticsearch相关操作的日志信息。

1. 在Elasticsearch页面，单击Elasticsearch的名称项，进入Elasticsearch详情页面。
2. 单击“操作日志”页签，进入操作日志页面。
    - 加载更多日志：列表默认显示20条操作日志信息，如需查看更多操作日志，请单击 **_"加载更多"_** 按钮，获取更多日志信息。
    - 查看日志详情：单击操作日志右侧操作列 **_"查看"_** 按钮，查看日志的详情信息。支持复制详情内容。
    - 查看指定时间段的日志：如需查看某个时间段的操作日志，在列表右上方的开始日期和结束日期中设置具体的日期，查询指定时间段的日志信息。
    - 导出日志：目前仅支持导出本页显示的日志。单击右上角![](../../images/system/download.png)图标，在弹出的导出数据对话框中，设置导出数据列，单击 **_"确定"_** 按钮，导出日志。
