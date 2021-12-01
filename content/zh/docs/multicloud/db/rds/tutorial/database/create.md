---
title: "新建数据库"
date: 2021-06-23T08:22:33+08:00
weight: 10
description: >
   新建RDS实例数据库
---

该功能用于创建数据库，仅RDS实例状态为 运行中(running) 时才可进行此操作。

{{% alert title="注意" color="warning" %}}
- 阿里云不支持创建名称为test的数据库。
- 谷歌云RDS不支持为数据库设置账号。
- 腾讯云不支持在界面新建数据库，需要登录到RDS实例上进行数据库的管理操作。
{{% /alert %}}

1. 在RDS实例页面，单击RDS实例的名称项，进入RDS实例详情页面。
2. 单击“数据库管理”页签，进入数据库管理页面。
2. 单击列表上方 **_"新建"_** 按钮，弹出创建数据库对话框。
3. 设置以下参数。
    - 数据库名称：设置数据库名称，数据库名称在实例内必须是唯一的。
    - 字符集：字符集是数据库中字母、符号的集合，以及它们的编码规则。
    - 账号：选择访问数据库的授权账号。
        1. 在未授权账号中选择一个或多个账号，单击![](../../images/database/>.png)图标添加到已授权的账号。
        2. 在已授权的账号中，设置账号对数据库的读写或只读权限。
4. 单击 **_"确定"_** 按钮，完成操作。


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


