---
title: "新建PublicZone域名"
date: 2021-11-25T14:39:13+08:00
weight: 20
description: >
    新建PublicZone类型域名并将其同步到公有云
---


PublicZone域名即公共DNS解析服务，用户可以通过Internet之前访问域名。

**使用流程**：

- 新建PublicZone域名，请确保PublicZone类型的域名已经在Internet上进行注册。
- 在域名详情-记录中添加记录。
- 通过新建缓存同步到公有云，目前支持平台：阿里云、腾讯云、AWS。


### 新建PublicZone域名

该功能用于新建PublicZone域名。

1. 在左侧导航栏，选择 **_"网络/网络服务/DNS解析"_** 菜单项，进入DNS解析页面。
2. 单击列表上方 **_"新建"_** 按钮，弹出新建域名对话框。
2. 配置以下参数：
   - 指定域：选择DNS解析所属的域。
   - 解析域类型：选择PublicZone域名。
   - 域名：设置需要解析的域名。其中PublicZone类型目前仅支持二级域名。
   - 备注：设置DNS域名的备注信息。
   - 标签：支持为新建的DNS域名绑定标签。支持选择已有标签和新建标签。
        - 新建标签：单击列表上方 **_新建_** 按钮，设置标签键和标签值，单击 **_"添加"_** 按钮，新建标签并绑定到资源上。
        - 选择已有标签：单击 **_"已有标签"_** 按钮，选择标签键和值。
3. 单击 **_"确定"_** 按钮，进入同步到公有云页面。
4. 如需要将域名同步到公有云，需要选择平台以及云订阅，配置完成后，单击 **_"确定"_** 按钮。
5. 如暂不需要将域名同步到公有云，则直接单击 **_"跳过"_** 按钮即可。

```
# 新建域名命令
climc dns-zone-create [--status STATUS] [--enabled] [--vpc-ids VPC_IDS] [--cloudaccount-id CLOUDACCOUNT_ID] [--options OPTIONS] [--de
scription <DESCRIPTION>] <NAME> <zone_type>

# 新建阿里云账号上的PublicZone域名

climc dns-zone-create test.com PublicZone --cloudaccount-id aliyun 

```

### 同步到公有云

可通过新建缓存的功能将PublicZone类型的DNS解析同步到公有云。

1. 在左侧导航栏，选择 **_"网络/网络服务/DNS解析"_** 菜单项，进入DNS解析页面。
2. 单击域名名称项，进入DNS解析详情页面。
2. 单击“缓存列表”页签，进入缓存列表页面。
3. 单击列表上方 **_"新建"_** 按钮，弹出新建缓存对话框。
4. 选择平台和对应平台的云订阅。
5. 单击 **_"确定"_** 按钮，将DNS解析域名同步到对应公有云平台的指定账号下。