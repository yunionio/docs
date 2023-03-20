---
title: "日志配置"
date: 2023-03-20T20:59:00+08:00
weight: 20
description: >
  介绍日志相关的服务配置项
---

平台会将各个服务的操作日志保存在数据库，这些数据库自动支持定期清理功能。

目前支持将操作日志保存在mysql和clickhouse。如果将日志保存在mysql，则会对数据库按照时间进行分表，清理表是已通过drop旧表实现的。如果采用clickhouse保存日志，则通过clickhouse的TTL机制实现对过期数据的自动清理。

系统保存的操作操作日志支持如下配置项：

* ops_log_max_keep_months

保留日志的时间参数，默认是6个月

* splitable_max_duration_hours

日志分表的时间间隔，默认是720小时

* ops_log_with_clickhouse

操作日志采用clickhouse还是mysql作为数据存储


