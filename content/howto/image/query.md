---
title: "查询镜像"
date: 2019-07-19T11:34:38+08:00
weight: 10
---

## 列表

```bash
# 查询所有镜像列表
$ climc image-list

# 查询所有缓存的镜像列表
$ climc cached-image-list

# 查询包含 ubuntu 关键字的镜像
$ climc image-list --search ubuntu

# 查询公有云包含 centos 关键字的缓存
$ climc cached-image-list --search centos --public-cloud

# image-list 支持的查询条件
$ climc help image-list

# cached-image-list 支持的查询条件
$ climc help cached-image-list
```

## 详情

根据 image-list 可以获取镜像的列表，第1、2列包含镜像的 id 和 name，通过 id 或 name 可以获取镜像的详情。

```bash
# 查询名称包含 ubuntu 的镜像
$ climc image-list --search ubuntu
+--------------------------------------+--------------------------------------+-------------+------------+-----------+----------+---------+--------+----------------------------------+
|                  ID                  |                 Name                 | Disk_format |    Size    | Is_public | Min_disk | Min_ram | Status |             Checksum             |
+--------------------------------------+--------------------------------------+-------------+------------+-----------+----------+---------+--------+----------------------------------+
| bd0a4029-7646-4d21-89b7-856d90334cc7 | ubuntu-xenial-server.qcow2           | qcow2       | 297009152  | true      | 2252     | 0       | active | 3ab09243ba73ae87fb48c08ddb42ef42 |
| b3440f33-23ca-4d56-85ee-dc2b368b6337 | ubuntu-18.04.2-server-20190430.qcow2 | qcow2       | 1003356160 | true      | 30720    | 0       | active | 9c414111827a07a446e25811a3674a43 |
| a0ef7a1e-eb92-406f-8042-b7018a410b2c | ubuntu-16.04.5-server-20181117.qcow2 | qcow2       | 792002560  | true      | 30720    | 0       | active | a69f06c9063089368fdc729149fc545e |
+--------------------------------------+--------------------------------------+-------------+------------+-----------+----------+---------+--------+----------------------------------+
***  Total: 3 Pages: 1 Limit: 20 Offset: 0 Page: 1  ***

# 查看 ubuntu-xenial-server.qcow2 的详情
$ climc image-show ubuntu-xenial-server.qcow2
+-----------------+------------------------------------------------------------------------------------------------------------------+
|      Field      |                                                      Value                                                       |
+-----------------+------------------------------------------------------------------------------------------------------------------+
| can_delete      | false                                                                                                            |
| can_update      | true                                                                                                             |
| checksum        | 3ab09243ba73ae87fb48c08ddb42ef42                                                                                 |
| created_at      | 2019-07-19T03:33:11.000000Z                                                                                      |
| disk_format     | qcow2                                                                                                            |
| domain_id       | default                                                                                                          |
| fast_hash       | bdcce6185fcefcd0e009499226f0bee9                                                                                 |
| id              | bd0a4029-7646-4d21-89b7-856d90334cc7                                                                             |
| is_emulated     | false                                                                                                            |
| is_public       | true                                                                                                             |
| is_system       | false                                                                                                            |
| min_disk        | 2252                                                                                                             |
| min_ram         | 0                                                                                                                |
| name            | ubuntu-xenial-server.qcow2                                                                                       |
| oss_checksum    | 3ab09243ba73ae87fb48c08ddb42ef42                                                                                 |
| owner           | a7f2e2a81a1e4850a41eae5f140ceb14                                                                                 |
| pending_deleted | false                                                                                                            |
| project_src     | local                                                                                                            |
| properties      | {"installed_cloud_init":"true","os_arch":"x86","os_distribution":"Ubuntu","os_type":"Linux","os_version":"16.0"} |
| protected       | false                                                                                                            |
| public_scope    | system                                                                                                           |
| size            | 297009152                                                                                                        |
| status          | active                                                                                                           |
| tenant_id       | a7f2e2a81a1e4850a41eae5f140ceb14                                                                                 |
| update_version  | 6                                                                                                                |
| updated_at      | 2019-07-19T03:34:47.000000Z                                                                                      |
+-----------------+-------------------------------------------------------------------------------------------------
```
