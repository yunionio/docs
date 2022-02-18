---
title: "多云管理"
date: 2019-07-19T20:56:33+08:00
weight: 70
description: >
  介绍 Cloudpods 多云管理的内容，包括纳管资源模型和支持的API。
---

Cloudpods支持对接多个云平台的多种云产品，统一多云API和资源模型，实现多云统一融合，简化使用多云的复杂度，提高访问多云的效率。

## 云平台云产品支持情况

以下为v3.8对各个云平台的各类云产品的支持情况。

- Y: 支持(增删查改)
- N: 不支持
- -: 平台本身不支持
- D: 开发过程中
- R: 只读同步

| 云平台(Provider)        | 虚拟机 | 区域 | 可用区 | 项目 | 镜像 | 安全组 | 磁盘 | 快照 | 宿主机 | VPC | 弹性网卡 | 二层网络 | EIP | NAT | 负载均衡 | WAF | DNS | 路由表 | CDN | RDS | MongoDB | 弹性缓存 | 对象存储 | NAS | Kafka | Elasticsearch | 应用程序服务 | 容器 | IAM | 标签 | 操作日志 |
|----------------------|-----|----|-----|----|----|-----|----|----|-----|-----|------|------|-----|-----|------|-----|-----|-----|-----|-----|---------|------|------|-----|-------|---------------|--------|----|-----|----|------|
| 内置私有云(Cloudpods)     | Y   | Y  | Y   | Y  | Y  | Y   | Y  | Y  | Y   | Y   | Y    | Y    | Y   | -   | Y    | -   | Y   | Y   | N   | -   | N       | -    | -    | -   | -     | -             | -      | Y  | Y   | Y  | Y    |
| 阿里云(Aliyun)          | Y   | Y  | Y   | Y  | Y  | Y   | Y  | Y  | -   | Y   | R    | -    | Y   | Y   | Y    | R   | Y   | R   | R   | Y   | R       | Y    | Y    | Y   | R     | N             | N      | N  | Y   | Y  | Y    |
| 腾讯云(Qcloud)          | Y   | Y  | Y   | Y  | Y  | Y   | Y  | Y  | -   | Y   | R    | -    | Y   | R   | Y    | N   | Y   | R   | R   | Y   | R       | Y    | Y    | N   | R     | R             | N      | N  | Y   | Y  | Y    |
| 华为云(Huawei)          | Y   | Y  | Y   | Y  | Y  | Y   | Y  | Y  | -   | Y   | R    | -    | Y   | Y   | Y    | N   | N   | R   | N   | Y   | N       | Y    | Y    | Y   | N     | N             | N      | N  | Y   | Y  | Y    |
| 微软云(Azure)           | Y   | Y  | -   | Y  | Y  | Y   | Y  | Y  | -   | Y   | R    | -    | Y   | -   | R    | R   | N   | N   | N   | R   | N       | N    | Y    | N   | N     | N             | R      | N  | Y   | Y  | Y    |
| 谷歌云(Google)          | Y   | Y  | Y   | -  | Y  | Y   | Y  | Y  | -   | Y   | -    | -    | Y   | N   | R    | N   | N   | N   | N   | Y   | N       | N    | Y    | N   | N     | N             | N      | N  | Y   | Y  | N    |
| AWS(AWS)             | Y   | Y  | Y   | N  | Y  | Y   | Y  | Y  | -   | Y   | N    | -    | Y   | R   | Y    | R   | Y   | R   | N   | R   | N       | N    | Y    | N   | N     | N             | N      | N  | Y   | Y  | Y    |
| 优刻得(Ucloud)          | Y   | Y  | Y   | N  | Y  | Y   | Y  | Y  | -   | Y   | Y    | -    | Y   | N   | N    | N   | N   | N   | N   | N   | N       | N    | Y    | N   | N     | N             | N      | N  | N   | N  | N    |
| 天翼云(Ctyun)           | Y   | Y  | Y   | N  | Y  | Y   | Y  | N  | -   | Y   | N    | -    | Y   | N   | N    | N   | N   | N   | N   | N   | N       | N    | N    | N   | N     | N             | N      | N  | N   | N  | N    |
| 移动云(Ecloud)          | R   | Y  | Y   | N  | R  | R   | R  | N  | -   | R   | -    | -    | R   | N   | N    | N   | N   | N   | N   | N   | N       | N    | N    | N   | N     | N             | N      | N  | N   | N  | N    |
| 京东云(JDcloud)         | R   | Y  | Y   | N  | R  | R   | R  | R  | -   | R   | N    | -    | R   | N   | N    | N   | N   | N   | N   | N   | N       | N    | N    | N   | N     | N             | N      | N  | N   | N  | N    |
| VMware(VMware)       | Y   | -  | -   | -  | Y  | -   | Y  | N  | R   | -   | -    | -    | -   | -   | -    | -   | -   | -   | N   | -   | N       | -    | -    | -   | N     | -             | -      | N  | -   | N  | -    |
| OpenStack(OpenStack) | Y   | Y  | Y   | N  | Y  | Y   | Y  | Y  | R   | Y   | R    | -    | Y   | N   | Y    | -   | N   | R   | N   | -   | N       | -    | N    | N   | N     | -             | -      | N  | N   | Y  | N    |
| ZStack(ZStack)       | Y   | -  | Y   | N  | Y  | Y   | Y  | Y  | R   | -  | R    | -    | -   | -   | N    | -   | N   | N   | N   | -   | N       | -    | -    | N   | N     | -             | -      | N  | N   | N  | N    |
| 阿里私有云(Apsara)        | Y   | Y  | Y   | N  | R  | Y   | Y  | Y  | -   | Y   | R    | -    | Y   | R   | Y    | -   | N   | R   | N   | Y   | N       | Y    | -    | N   | N     | -             | -      | N  | N   | N  | N    |
| HCSO(HCSO)                 | Y   | Y  | Y   | N  | R  | Y   | Y  | Y  | -   | Y   | R    | -    | Y   | R   | R    | -   | N   | N   | N   | Y   | N       | N    | -    | N   | N     | -             | -      | N  | N   | N  | N    |
| Nutainx              | Y   | -  | -   | -  | Y  | -   | Y  | N  | R   | Y   | R    | Y    | -   | -   | -    | -   | -   | -   | N   | -   | N       | -    | -    | -   | N     | -             | -      | N  | -   | -  | -    |
| S3(S3)               | -   | -  | -   | -  | -  | -   | -  | -  | -   | -   | -    | -    | -   | -   | -    | -   | -   | -   | -   |     | -       | -    | Y    | -   | -     | -             | -      | -  | -   | -  | -    |
| Ceph(Ceph)           | -   | -  | -   | -  | -  | -   | -  | -  | -   | -   | -    | -    | -   | -   | -    | -   | -   | -   | -   |     | -       | -    | Y    | -   | -     | -             | -      | -  | -   | -  | -    |
| Xsky(Xsky)           | -   | -  | -   | -  | -  | -   | -  | -  | -   | -   | -    | -    | -   | -   | -    | -   | -   | -   | -   |     | -       | -    | Y    | -   | -     | -             | -      | -  | -   | -  | -    |

