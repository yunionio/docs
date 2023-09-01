---
title: "DNS设计介绍"
date: 2023-08-31T16:16:34+08:00
weight: 10
description: >
    介绍DNS设计相关说明
---

# DNS设计说明

3.10.4版本之前由于采用的是一对多模式，本地dns域会对应到多个云平台的dns域，因此会存在以下两个问题:

1. 若不同云平台的dns解析记录不一致，在往本地同步时会不断覆盖本地的解析记录
2. 若云平台到本地同步不及时，再次从本地推送解析记录到云上，会导致未同步到本地的记录在云上删除

# 新版本DNS设计

3.10.4之后版本采用一对一模式，云上的dns域及解析记录会对应到本地的一条数据

因此增删改本地的一个dns解析，仅会影响到云上的一个确定的记录，即使有些记录未同步到本地，也不会被影响到

新版本采用新的表存储dns解析，因此在更新新版本之后公有云的dns解析会暂时置空，需要等待云账号完全同步后恢复

# region-dns服务

3.10.4 版本之前region-dns采用一张表存储dns解析，类似于如下

`dnsrecord_tbl:`

| Name              | Records    |
| ----------------- | ---------- |
| hello.example.com | A: 1.1.1.1 |
| world.example.com | A: 2.2.2.2 |

新版本统一采用使用类似公有云设计，一张表存dns zone，一张表存解析记录，类似如下

`dnszones_tbl:`

| Name        | ZoneType    | Id              |
| ----------- | ----------- | --------------- |
| example.com | PrivateZone | 1111-xxxx-xxxxx |
| cloud.org   | PublicZone  | 2222-xxxx-xxxxx |

`dnsrecords_tbl:`

| DnsZoneId       | Name  | DnsType | DnsValue          |
| --------------- | ----- | ------- | ----------------- |
| 1111-xxxx-xxxxx | *     | A       | 1.1.1.1           |
| 1111-xxxx-xxxxx | hello | CNAME   | world.example.com |
| 2222-xxxx-xxxxx | iso   | A       | 2.2.2.2           |

因此新版本创建cloudpods本地dns解析将和公有云保持一致
