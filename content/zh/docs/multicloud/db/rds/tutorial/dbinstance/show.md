---
title: "查看RDS实例详情"
date: 2021-06-23T08:22:33+08:00
weight: 120
description: >
   查看RDS实例详情页
---

该功能用于查看RDS实例详情信息。

1. 在左侧导航栏，选择 **_"数据库/RDS/RDS实例"_** 菜单项，进入RDS实例页面。
2. 单击RDS实例名称项，进入RDS实例详情页面。
2. 查看以下信息。
    - 基本信息：包括云上ID、ID、名称、状态、域、项目、平台、计费方式、区域、可用区（若有备可用区，也将在此处显示）、云账号、创建时间、更新时间、备注。
    - 数据库信息：包括数据库引擎、可维护时间段、实例规格、最大IOPS、实例类型、存储类型、CPU、内存。
    - 链接信息：包括开启外网地址（仅阿里云支持）、外网地址（仅阿里云支持）、内网地址、数据库端口号、VPC、子网、安全组。
        - 开启外网地址仅阿里云RDS实例支持，开启后需要等待一分钟所有才会开启成功，开启成功后用户可通过外网地址和端口后连接数据库。
    - 存储/备份统计：包括存储空间。
    - 其他信息：支持开启或关闭删除保护。

```bash
$ climc dbinstance-show 6df152bc-0802-4fcc-8e72-22415ddf43a9
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
| status             | running                                                                                                                    |
| tenant             | system                                                                                                                     |
| tenant_id          | a9a365125abf43c580ba98e5640b5c51                                                                                           |
| update_version     | 15                                                                                                                         |
| updated_at         | 2021-06-22T08:48:15.000000Z                                                                                                |
| vcpu_count         | 1                                                                                                                          |
| vmem_size_mb       | 3069                                                                                                                       |
| vpc                | -                                                                                                                          |
| vpc_ext_id         | 59260e38-17f1-4b57-8df4-6177e6105067-7ffddf3c-65ad-467c-870b-a99f2044039d                                                  |
| vpc_id             | c327f83f-f4c0-4d06-8269-0e56c681dd07                                                                                       |
+--------------------+----------------------------------------------------------------------------------------------------------------------------+
```
