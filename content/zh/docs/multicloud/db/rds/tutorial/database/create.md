---
title: "创建"
date: 2021-06-23T08:22:33+08:00
weight: 1
description: >
   新建RDS实例数据库
---

## 前提条件
- 仅RDS实例状态为 运行中(running) 时才可进行此操作


{{< tabs >}}
{{% tab name="控制台" %}}

 ![RDS实例数据库创建](../../../images/rds_database_create.png)

{{% /tab %}}
{{% tab name="命令行" %}}

```bash
$ climc dbinstance-database-create database2 f39bc936-32dd-4151-8ca0-09834318b482 --character-set utf8
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
| status             | creating                             |
| tenant             | system                               |
| tenant_id          | a9a365125abf43c580ba98e5640b5c51     |
| update_version     | 1                                    |
| updated_at         | 2021-06-24T06:47:06.000000Z          |
| vpc                | vpc-h                                |
| vpc_ext_id         | vpc-2zewan71fq5dxmy1ozq0k            |
| vpc_id             | c3652c98-ebc6-4c71-85a0-5eccc8583104 |
+--------------------+--------------------------------------+
```

{{% /tab %}}
{{< /tabs >}}
