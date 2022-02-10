---
title: "删除"
date: 2021-06-23T08:22:33+08:00
weight: 100
description: >
   删除RDS实例
---

### 设置删除保护

该功能用于设置RDS实例的删除保护。当RDS实例启用删除保护后，RDS实例无法被删除；当RDS实例禁用删除保护后，RDS实例才可以被删除。

**单个RDS实例设置删除保护**

1. 禁用删除保护：
    - 单击RDS实例名称右侧带有![](../../../../../images/delprotect1.png)图标时，单击RDS实例右侧操作列 **_"更多"_** 按钮，选择下拉菜单 **_"设置删除保护"_** 菜单项，弹出设置删除保护对话框。
    - 选择"禁用"删除保护，单击 **_"确定"_** 按钮。
2. 启用删除保护：
    - 当RDS实例名称右侧不带![](../../../../../images/delprotect1.png)图标时，单击RDS实例右侧操作列 **_"更多"_** 按钮，选择下拉菜单 **_"设置删除保护"_** 菜单项，弹出设置删除保护对话框。
    - 选择"启用"删除保护，单击 **_"确定"_** 按钮。

**批量设置删除保护**

1. 禁用删除保护：
    - 在RDS实例列表中勾选一个或多个RDS实例，单击列表上方 **_"批量操作"_** 按钮，选择下拉菜单 **_"设置删除保护"_** 菜单项，弹出设置删除保护对话框。
    - 选择"禁用"删除保护，单击 **_"确定"_** 按钮，批量为RDS实例禁用删除保护。
2. 启用删除保护：
    - 在RDS实例列表中勾选一个或多个RDS实例，单击列表上方 **_"批量操作"_** 按钮，选择下拉菜单 **_"设置删除保护"_** 菜单项，弹出设置删除保护对话框。
    - 选择"启用"删除保护，单击 **_"确定"_** 按钮，批量为RDS实例启用删除保护。

