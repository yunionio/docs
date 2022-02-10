---
title: "删除数据库"
date: 2021-06-23T08:22:33+08:00
weight: 20
description: >
   删除RDS实例数据库
---

该功能用于删除数据库。

1. 在左侧导航栏，选择 **_"数据库/RDS/RDS实例"_** 菜单项，进入RDS实例页面。
2. 单击RDS实例的名称项，进入RDS实例详情页面。
2. 单击“数据库管理”页签，进入数据库管理页面。
2. 单击数据库右侧操作列 **_"删除"_** 按钮，弹出操作确认对话框。
3. 单击 **_"确定"_** 按钮，完成操作。


```bash
# 删除RDS实例数据库
$ climc dbinstance-database-delete 667e37a0-eacf-420b-82e2-5bb21a418d6c
+--------------------+--------------------------------------+
|       Field        |                Value                 |
+--------------------+--------------------------------------+
| account            | qx-aliyun                            |
| account_id         | f88fb1c0-73d4-4c56-8315-20f7dfba3447 |
| brand              | Aliyun                               |
| can_delete         | true                                 |
| can_update         | true                                 |
| character_set      | utf8                                 |
| cloud_env          | public                               |
| cloudregion        | Aliyun 华北2（北京）                 |
| cloudregion_id     | b7f8f44e-4fae-42b7-87cd-cb21f47da032 |
| created_at         | 2021-06-24T06:47:06.000000Z          |
| dbinstance         | test-aliyun                          |
| dbinstance_id      | f39bc936-32dd-4151-8ca0-09834318b482 |
| deleted            | false                                |
| environment        | InternationalCloud                   |
| id                 | 667e37a0-eacf-420b-82e2-5bb21a418d6c |
| imported_at        | 2021-06-24T06:47:06.000000Z          |
| is_emulated        | false                                |
| manager            | qx-aliyun                            |
| manager_domain     | Default                              |
| manager_domain_id  | default                              |
| manager_id         | 5af29c01-3f83-4a52-875c-1336e559b0f5 |
| manager_project    | qx-aliyun                            |
| manager_project_id | dccd3be610c342e9812e64258ca12769     |
| name               | database2                            |
| project            | system                               |
| project_domain     | Default                              |
| project_id         | a9a365125abf43c580ba98e5640b5c51     |
| provider           | Aliyun                               |
| region             | Aliyun 华北2（北京）                 |
| region_ext_id      | cn-beijing                           |
| region_external_id | Aliyun/cn-beijing                    |
| region_id          | b7f8f44e-4fae-42b7-87cd-cb21f47da032 |
| source             | local                                |
| status             | deleting                             |
| tenant             | system                               |
| tenant_id          | a9a365125abf43c580ba98e5640b5c51     |
| update_version     | 3                                    |
| updated_at         | 2021-06-24T06:51:00.000000Z          |
| vpc                | vpc-h                                |
| vpc_ext_id         | vpc-2zewan71fq5dxmy1ozq0k            |
| vpc_id             | c3652c98-ebc6-4c71-85a0-5eccc8583104 |
+--------------------+--------------------------------------+
```
