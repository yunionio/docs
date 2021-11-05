---
title: "多云管理"
date: 2019-07-19T20:56:33+08:00
weight: 70
description: >
  介绍 Cloudpods 多云管理的内容，包括纳管资源模型和支持的API。
---

Cloudpods支持对接多个云平台的多种云产品，统一多云API和资源模型，实现多云统一融合，简化使用多云的复杂度，提高访问多云的效率。

## 云平台云产品支持情况

以下为v3.7对各个云平台的各类云产品的支持情况。

- Y: 支持(增删查改)
- N: 不支持
- -: 平台本身不支持
- D: 开发过程中
- R: 只读同步

| 云平台(Provider)      | 虚拟机| 区域| 可用区| 项目| Vpc| 弹性网卡| 二层网络| Eip| NAT  | 安全组| 镜像| 磁盘| 快照 | 宿主机| 负载均衡| RDS| 对象存储 | 标签 | 弹性缓存| 操作日志| NAS  | WAF | IAM | DNS | VPC对等连接| 路由表|
| :---------------------| :-----| :---| :-----| :---| :--| :-------| :-------| :--| :----| :-----| :---| :---| :----| :-----| :-------| :--| :------  | :----| :------ | :-------| :----| :---| :---| :-- | :------    | :-----|
| 内置私有云(Cloudpods)  | Y     | Y   | Y     | Y   | Y  | Y       | Y       | Y  | -    | Y     | Y   | Y   | Y    | Y     | Y       | -  | -        | Y    | -       | Y       | -    | -   | Y   | Y   | -          | Y     |
| 阿里云(Aliyun)        | Y     | Y   | Y     | Y   | Y  | R       | -       | Y  | Y    | Y     | Y   | Y   | Y    | -     | Y       | Y  | Y        | Y    | Y       | Y       | Y    | D   | Y   | Y   | N          | R     |
| 腾讯云(Qcloud)        | Y     | Y   | Y     | Y   | Y  | R       | -       | Y  | R    | Y     | Y   | Y   | Y    | -     | Y       | Y  | Y        | Y    | Y       | Y       | N    | N   | Y   | Y   | Y          | R     |
| 华为云(Huawei)        | Y     | Y   | Y     | Y   | Y  | R       | -       | Y  | Y    | Y     | Y   | Y   | Y    | -     | Y       | Y  | Y        | Y    | Y       | Y       | Y    | N   | Y   | N   | Y          | Y     |
| 微软云(Azure)         | Y     | Y   | -     | Y   | Y  | R       | -       | Y  | -    | Y     | Y   | Y   | Y    | -     | N       | R  | Y        | Y    | N       | Y       | N    | D   | Y   | N   | N          | N     |
| 谷歌云(Google)        | Y     | Y   | Y     | -   | Y  | -       | -       | Y  | N    | Y     | Y   | Y   | Y    | -     | N       | Y  | Y        | Y    | N       | N       | N    | N   | Y   | N   | N          | N     |
| AWS(AWS)              | Y     | Y   | Y     | N   | Y  | N       | -       | Y  | N    | Y     | Y   | Y   | Y    | -     | Y       | R  | Y        | Y    | N       | Y       | N    | D   | Y   | Y   | Y          | Y     |
| 优刻得(Ucloud)        | Y     | Y   | Y     | N   | Y  | Y       | -       | Y  | N    | Y     | Y   | Y   | Y    | -     | N       | N  | Y        | N    | N       | N       | N    | N   | N   | N   | N          | N     |
| 天翼云(Ctyun)         | Y     | Y   | Y     | N   | Y  | N       | -       | Y  | N    | Y     | Y   | Y   | N    | -     | N       | N  | N        | N    | N       | N       | N    | N   | N   | N   | N          | N     |
| 移动云(Ecloud)        | R     | Y   | Y     | N   | R  | -       | -       | R  | N    | R     | R   | R   | N    | -     | N       | N  | N        | N    | N       | N       | N    | N   | N   | N   | N          | N     |
| VMware(VMware)        | Y     | -   | -     | -   | -  | -       | -       | -  | -    | -     | Y   | Y   | N    | R     | -       | -  | -        | N    | -       | -       | -    | -   | -   | -   | -          | -     |
| OpenStack(OpenStack)  | Y     | Y   | Y     | N   | Y  | R       | -       | Y  | N    | Y     | Y   | Y   | Y    | R     | Y       | N  | N        | Y    | -       | N       | N    | -   | N   | N   | -          | R     |
| ZStack(ZStack)        | Y     | -   | Y     | N   | Y  | R       | -       | Y  | -    | Y     | Y   | Y   | Y    | R     | N       | -  | -        | N    | -       | N       | N    | -   | N   | N   | -          | N     |
| 阿里私有云(Apsara)    | Y     | Y   | Y     | N   | Y  | R       | -       | Y  | R    | Y     | R   | Y   | Y    | -     | Y       | Y  | -        | N    | Y       | N       | N    | -   | N   | N   | N          | R     |
| S3(S3)                | -     | -   | -     | -   | -  | -       | -       | -  | -    | -     | -   | -   | -    | -     | -       | -  | Y        | -    | -       | -       | -    | -   | -   | -   | -          | -     |
| Ceph(Ceph)            | -     | -   | -     | -   | -  | -       | -       | -  | -    | -     | -   | -   | -    | -     | -       | -  | Y        | -    | -       | -       | -    | -   | -   | -   | -          | -     |
| Xsky(Xsky)            | -     | -   | -     | -   | -  | -       | -       | -  | -    | -     | -   | -   | -    | -     | -       | -  | Y        | -    | -       | -       | -    | -   | -   | -   | -          | -     |
| 京东云(JDcloud)       | R     | Y   | Y     | N   | R  | N       | -       | R  | N    | R     | R   | R   | R    | -     | N       | N  | N        | N    | N       | N       | N    | N   | N   | N   | N          | N     |
