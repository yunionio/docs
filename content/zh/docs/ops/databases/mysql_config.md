---
title: "MySQL推荐配置"
date: 2023-06-24T18:38:00+08:00
weight: 121
description: >
    介绍MySQL推荐配置
---

MySQL配置建议如下：

1. 取消对客户端的域名反解

```
skip-name-resolve
```

2. 自动清理binlog的时间(天数）

```
expire_logs_days=30
```


3. 设置每个表一个独立innodb文件

```
innodb_file_per_table=ON
```

4. 最大连接数

```
max_connections=300
```

默认151，可以调高一些，比如300 

注意：调高MySQL最大连接数同时需要调高操作系统的最大打开文件数，需修改 /usr/lib/systemd/system/mariadb.service 如下：

```
# /usr/lib/systemd/system/mariadb.service
[Service]
LimitNOFILE=10000
LimitMEMLOCK=10000
```


5. query最大返回字节数

```
max_allowed_packet=20M
```

默认1M，调高为 20M


6. 设置日期字段的默认时区为UTC

```
default_time_zone='+00:00'
```

7. 开启slow log日志以及该日志的logrotate

```
slow_query_log = ON
long_query_time = 30
slow_query_log_file = /var/log/mariadb/slow.log
```

8. 开启error log
```
log_error=/var/log/mariadb/mariadb.err.log
```

9. 关闭通用log
```
general_log=OFF
general_log_file=/var/log/mariadb/mariadb.log
```

修改配置文件
```
# /etc/my.cnf
[mysqld]
skip-name-resolve
expire_logs_days=30
innodb_file_per_table=ON
max_connections=300
max_allowed_packet=20M
default_time_zone='+00:00'
slow_query_log = ON
long_query_time = 30
slow_query_log_file = /var/log/mariadb/slow.log
log_error = /var/log/mariadb/mariadb.err.log
general_log=OFF
general_log_file=/var/log/mariadb/mariadb.log
```