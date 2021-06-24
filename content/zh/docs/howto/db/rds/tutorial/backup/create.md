---
title: "创建"
date: 2021-06-23T08:22:33+08:00
weight: 1
description: >
   新建RDS实例备份
---

## 前提条件
- 仅RDS实例状态为 运行中(running) 时才可进行此操作


{{< tabs >}}
{{% tab name="控制台" %}}

 ![RDS实例备份创建](../../../images/rds_backup_create.png)

{{% /tab %}}
{{% tab name="命令行" %}}

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

{{% /tab %}}
{{< /tabs >}}