```
# 关闭RDS实例删除保护
$ climc dbinstance-update --delete enable f39bc936-32dd-4151-8ca0-09834318b482
+-------------------------+--------------------------------------------------------+
|          Field          |                         Value                          |
+-------------------------+--------------------------------------------------------+
| account                 | qx-aliyun                                              |
| account_id              | f88fb1c0-73d4-4c56-8315-20f7dfba3447                   |
| auto_renew              | false                                                  |
| billing_cycle           | 1M                                                     |
| billing_type            | prepaid                                                |
| brand                   | Aliyun                                                 |
| can_delete              | true                                                   |
| can_update              | true                                                   |
| category                | high_availability                                      |
| cloud_env               | public                                                 |
| cloudregion             | Aliyun 华北2（北京）                                   |
| cloudregion_id          | b7f8f44e-4fae-42b7-87cd-cb21f47da032                   |
| created_at              | 2021-06-23T07:59:26.000000Z                            |
| deleted                 | false                                                  |
| deleted_at              | 2021-06-23T08:20:12.000000Z                            |
| disable_delete          | false                                                  |
| disk_size_gb            | 5                                                      |
| domain_id               | default                                                |
| engine                  | MySQL                                                  |
| engine_version          | 5.5                                                    |
| environment             | InternationalCloud                                     |
| external_id             | rm-2zedo92hey3s4suq6                                   |
| freezed                 | false                                                  |
| id                      | f39bc936-32dd-4151-8ca0-09834318b482                   |
| imported_at             | 2021-06-23T07:59:26.000000Z                            |
| instance_type           | rds.mysql.t1.small                                     |
| internal_connection_str | rm-2zedo92hey3s4suq6.mysql.rds.aliyuncs.com            |
| iops                    | 0                                                      |
| is_emulated             | false                                                  |
| is_system               | false                                                  |
| maintain_time           | 18:00Z-22:00Z                                          |
| manager                 | qx-aliyun                                              |
| manager_domain          | Default                                                |
| manager_domain_id       | default                                                |
| manager_id              | 5af29c01-3f83-4a52-875c-1336e559b0f5                   |
| manager_project         | qx-aliyun                                              |
| manager_project_id      | dccd3be610c342e9812e64258ca12769                       |
| metadata                | {"generate_name":"test-aliyun","sys:project":"system"} |
| name                    | test-aliyun                                            |
| pending_deleted         | false                                                  |
| pending_deleted_at      | 2021-06-23T08:20:12.000000Z                            |
| port                    | 3306                                                   |
| project                 | system                                                 |
| project_domain          | Default                                                |
| project_src             | local                                                  |
| provider                | Aliyun                                                 |
| region                  | Aliyun 华北2（北京）                                   |
| region_ext_id           | cn-beijing                                             |
| region_external_id      | Aliyun/cn-beijing                                      |
| region_id               | b7f8f44e-4fae-42b7-87cd-cb21f47da032                   |
| source                  | local                                                  |
| status                  | running                                                |
| storage_type            | local_ssd                                              |
| tenant                  | system                                                 |
| tenant_id               | a9a365125abf43c580ba98e5640b5c51                       |
| update_version          | 16                                                     |
| updated_at              | 2021-06-24T02:51:54.000000Z                            |
| vcpu_count              | 1                                                      |
| vmem_size_mb            | 1024                                                   |
| vpc                     | vpc-h                                                  |
| vpc_ext_id              | vpc-2zewan71fq5dxmy1ozq0k                              |
| vpc_id                  | c3652c98-ebc6-4c71-85a0-5eccc8583104                   |
| zone1                   | fd3c013e-40b5-46ca-8fff-3b8c872cd3a8                   |
| zone1_name              | 阿里云 华北 2 可用区 H                                 |
+-------------------------+--------------------------------------------------------+

# 开启RDS删除保护
$ climc dbinstance-update --delete disable f39bc936-32dd-4151-8ca0-09834318b482
+-------------------------+--------------------------------------------------------+
|          Field          |                         Value                          |
+-------------------------+--------------------------------------------------------+
| account                 | qx-aliyun                                              |
| account_id              | f88fb1c0-73d4-4c56-8315-20f7dfba3447                   |
| auto_renew              | false                                                  |
| billing_cycle           | 1M                                                     |
| billing_type            | prepaid                                                |
| brand                   | Aliyun                                                 |
| can_delete              | false                                                  |
| can_update              | true                                                   |
| category                | high_availability                                      |
| cloud_env               | public                                                 |
| cloudregion             | Aliyun 华北2（北京）                                   |
| cloudregion_id          | b7f8f44e-4fae-42b7-87cd-cb21f47da032                   |
| created_at              | 2021-06-23T07:59:26.000000Z                            |
| deleted                 | false                                                  |
| deleted_at              | 2021-06-23T08:20:12.000000Z                            |
| disable_delete          | true                                                   |
| disk_size_gb            | 5                                                      |
| domain_id               | default                                                |
| engine                  | MySQL                                                  |
| engine_version          | 5.5                                                    |
| environment             | InternationalCloud                                     |
| external_id             | rm-2zedo92hey3s4suq6                                   |
| freezed                 | false                                                  |
| id                      | f39bc936-32dd-4151-8ca0-09834318b482                   |
| imported_at             | 2021-06-23T07:59:26.000000Z                            |
| instance_type           | rds.mysql.t1.small                                     |
| internal_connection_str | rm-2zedo92hey3s4suq6.mysql.rds.aliyuncs.com            |
| iops                    | 0                                                      |
| is_emulated             | false                                                  |
| is_system               | false                                                  |
| maintain_time           | 18:00Z-22:00Z                                          |
| manager                 | qx-aliyun                                              |
| manager_domain          | Default                                                |
| manager_domain_id       | default                                                |
| manager_id              | 5af29c01-3f83-4a52-875c-1336e559b0f5                   |
| manager_project         | qx-aliyun                                              |
| manager_project_id      | dccd3be610c342e9812e64258ca12769                       |
| metadata                | {"generate_name":"test-aliyun","sys:project":"system"} |
| name                    | test-aliyun                                            |
| pending_deleted         | false                                                  |
| pending_deleted_at      | 2021-06-23T08:20:12.000000Z                            |
| port                    | 3306                                                   |
| project                 | system                                                 |
| project_domain          | Default                                                |
| project_src             | local                                                  |
| provider                | Aliyun                                                 |
| region                  | Aliyun 华北2（北京）                                   |
| region_ext_id           | cn-beijing                                             |
| region_external_id      | Aliyun/cn-beijing                                      |
| region_id               | b7f8f44e-4fae-42b7-87cd-cb21f47da032                   |
| source                  | local                                                  |
| status                  | running                                                |
| storage_type            | local_ssd                                              |
| tenant                  | system                                                 |
| tenant_id               | a9a365125abf43c580ba98e5640b5c51                       |
| update_version          | 15                                                     |
| updated_at              | 2021-06-24T02:50:35.000000Z                            |
| vcpu_count              | 1                                                      |
| vmem_size_mb            | 1024                                                   |
| vpc                     | vpc-h                                                  |
| vpc_ext_id              | vpc-2zewan71fq5dxmy1ozq0k                              |
| vpc_id                  | c3652c98-ebc6-4c71-85a0-5eccc8583104                   |
| zone1                   | fd3c013e-40b5-46ca-8fff-3b8c872cd3a8                   |
| zone1_name              | 阿里云 华北 2 可用区 H                                 |
+-------------------------+--------------------------------------------------------+
```

### 删除

