---
title: "新建Redis实例"
date: 2021-11-29T10:46:29+08:00
weight: 10
description: >
    新建Redis实例
---

该功能用于新建Redis实例，目前仅支持创建阿里云、华为云、腾讯云的Redis实例。

1. 在左侧导航栏，选择 **_"数据库/Redis/Redis实例"_** 菜单项，进入Redis实例页面。
2. 单击列表上方 **_"新建"_** 按钮，进入新建Redis实例页面。
2. 配置以下参数：
    - 指定项目：管理员或域管理员在新建Redis实例时需要指定Redis实例所属项目。
    - 名称：Redis实例的名称。
    - 备注：设置Redis实例的备注信息。
    - 计费方式：包括按量付费、包年包月。
        - 按量付费：按Redis实例的实际使用量付费，此模式适用于设备需求量会瞬间大幅度增大的场景，价格对比包年包月要贵。
        - 包年包月：是一种预付费的模式，提前一次性支付一个月、一年乃至多年的费用，该模式适用于设备需求比较平稳的场景，价格相对按量付费更便宜。选择包年包月后还需要设置购买时长。
    - 到期释放：设置新建的Redis实例的使用时长，超过设置时间后的Redis实例将会被删除。仅按量付费的Redis实例支持到期释放。
    - 数量：设置创建的Redis实例的数量。
    - 区域：选择Redis实例所在地域，并在对应地域内选择平台、区域和可用区。不同地域支持的平台情况可能不同，请以实际界面为准。
    - 类型：即Redis。
    - 版本：Redis的版本信息。
        - 阿里云、腾讯云支持Redis 2.8、4、5；
        - 华为云支持Redis 4、5。
    - 实例类型：
        - 基础版：仅支持单副本。
        - 高可用：仅支持双副本。
        - 集群：阿里云、腾讯云集群支持单副本和双副本；华为云集群仅支持双副本。
        - 读写分离（仅阿里云支持）：Redis读写分离版本由代理服务器（Proxy Servers）、主备（Master and Replica）节点及只读（Read-Only）节点组成。
    - 节点类型：主要包括单副本、双副本、只读节点。
        - 单副本：单副本为单节点缓存架构，没有数据可靠性保障。
        - 双副本：双副本为一主一从的双机热备架构，数据持久化保存；
        - 只读节点：主节点写，从节点只读。支持选择只读节点（1个）、只读节点（3个）、只读节点（5个）。
    - 性能类型：支持标准性能和增强性能
    - 内存：根据内存可过滤出可用套餐。
    - 套餐：显示Redis实例的规格、平台、节点类型、备可用区、内存、CPU、存储架构、分片数、最大连接数、价格等信息。
    - 管理员密码：支持随机生成和手工输入管理员密码。
    - VPC：选择VPC和IP子网。
    - 安全组：选择安全组，限制实例的安全访问规则，最多可绑定5个安全组。仅腾讯云支持。
    - 标签：支持为新建的Redis实例绑定标签。支持选择已有标签和新建标签。
        - 新建标签：单击列表上方 **_新建_** 按钮，设置标签键和标签值，单击 **_"添加"_** 按钮，新建标签并绑定到资源上。
        - 选择已有标签：单击 **_"已有标签"_** 按钮，选择标签键和值。
3. 单击 **_"确定"_** 按钮，完成操作。