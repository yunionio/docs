---
title: "清理日志"
date: 2021-12-08T18:38:00+08:00
weight: 35
description: >
    介绍如何清理服务日志、数据库日志
---

### 清理服务日志

```bash
# 查看具体服务的分表日志
$ climc logs-show --service <service_type> splitable
```

![](../images/logtable2.png)

```bash
# 删除超过6个月的分表
$ climc logs-purge-splitable --service <service_type>
```
![](../images/deletelogtable2.png)

### 清理数据库日志

在部署日志的服务器上执行

```bash
# 设置自动清除binlog的保留时间
$ vi /etc/my.cnf
expire_logs_days = 30
```
![](../images/binlog.png)
