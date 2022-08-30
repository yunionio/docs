---
title: "关联安全组"
date: 2021-06-23T08:22:33+08:00
weight: 50
description: >
   设置RDS实例安全组
---

安全组是一种虚拟的包过滤防火墙，通过设置安全组规则来控制RDS实例的访问规则等。仅腾讯云平台的RDS实例支持关联安全组。

{{% alert title="说明" %}}
- 仅RDS实例状态为 运行中(running) 时才可进行此操作
- 阿里云最多关联三个安全组
- 腾讯云最多关联5个安全组
- 华为云最多关联1个安全组
{{% /alert %}}

1. 在左侧导航栏，选择 **_"数据库/RDS/RDS实例"_** 菜单项，进入RDS实例页面。
2. 单击RDS实例右侧操作列 **_"更多"_** 按钮，选择下拉菜单 **_"关联安全组"_** 菜单项，弹出关联安全组对话框。
2. 在关联安全组对话框中支持关联或取消关联安全组。
    - 关联安全组：选择要绑定的安全组，最多支持5个。如没有符合需求的安全组，可单击“新建安全组”超链接，在弹出的新建安全组页面配置相关参数，单击 “确定” 按钮，创建安全组。
    - 取消关联安全组：取消选择安全组，至少保留一个安全组。
3. 单击 **_"确定"_** 按钮，完成操作。


```bash
$ climc dbinstance-set-secgroup 6df152bc-0802-4fcc-8e72-22415ddf43a9 secgroup1 secgroup2
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
| status             | deploying                                                                                                                  |
| tenant             | system                                                                                                                     |
| tenant_id          | a9a365125abf43c580ba98e5640b5c51                                                                                           |
| update_version     | 18                                                                                                                         |
| updated_at         | 2021-06-23T06:07:12.000000Z                                                                                                |
| vcpu_count         | 1                                                                                                                          |
| vmem_size_mb       | 3069                                                                                                                       |
| vpc                | -                                                                                                                          |
| vpc_ext_id         | 59260e38-17f1-4b57-8df4-6177e6105067-7ffddf3c-65ad-467c-870b-a99f2044039d                                                  |
| vpc_id             | c327f83f-f4c0-4d06-8269-0e56c681dd07                                                                                       |
+--------------------+----------------------------------------------------------------------------------------------------------------------------+
```
