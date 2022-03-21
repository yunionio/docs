---
title: "数据库记录一致性校验"
weight: 142
description: >
    介绍如何配置数据库记录一致性校验，当平台数据库记录被窜改后能够及时报错
---

数据库记录一致性校验的原理是计算表里面每条记录的 md5 值，如果人工修改字段，平台的服务在读取，更新或者删除的时候就会发现计算的 md5 checksum 不一致，禁止接下来的操作。

## 配置

开启改选项会产生额外的计算量。默认开启以下服务的配置表：

- keystone 服务:
    - user 表: 保存用户信息的表
- region 服务:
    - guests_tbl 表: 保存虚拟机信息
- logger 服务:
    - actionlog_tbl 表: 保存操作日志

分别编辑这两个服务的配置 configmap default-keystone 和 default-region 里面的 enable_db_checksum_tables 这个参数：

```bash
# 配置 keystone 服务配置
$ kubectl -n onecloud edit configmaps default-keystone
...
    enable_db_checksum_tables: true
...

# 重启 keystone 服务
$ kubectl -n onecloud rollout restart deployment default-keystone

# 配置 region 服务配置
$ kubectl -n onecloud edit configmaps default-region
...
    enable_db_checksum_tables: true
...

# 重启 region 服务
$ kubectl -n onecloud rollout restart deployment default-region
```

## 测试

当开启 enable_db_checksum_tables 的配置后，每条记录就会有一个 record_checksum 的字段，这里以 keystone 数据库的 user 表来测试，看看如果手动修改了记录会发生什么情况：

```bash
# 查看 cloudadmin 用户的 record_checksum, id 和 last_login_ip
$ climc user-show cloudadmin | egrep -w 'record_checksum|id|last_login_ip'
| id                  | 475925c93c344a54837fe49f852c5086 |
| last_login_ip       | 192.168.121.1                    |
| record_checksum     | 3d953f46c400ba3bd9562be8ae2a9d9c |

# 找到当前集群的数据库密码
$ kubectl get oc -n onecloud -o yaml | grep -A 4 mysql
    mysql:
      host: 192.168.121.21
      password: y4uzCV37gZEr
      port: 3306
      username: root

# 连上 keystone 数据库，把 cloudadmin 的 last_login_ip 字段改成 192.168.121.2
$ mysql -u root -py4uzCV37gZEr -h 192.168.121.21 keystone
MariaDB [keystone]> update user set last_login_ip = '192.168.121.2' where id = '475925c93c344a54837fe49f852c5086';
Query OK, 1 row affected (0.00 sec)
Rows matched: 1  Changed: 1  Warnings: 0

# 再次查看 cloudadmin user，会提示记录被修改，checksum 不一致的报错
$ climc user-show cloudadmin
{"error":{"class":"UnclassifiedError","code":500,"details":"Record user(475925c93c344a54837fe49f852c5086) checksum changed, expected(3d953f46c400ba3bd9562be8ae2a9d9c) != calculated(701f345054c8fee78cebb130730c8ba0)","request":{"headers":{"User-Agent":"yunioncloud-go/201708","X-Auth-Token":"*"},"method":"GET","url":"http://192.168.121.21:30500/v3/users/cloudadmin"}}}
```

## 注意事项

为了兼容性，这个 db_checksum_tables 里面配置的表每次服务启动都会计算，如果数据量很大，可能会导致服务启动很慢，当第一次服务初始完每条记录的 checksum 后，可以配置 `db_checksum_skip_init: true` 参数跳过初始化 checksum 。比如关闭 keystone 服务第一次初始化 checksum 操作如下：

```bash
$ kubectl -n onecloud edit configmaps default-keystone
...
    db_checksum_skip_init: true
...

# 重启 keystone 服务
$ kubectl -n onecloud rollout restart deployment default-keystone
```
