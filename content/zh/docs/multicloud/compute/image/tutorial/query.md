---
title: "查询镜像"
date: 2019-07-19T11:34:38+08:00
weight: 100
description: >
  介绍如何通过指定参数查询镜像以及镜像详情。
---

### 列表

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

### 详情

根据 image-list 可以获取镜像的列表，第1、2列包含镜像的 id 和 name，通过 id 或 name 可以获取镜像的详情。

```bash
# 查询名称包含 CentOS 的镜像
$ climc image-list --search centos
+--------------------------------------+-----------------------------------------+-------------+-----------+-----------+-----------+-------------+----------+---------+--------+----------------------------------+----------------------------------+--------+----------------+
|                  ID                  |                  Name                   | Disk_format |   Size    | Is_public | Protected | Is_Standard | Min_disk | Min_ram | Status |             Checksum             |            Tenant_Id             | Tenant | is_guest_image |
+--------------------------------------+-----------------------------------------+-------------+-----------+-----------+-----------+-------------+----------+---------+--------+----------------------------------+----------------------------------+--------+----------------+
| abf0fd6e-ec40-44ef-8fa2-cfb7187ea656 | CentOS-7-x86_64-GenericCloud-1711.qcow2 | qcow2       | 876740608 | false     | true      | true        | 8192     | 0       | active | 317ecf7d1128e0e53cb285b8704dc3d3 | d53ea650bfe144da8ee8f3fba417b904 | system | false          |
+--------------------------------------+-----------------------------------------+-------------+-----------+-----------+-----------+-------------+----------+---------+--------+----------------------------------+----------------------------------+--------+----------------+
***  Total: 1 Pages: 1 Limit: 20 Offset: 0 Page: 1  ***

# 查看 CentOS-7-x86_64-GenericCloud-1711.qcow2 的详情
$ climc image-show CentOS-7-x86_64-GenericCloud-1711.qcow2
+--------------------+-------------------------------------------------------------------------------------------------------------------+
|       Field        |                                                       Value                                                       |
+--------------------+-------------------------------------------------------------------------------------------------------------------+
| can_delete         | false                                                                                                             |
| can_update         | true                                                                                                              |
| checksum           | 317ecf7d1128e0e53cb285b8704dc3d3                                                                                  |
| created_at         | 2020-06-16T09:17:57.000000Z                                                                                       |
| delete_fail_reason | {"error":{"class":"ForbiddenError","code":403,"data":{"id":"image is protected"},"details":"image is protected"}} |
| disk_format        | qcow2                                                                                                             |
| domain_id          | default                                                                                                           |
| fast_hash          | 4c53ba2c464213ddc2a77c9b4c5ad3b7                                                                                  |
| id                 | abf0fd6e-ec40-44ef-8fa2-cfb7187ea656                                                                              |
| is_data            | false                                                                                                             |
| is_emulated        | false                                                                                                             |
| is_guest_image     | false                                                                                                             |
| is_public          | false                                                                                                             |
| is_standard        | true                                                                                                              |
| is_system          | false                                                                                                             |
| min_disk           | 8192                                                                                                              |
| min_ram            | 0                                                                                                                 |
| name               | CentOS-7-x86_64-GenericCloud-1711.qcow2                                                                           |
| oss_checksum       | 317ecf7d1128e0e53cb285b8704dc3d3                                                                                  |
| owner              | d53ea650bfe144da8ee8f3fba417b904                                                                                  |
| pending_deleted    | false                                                                                                             |
| project_domain     | Default                                                                                                           |
| project_src        | local                                                                                                             |
| properties         | {"os_arch":"x86_64","os_type":"Linux"}                                                                            |
| protected          | true                                                                                                              |
| public_scope       | system                                                                                                            |
| size               | 876740608                                                                                                         |
| status             | active                                                                                                            |
| tenant             | system                                                                                                            |
| tenant_id          | d53ea650bfe144da8ee8f3fba417b904                                                                                  |
| update_version     | 8                                                                                                                 |
| updated_at         | 2020-06-16T09:19:24.000000Z                                                                                       |
+--------------------+-------------------------------------------------------------------------------------------------------------------+
```
