---
title: "同步状态"
date: 2021-06-23T08:22:33+08:00
weight: 30
description: >
   同步RDS实例备份状态
---

{{< tabs >}}
{{% tab name="控制台" %}}

- 支持批量和单个rds实例备份同步状态

 ![RDS实例备份同步状态](../../../images/rds_backup_syncstatus.png)


{{% /tab %}}


{{% tab name="命令行" %}}
```bash
$ climc dbinstance-backup-syncstatus 4eca9256-f998-402e-83bf-db7b0860c5c3
+--------------------+--------------------------------------+
|       Field        |                Value                 |
+--------------------+--------------------------------------+
| account            | qj-jd                                |
| account_id         | 96f46c61-38c4-4fd7-857a-effb4f69eabf |
| backup_method      | physical                             |
| backup_mode        | manual                               |
| backup_size_mb     | 13                                   |
| brand              | JDcloud                              |
| can_delete         | true                                 |
| can_update         | true                                 |
| cloud_env          | public                               |
| cloudregion        | JDcloud 华北-北京                    |
| cloudregion_id     | 5323c848-cbe8-4d1d-8319-e42641fed2f2 |
| created_at         | 2021-06-22T07:05:37.000000Z          |
| dbinstance         | testrds                              |
| dbinstance_id      | c466cc2b-5377-4bf3-8cf8-f9d8c89fb955 |
| deleted            | false                                |
| domain_id          | default                              |
| engine             | MySQL                                |
| engine_version     | 5.6                                  |
| external_id        | 39577a08-1499-466a-807d-421e7292f4b1 |
| freezed            | false                                |
| id                 | 4eca9256-f998-402e-83bf-db7b0860c5c3 |
| imported_at        | 2021-06-22T07:05:37.000000Z          |
| is_emulated        | false                                |
| is_system          | false                                |
| manager            | qj-jd                                |
| manager_domain     | Default                              |
| manager_domain_id  | default                              |
| manager_id         | 8e47bb75-5105-4ef9-84b8-8aa5927b06dd |
| manager_project    | system                               |
| manager_project_id | a9a365125abf43c580ba98e5640b5c51     |
| name               | tes_backup                           |
| pending_deleted    | false                                |
| project            | system                               |
| project_domain     | Default                              |
| provider           | JDcloud                              |
| region             | JDcloud 华北-北京                    |
| region_ext_id      | cn-north-1                           |
| region_external_id | JDcloud/cn-north-1                   |
| region_id          | 5323c848-cbe8-4d1d-8319-e42641fed2f2 |
| source             | cloud                                |
| status             | sync_status                          |
| tenant             | system                               |
| tenant_id          | a9a365125abf43c580ba98e5640b5c51     |
| update_version     | 4                                    |
| updated_at         | 2021-06-24T06:18:01.000000Z          |
+--------------------+--------------------------------------+ 
```

{{% /tab %}}
{{< /tabs >}}
