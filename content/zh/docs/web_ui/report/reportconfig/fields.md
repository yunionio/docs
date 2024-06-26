---
title: "报表字段"
weight: 2
description: 报表字段是报表的组成元素，可以在这里维护报表字段，后续可以在报表模版中选择使用。
---

报表字段是报表的组成元素，可以在这里维护报表字段，后续可以在报表模版中选择使用。

**入口**：在云管平台单击左上角![](../../../images/intro/nav.png)导航菜单，在弹出的左侧菜单栏中单击 **_"报表/报表配置/报表字段"_** 菜单项，进入报表字段页面。

![](../../../images/report/fields.png)

## 新建报表字段

该功能用于新建报表字段。

1. 在报表字段页面，单击列表上方 **_"新建"_** 按钮，弹出新建报表字段对话框。
2. 配置以下参数：
   - 域：设置报表字段的归属域。
   - 列类型：支持选择资源字段、监控字段、费用信息、项目标签、固定值。
   - 当列类型选择资源字段时，配置以下参数：
      - 指标：选择具体的资源指标，例如虚拟机数量、磁盘总容量等。
      - 字段名：字段名是报表字段对应表头名称，支持自定义修改。
   - 当列类型选择监控字段时，配置以下参数：
      - 指标：选择具体的监控指标，例如CPU使用率、磁盘读速率等。
      - 字段名：字段名是报表字段对应表头名称，支持自定义修改。
   - 当列类型选择费用时，配置以下参数：
      - 字段名：字段名是报表字段对应表头名称，支持自定义修改。
   - 当列类型选择项目标签时，配置以下参数：
      - 标签键：选择项目标签的标签键。
      - 字段名：字段名是报表字段对应表头名称，支持自定义修改。
   - 当列类型选择固定值时，配置以下参数：
      - 列表值：输入自定义的列表值。
      - 字段名：字段名是报表字段对应表头名称，支持自定义修改。  
3. 单击 **_"确定"_** 按钮，创建报表字段。

## 删除

该功能用于删除报表字段。删除之前需要保证没有报表模板引用当前报表字段。支持多选批量删除报表字段。

1. 在报表字段页面，单击未被报表模板引用的报表字段右侧操作列 **_"删除"_** 按钮。
2. 单击 **_"确定"_** 按钮，完成操作。