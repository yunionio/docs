---
title: "调整配置"
date: 2021-06-23T08:22:33+08:00
weight: 40
description: >
   调整RDS实例配置
---



该功能用于调整RDS实例的配置信息，实例配置只能向上调整，且RDS实例必须处于运行中(running)。

1. 在RDS实例页面，单击RDS实例右侧操作列 **_"更多"_** 按钮，选择下拉菜单 **_"调整配置"_** 菜单项，弹出调整配置对话框。
2. 支持调整存储类型、CPU核数、内存、存储空间等参数。
3. 配置调整完成后，单击 **_"确定"_** 按钮。


```bash
$ climc dbinstance-change-config --vcpu-count 4 --vmem-size-mb 8192 --disk-size-gb 500 6df152bc-0802-4fcc-8e72-22415ddf43a9
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
| status             | change_config                                                                                                              |
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