该功能用于删除RDS实例，当RDS实例名称项右侧有![](../../../../../images/delprotect1.png)图标，表示RDS实例启用了删除保护，无法删除RDS实例，如需删除RDS实例，需要先禁用删除保护。

**单个删除**

1. 在左侧导航栏，选择 **_"数据库/RDS/RDS实例"_** 菜单项，进入RDS实例页面。
2. 单击RDS实例右侧操作列 **_"更多"_** 按钮，选择下拉菜单 **_"删除"_** 菜单项，弹出操作确认对话框。
2. 单击 **_"确定"_** 按钮，完成操作。

**批量删除**

1. 在RDS实例列表中选择一个或多个RDS实例，单击列表上方 **_"批量操作按钮"_** 按钮，选择下拉菜单 **_"删除"_** 菜单项，弹出操作确认对话框。
2. 单击 **_"确定"_** 按钮，完成操作。
```bash
# 删除RDS实例
$ climc dbinstance-delete 6df152bc-0802-4fcc-8e72-22415ddf43a9
+--------------------+----------------------------------------------------------------------------------------------------------------------------+
|       Field        |                                                           Value                                                            |
+--------------------+----------------------------------------------------------------------------------------------------------------------------+
| account            | qj-azure                                                                                                                   |
| account_id         | b8b6a1ad-ed65-41f7-8525-91b44516346e                                                                                       |
| auto_renew         | false                                                                                                                      |
| billing_type       | postpaid                                                                                                                   |
| brand              | Azure                                                                                                                      |
| can_delete         | false                                                                                                                      |
| can_update         | true                                                                                                                       |
| category           | basic                                                                                                                      |
| cloud_env          | public                                                                                                                     |
| cloudregion        | Azure East US                                                                                                              |
| cloudregion_id     | 59260e38-17f1-4b57-8df4-6177e6105067                                                                                       |
| connection_str     | testsqlserverkf.database.windows.net                                                                                       |
| created_at         | 2021-06-21T08:08:57.000000Z                                                                                                |
| deleted            | false                                                                                                                      |
| disable_delete     | true                                                                                                                       |
| disk_size_gb       | 51                                                                                                                         |
| domain_id          | default                                                                                                                    |
| engine             | SQLServer                                                                                                                  |
| engine_version     | 12.0                                                                                                                       |
| environment        | AzurePublicCloud                                                                                                           |
| external_id        | /subscriptions/7aaf3e6c-5f9c-43ad-b149-d9a14765af1c/resourcegroups/default/providers/microsoft.sql/servers/testsqlserverkf |
| freezed            | false                                                                                                                      |
| id                 | 6df152bc-0802-4fcc-8e72-22415ddf43a9                                                                                       |
| imported_at        | 2021-06-21T08:08:57.000000Z                                                                                                |
| iops               | 0                                                                                                                          |
| is_emulated        | false                                                                                                                      |
| is_system          | false                                                                                                                      |
| manager            | Pay-As-You-Go                                                                                                              |
| manager_domain     | Default                                                                                                                    |
| manager_domain_id  | default                                                                                                                    |
| manager_id         | 7ffddf3c-65ad-467c-870b-a99f2044039d                                                                                       |
| manager_project    | system                                                                                                                     |
| manager_project_id | a9a365125abf43c580ba98e5640b5c51                                                                                           |
| name               | testsqlserverkf                                                                                                            |
| pending_deleted    | false                                                                                                                      |
| port               | 1433                                                                                                                       |
| project            | system                                                                                                                     |
| project_domain     | Default                                                                                                                    |
| project_src        | cloud                                                                                                                      |
| provider           | Azure                                                                                                                      |
| region             | Azure East US                                                                                                              |
| region_ext_id      | eastus                                                                                                                     |
| region_external_id | Azure-int/eastus                                                                                                           |
| region_id          | 59260e38-17f1-4b57-8df4-6177e6105067                                                                                       |
| source             | cloud                                                                                                                      |
| status             | deleting                                                                                                                   |
| tenant             | system                                                                                                                     |
| tenant_id          | a9a365125abf43c580ba98e5640b5c51                                                                                           |
| update_version     | 18                                                                                                                         |
| updated_at         | 2021-06-23T06:07:12.000000Z                                                                                                |
| vcpu_count         | 1                                                                                                                          |
| vmem_size_mb       | 3069                                                                                                                       |
| vpc                | -                                                                                                                          |
| vpc_ext_id         | 59260e38-17f1-4b57-8df4-6177e6105067-7ffddf3c-65ad-467c-870b-a99f2044039d                                                  |
| vpc_id             | c327f83f-f4c0-4d06-8269-0e56c681dd07                                                                                       |
+--------------------+----------------------------------------------------------------------------------------------------------------------------+```
```

