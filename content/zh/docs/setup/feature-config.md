---
title: "隐藏功能配置"
weight: 143
description: >
    介绍如何打开或者隐藏部分功能
---

## 前言

由 ocboot 部署的 Cloudpods 是基于 Cloudpods 开源代码构建的社区免费版。这个版本允许用户较方便地体验 Cloudpods 的功能。

Cloudpods 自2017年开始开发，有较长时间积累，但代码量大，功能繁多，有部分代码已经较长时间没有迭代维护。因此，我们计划在此社区免费版的前端选择性的隐藏具备以下特性的功能：

1. 不够成熟;
2. 缺人维护;
3. 少有人使用;
4. 复杂度比较高较难理解使用的功能组件；

这样可以降低维护支持成本，同时提升使用体验。

但隐藏功能的代码依然在开源项目的代码仓库中维护。基于这些原因，在 v3.8.7 版本，我们隐藏了认证源非 LDAP 部分的功能。如果用户对此功能有需求，可以选择如下的方式使用该功能：

1. 提issue申请打开这个功能；
2. 通过climc使用该功能；
3. fork自己的前端版本，把此功能打开。

后续发布版本中我们还会陆续隐藏一些功能，但会在版本发布中提前声明。

特此说明，希望得到社区用户的理解。

## 使用 climc 配置功能

比如在 3.9 版本中，我们默认隐藏了 k8s 容器集群管理、京东公有云管理等功能；默认打开了常用的阿里云、AWS 等公有云管理功能。用户可以通过 climc 命令行工具根据自身需要打开或者关闭对应的功能。

### 举例

子命令的格式和参数如下：

```bash
$ climc feature-config-$name --switch {on|off}
# $name: 表示具体的功能名，比如: k8s, s3, jdcloud 等
# on: 表示打开
# off: 表示关闭
```

比如开关 k8s 容器集群管理功能命令为：

```bash
# 打开
$ climc feature-config-k8s --switch on

# 关闭
$ climc feature-config-k8s --switch off
```

比如开关 京东云 管理功能命令为：

```bash
# 打开
$ climc feature-config-jdcloud --switch on

# 关闭
$ climc feature-config-jdcloud --switch off
```

### 功能参照表

| 名称      | 功能                 | climc 子命令             |
|-----------|----------------------|--------------------------|
| onestack  | 内置轻量私有云       | feature-config-onestack  |
| baremetal | 裸金属管理           | feature-config-baremetal |
| lb        | 负载均衡管理         | feature-config-lb        |
| aliyun    | 阿里公有云管理       | feature-config-aliyun    |
| aws       | AWS 亚马逊公有云管理 | feature-config-aws       |
| azure     | Azure 微软公有云管理 | feature-config-azure     |
| google    | Google 公有云管理    | feature-config-google    |
| qcloud    | 腾讯公有云管理       | feature-config-qcloud    |
| ctyun     | 天翼公有云管理       | feature-config-ctyun     |
| huawei    | 华为公有云管理       | feature-config-huawei    |
| ucloud    | ucloud 公有云管理    | feature-config-ucloud    |
| jdcloud   | 京东公有云管理       | feature-config-jdcloud   |
| vmware    | VMWare 管理          | feature-config-vmware    |
| openstack | openstack 私有云管理 | feature-config-openstack |
| dstack    | 滴滴私有云管理       | feature-config-dstack    |
| zstack    | zstack 私有云管理    | feature-config-zstack    |
| apsara    |                      | feature-config-apsara    |
| cloudpods | cloudpods 私有云管理 | feature-config-cloudpods |
| hcso      |                      | feature-config-hcso      |
| nutanix   |                      | feature-config-nutanix   |
| s3        | s3 存储管理          | feature-config-s3        |
| ceph      | ceph 存储管理        | feature-config-ceph      |
| xsky      | xsky 存储管理        | feature-config-xsky      |
| bill      |                      | feature-config-bill      |
| auth      |                      | feature-config-auth      |
| onecloud  |                      | feature-config-onecloud  |
| public    |                      | feature-config-public    |
| private   |                      | feature-config-private   |
| storage   |                      | feature-config-storage   |
| k8s       | k8s 容器集群管理     | feature-config-k8s       |
| monitor   | 监控运维功能         | feature-config-monitor   |
