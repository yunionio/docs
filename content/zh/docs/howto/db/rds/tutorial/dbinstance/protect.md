---
title: "设置删除保护"
date: 2021-06-23T08:22:33+08:00
weight: 50
description: >
   防止资源勿删
---


{{< tabs >}}
{{% tab name="控制台" %}}

 ![设置删除保护](../../../images/rds_protect.png)
 ![设置删除保护](../../../images/rds_protect2.png)


{{% /tab %}}


{{% tab name="命令行" %}}
```bash
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
{{% /tab %}}
{{< /tabs >}}
