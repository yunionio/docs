---
title: "操作日志"
date: 2019-07-19T20:59:00+08:00
weight: 10
description: >
  介绍操作日志服务，以及历史日志的清理
---

## 日志类型

* 平台有一个日志服务，用来收集各个服务的操作日志，这类日志用于展示在web控制台的“操作日志”菜单，起到平台关键操作回溯审计的作用

* 与此同时，每个服务内部都有一个操作日志，用来收集记录每个服务各自的详细操作日志，用来做计费以及debug使用。

* 平台还有一个云上日志服务（Cloudevents），用来同步保存从各个云账号同步下来的操作日志。

## 日志数据的保存

日志数据都保存在数据表中，这类表都采用了自动分表的机制，在每大概30天会自动切换表，把日志保存在新表中。

## 日志表的清理

以上各类日志日积月累数据量都不小，需要定期清理。由于采用了分表保存的机制，可以将旧表drop来删除日志数据，释放空间。

但是，需要注意的是，只有在mysql开启了innodb_file_per_table=ON的选项后，drop表之后，会删除对应的数据库文件，从而释放出表空间。如果mysql未开启innodb_file_per_table选项，则mysql所有数据都保存在/var/lib/mysql/ibdata1这个文件中，即使删除了表，也不会立即释放表空间。

以下命令用来查看各个服务的日志表的情况：

```bash
climc logs-splitable --service <service_name>
```

其中，service可以是：

* compute
* image
* identity
* log
* cloudevent

以下命令清理各个服务的过期日志表（默认drop清理6个月之前的日志表）：

```bash
climc logs-purge --service <service_name>
```
