---
title: "重启"
date: 2021-06-23T08:22:33+08:00
weight: 30
description: >
   重启RDS实例
---

## 限制
- 仅RDS实例状态为 运行中(running), 重启失败(reboot_failed) 时才可进行此操作


{{< tabs >}}
{{% tab name="控制台" %}}

 ![重启RDS实例](../../../images/rds_reboot.png)


{{% /tab %}}


{{% tab name="命令行" %}}
```bash
$ climc dbinstance-reboot 6df152bc-0802-4fcc-8e72-22415ddf43a9
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
| status             | rebooting                                                                                                                  |
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
{{% /tab %}}
{{< /tabs >}}
