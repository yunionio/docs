---
title: "新建备份"
date: 2021-06-23T08:22:33+08:00
weight: 1
description: >
   新建RDS实例备份
---

该功能用于为RDS实例创建备份，仅RDS实例状态为 运行中(running) 时才可进行此操作。

1. 在左侧导航栏，选择 **_"数据库/RDS/RDS实例"_** 菜单项，进入RDS实例页面。
2. 单击RDS实例的名称项，进入RDS实例详情页面。
2. 单击“备份管理”页签，进入备份管理页面。
2. 单击列表上方 **_"新建"_** 按钮，弹出创建备份对话框。
3. 输入备份名称、描述，单击 **_"确定"_** 按钮，为RDS实例创建备份。


```bash
$ climc dbinstance-backup-create f39bc936-32dd-4151-8ca0-09834318b482 test-backup
+--------------------+--------------------------------------+
|       Field        |                Value                 |
+--------------------+--------------------------------------+
| account            | qx-aliyun                            |
| account_id         | f88fb1c0-73d4-4c56-8315-20f7dfba3447 |
| backup_mode        | manual                               |
| backup_size_mb     | 0                                    |
| brand              | Aliyun                               |
| can_delete         | true                                 |
| can_update         | true                                 |
| cloud_env          | public                               |
| cloudregion        | Aliyun 华北2（北京）                 |
| cloudregion_id     | b7f8f44e-4fae-42b7-87cd-cb21f47da032 |
| created_at         | 2021-06-24T06:30:34.000000Z          |
| dbinstance         | test-aliyun                          |
| dbinstance_id      | f39bc936-32dd-4151-8ca0-09834318b482 |
| deleted            | false                                |
| domain_id          | default                              |
| engine             | MySQL                                |
| engine_version     | 5.5                                  |
| environment        | InternationalCloud                   |
| freezed            | false                                |
| id                 | 64ab29a4-7099-43ce-8f98-2a3780b77a65 |
| imported_at        | 2021-06-24T06:30:34.000000Z          |
| is_emulated        | false                                |
| is_system          | false                                |
| manager            | qx-aliyun                            |
| manager_domain     | Default                              |
| manager_domain_id  | default                              |
| manager_id         | 5af29c01-3f83-4a52-875c-1336e559b0f5 |
| manager_project    | qx-aliyun                            |
| manager_project_id | dccd3be610c342e9812e64258ca12769     |
| name               | test-backup                          |
| pending_deleted    | false                                |
| project            | system                               |
| project_domain     | Default                              |
| project_src        | local                                |
| provider           | Aliyun                               |
| region             | Aliyun 华北2（北京）                 |
| region_ext_id      | cn-beijing                           |
| region_external_id | Aliyun/cn-beijing                    |
| region_id          | b7f8f44e-4fae-42b7-87cd-cb21f47da032 |
| source             | local                                |
| status             | creating                             |
| tenant             | system                               |
| tenant_id          | a9a365125abf43c580ba98e5640b5c51     |
| update_version     | 1                                    |
| updated_at         | 2021-06-24T06:30:34.000000Z          |
+--------------------+--------------------------------------+
```
