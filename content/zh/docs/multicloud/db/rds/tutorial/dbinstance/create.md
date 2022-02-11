---
title: "新建RDS实例"
date: 2021-06-23T08:22:33+08:00
weight: 10
description: >
   用于新建RDS实例
---

{{% alert title="注意" color="warning" %}}
- 由于套餐取自于企业版,并且因为更新时效问题, 可能部分套餐当前不可用. 若创建失败,请更换套餐再次尝试
- 若出现平台区域不可选, 请检查云账号状态及是否启用，以及云账号底下是否有可用IP子网
{{% /alert %}}
 

### 前提条件

- [导入云账号]({{< relref "../../../../cloudaccounts/tutorial/create" >}})
- 创建IP子网

### 操作步骤

该功能用于新建RDS实例，目前仅支持创建阿里云、华为云、腾讯云、Google的RDS实例。

1. 在左侧导航栏，选择 **_"数据库/RDS/RDS实例"_** 菜单项，进入RDS实例页面。
2. 单击列表上方 **_"新建"_** 按钮，进入新建RDS实例页面。
2. 配置以下信息。
    - 指定项目：管理员或域管理员在新建RDS实例时需要指定RDS实例所属项目。
    - 名称：设置RDS实例的名称。
{{% alert title="注意" color="warning" %}}
Google云平台在删除RDS实例的一周时间内，不能重新使用该实例的名称。
{{% /alert %}}
    - 备注：设置RDS实例的备注信息。
    - 计费方式：包括按量付费、包年包月。谷歌云RDS不支持包年包月。
        - 按量付费：按RDS实例的实际使用量付费，此模式适用于设备需求量会瞬间大幅度增大的场景，价格对比包年包月要贵。
        - 包年包月：是一种预付费的模式，提前一次性支付一个月、一年乃至多年的费用，该模式适用于设备需求比较平稳的场景，价格相对按量付费更便宜。选择包年包月后还需要设置购买时长。
    - 到期释放：设置新建的RDS实例的使用时长，超过设置时间后的RDS实例将会被删除。仅按量付费的RDS实例支持到期释放。
    - 平台及区域：选择RDS实例所在地域，并在对应地域内选择平台和可用区。不同地域支持的平台情况可能不同，请以实际界面为准。
    - 数据库引擎、数据库版本：不同平台支持的数据库引擎及版本不同。目前支持情况请参考[数据库引擎和版本支持情况](#数据库引擎和版本支持情况)
    - 实例类型+可用区：目前主要包括三种实例类型。
        - 单机（基础版）：只创建一个实例，并为实例选择可用区。
        - 主备（高可用、集群版）：创建一个主实例和备实例，并为主备实例选择可用区，为了提高主备实例的可靠性，建议将主备实例分布在不同可用区。可用区选项中将默认显示两个可用区的名称，如阿里云平台仅显示一个可用区，则表示主备实例处于同一可用区；华为云平台的两个可用区名称相同时，也代表主备实例处于同一可用区。
        - 金融版（仅阿里云支持）：创建一个主实例和两个备实例，且处于同一地域的三个不同可用区。
    - 实例类型（谷歌云）：仅支持创建第二代RDS实例，第一代RDS实例仅支持同步，不支持创建。
    - 可用区（谷歌云）：选择RDS实例所属的可用区。
    - CPU核数、内存、实例规格：根据选择的CPU核数、内存等选择实例规格。
    - 存储空间：RDS实例所需的存储空间。
    - 管理员密码（仅华为云支持）：支持随机生成和手工输入管理员密码。
    - 网络：选择VPC和IP子网。
    - 安全组：选择安全组，限制实例的安全访问规则，仅华为云、腾讯云支持。
    - 标签：支持为新建的RDS实例绑定标签。支持选择已有标签和新建标签。
        - 新建标签：单击列表上方 **_新建_** 按钮，设置标签键和标签值，单击 **_"添加"_** 按钮，新建标签并绑定到资源上。
        - 选择已有标签：单击 **_"已有标签"_** 按钮，选择标签键和值。
3. 单击 **_"确定"_** 按钮。


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


### 数据库引擎和版本支持情况


 平台 | Mariadb | MySQL | PPAS |  SQL Server | PostgreSQL | percona 
----- | ----- | -----| -----|-----|-----|-----
 阿里云 | 10.3 | 5.5、5.6、5.7、8.0| 9.3、10.0 | 2008 R2企业版、2012企业版/标准版/web版、2016企业版/标准版/web版、2017企业版/标准版/web版 | N | N |
 华为云 | N | 5.5、5.6 | N | 2008 R2 企业版/web版、2012企业版/标准版/web版、2014企业版/标准版/web版、2016企业版/标准版/web版、2017企业版/标准版/web版 | 9.5、9.6、10、11、增强版 | N |
 腾讯云 | 10.1.9(TDSQL) | 5.5、5.6、5.7、8.0、8.0.18(TDSQL) | N | N | 5.7.17(TDSQL) |
 Google | N | 5.6、5.7 | N | 2017 Enterprise、2017 Express、2017 Standard、2017 Web | 9.6、10、11 | N |
 AWS | 10.2、10.3、10.4、10.5 | 5.6、5.7、8.0 | N | 2012企业版/标准版/web版/Express、2014企业版/标准版/web版/Express、2016企业版/标准版/web版/Express、2017企业版/标准版/web版/Express、2019企业版/标准版/web版/Express | 9.6、10、11、12、13 | N |
 Azure | 10.2、10.3 | 5.6、5.7、8.0 | N | | 9.5、9.6、10、11 | N |
 京东云 | 10.2 | 5.6、5.7、8.0 | N | 2008R2企业版/标准版/Web版、2012企业版/标准版/Web版、2014企业版/标准版/Web版、2016企业版/标准版/Web版、2017企业版/标准版/Web版 | 9.6、10、11、12、13 | 5.7 |
 HCSO | N | 5.6、5.7、8.0 | N | N | N| N |

