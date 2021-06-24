---
title: "列表"
date: 2021-06-23T08:22:33+08:00
weight: 20
description: >
   查看RDS实例备份列表
---

{{< tabs >}}
{{% tab name="控制台" %}}

- 菜单导航: 数据库 -> RDS实例 -> 详情页 -> 备份管理标签页

 ![RDS实例备份列表](../../../images/rds_backup_list.png)


{{% /tab %}}


{{% tab name="命令行" %}}
```bash
# 查看RDS实例c466cc2b-5377-4bf3-8cf8-f9d8c89fb955 备份列表
$ climc dbinstance-backup-list --dbinstance c466cc2b-5377-4bf3-8cf8-f9d8c89fb955 --details
+--------------------------------------+------------+--------+----------------+------------+--------+
|                  ID                  |    Name    | Status | Backup_Size_Mb | DBInstance | Engine |
+--------------------------------------+------------+--------+----------------+------------+--------+
| 4eca9256-f998-402e-83bf-db7b0860c5c3 | tes_backup | ready  | 13             | testrds    | MySQL  |
| 41f3ea39-0f6c-43b6-8fa7-d83ffb89a159 | ef7b3e0a   | ready  | 13             | testrds    | MySQL  |
+--------------------------------------+------------+--------+----------------+------------+--------+
```
{{% /tab %}}
{{< /tabs >}}
