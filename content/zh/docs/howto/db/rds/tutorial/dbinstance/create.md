---
title: "创建"
date: 2021-06-23T08:22:33+08:00
weight: 10
---

{{% alert title="注意" color="warning" %}}
- 由于套餐取自于企业版,并且因为更新时效问题, 可能部分套餐当前不可用. 若创建失败,请更换套餐再次尝试
- 若出现平台区域不可选, 请检查云账号状态及是否启用，以及云账号底下是否有可用IP子网
{{% /alert %}}
 

## 前提条件

- [导入云账号]({{< relref "../../../../multicloud/cloudaccounts/tutorial/create" >}})
- 创建IP子网


{{< tabs >}}
{{% tab name="控制台" %}}

 ![RDS实例创建](../../../images/rds_create.png)
{{% /tab %}}
{{% tab name="命令行" %}}

```bash
$ climc dbinstance-create --network b30816cf-da98-4206-8a77-bb0d7b2701c7 --engine MariaDB --engine-version 10.3 --category high_availability --storage-type cloud_ssd --secgroup default --disk-size-gb 20 --instance-type mariadb.n2.small.2c Test-aliyun
+--------------------+--------------------------------------+
|       Field        |                Value                 |
+--------------------+--------------------------------------+
| account            | aliyun                               |
| account_id         | 78bb3e6a-fbd9-4b42-8b77-519b9879ff40 |
| auto_renew         | false                                |
| billing_type       | postpaid                             |
| brand              | Aliyun                               |
| can_delete         | false                                |
| can_update         | true                                 |
| category           | high_availability                    |
| cloud_env          | public                               |
| cloudregion        | Aliyun 华北2（北京）                 |
| cloudregion_id     | 9b0fdc39-701b-44fc-8842-664fe89359f1 |
| created_at         | 2021-06-23T07:18:48.000000Z          |
| deleted            | false                                |
| disable_delete     | true                                 |
| disk_size_gb       | 20                                   |
| domain_id          | default                              |
| engine             | MariaDB                              |
| engine_version     | 10.3                                 |
| environment        | InternationalCloud                   |
| freezed            | false                                |
| id                 | 7d34cf83-f624-434d-872e-fb8088210827 |
| imported_at        | 2021-06-23T07:18:48.000000Z          |
| instance_type      | mariadb.n2.small.2c                  |
| iops               | 0                                    |
| is_emulated        | false                                |
| is_system          | false                                |
| manager            | aliyun                               |
| manager_domain     | Default                              |
| manager_domain_id  | default                              |
| manager_id         | 310dd2c0-578c-4d2b-8f1d-5c73a7b11f4d |
| manager_project    | system                               |
| manager_project_id | a7f2e2a81a1e4850a41eae5f140ceb14     |
| name               | Test-aliyun                          |
| pending_deleted    | false                                |
| port               | 0                                    |
| project            | system                               |
| project_domain     | Default                              |
| project_src        | local                                |
| provider           | Aliyun                               |
| region             | Aliyun 华北2（北京）                 |
| region_ext_id      | cn-beijing                           |
| region_external_id | Aliyun/cn-beijing                    |
| region_id          | 9b0fdc39-701b-44fc-8842-664fe89359f1 |
| secgroups          | [{"id":"default","name":"Default"}]  |
| source             | local                                |
| status             | deploying                            |
| storage_type       | cloud_ssd                            |
| tenant             | system                               |
| tenant_id          | a7f2e2a81a1e4850a41eae5f140ceb14     |
| update_version     | 1                                    |
| updated_at         | 2021-06-23T07:18:48.000000Z          |
| vcpu_count         | 1                                    |
| vmem_size_mb       | 2048                                 |
| vpc                | vpc-2ze8wn9ogwg2znaabvt1c            |
| vpc_ext_id         | vpc-2ze8wn9ogwg2znaabvt1c            |
| vpc_id             | c658c6d2-402a-4a96-88be-eee5d2217494 |
+--------------------+--------------------------------------+
```

{{% /tab %}}
{{< /tabs >}}
