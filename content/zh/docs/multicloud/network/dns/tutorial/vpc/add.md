---
title: "关联VPC"
date: 2021-11-25T18:35:18+08:00
weight: 10
description: >
    将PrivateZone类型域名关联VPC
---

该功能用于将PrivateZone类型的解析域名关联到VPC。仅域名状态可用时才支持该操作。

1. 在左侧导航栏，选择 **_"网络/网络服务/DNS解析"_** 菜单项，进入DNS解析页面。
2. 单击“PrivateZone”类型的域名名称项，进入DNS解析详情页面。
2. 单击“关联VPC”页签，进入关联VPC页面。
3. 单击列表上方 **_"关联VPC"_** 按钮，弹出关联VPC对话框。
4. 设置以下参数：
   - 区域：设置区域，并通过区域过滤VPC。可通过城市、平台快速过滤筛选出合适区域。
   - VPC：选择要关联的VPC，关联后将会把DNS解析域名同步到VPC所在平台账号中。
5. 单击 **_"确定"_** 按钮，完成操作。 

```bash
# 关联VPC
$ climc dns-zone-add-vpcs <DNS解析域名ID或名称> <VPC_IDS>
```