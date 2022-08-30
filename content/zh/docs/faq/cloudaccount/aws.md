---
title: "AWS"
linktitle: "AWS"
weight: 2
description: >
   介绍如何在AWS上获取在var_oem_name平台需要使用的配置参数。
---

## 获取AWS的访问密钥

1. 使用AWS主账号（或拥有AdministratorAccess管理权限的子账号）登录AWS管理控制台，单击 **_"IAM"_** 菜单项，进入IAM控制面板页面。
    ![](../../image/faq_account_aws_1.png) 

2. 单击左侧菜单栏 **_"用户"_** 菜单项，进入用户管理列表，单击用户名名称项，进入指定用户详情页面。注意需要选择有足够管理权限的用户。
    ![](../../image/faq_account_aws_2.png)

3. 单击“**安全证书**”页签。
    ![](../../image/faq_account_aws_3.png)

4. 单击 **_"创建访问密钥"_** 按钮，在弹出的创建访问密钥对话框中即可看到密钥信息，即密钥ID（Access Key ID）、密码（Access Key Secret）。
    ![](../../image/faq_account_aws_4.png)

{{% alert title="注意" color="warning" %}}
私有访问密钥仅创建时可见，请复制另存，如果不慎丢失，重新创建即可。
{{% /alert %}}


## 通过平台管理AWS资源，需要云账号具备哪些权限？

| 功能                                              | 只读权限                                          | 可读可写权限                                 |
| :----------                                       | :--------                                         | :----------                                  |
| 所有功能总和                                      | ReadOnlyAccess                                    | AdministratorAccess                          |
| 虚拟机, 磁盘, 安全组, 镜像, 快照, 磁盘, 镜像      | AmazonEC2ReadOnlyAccess                           | AmazonEC2FullAccess                          |
| 项目                                              | -                                                 | -                                            |
| Vpc, Vpc对等连接, 路由表, NAT, 弹性网卡,EIP, NAT  | AmazonVPCReadOnlyAccess                           | AmazonVPCFullAccess                          |
| 对象存储                                          | AmazonS3ReadOnlyAccess                            | AmazonS3FullAccess                           |
| 负载均衡                                          | ElasticLoadBalancingReadOnly                      | ElasticLoadBalancingFullAccess               |
| RDS                                               | AmazonRDSReadOnlyAccess                           | AmazonRDSFullAccess                          |
| 弹性缓存                                          | AmazonElastiCacheReadOnlyAccess                   | AmazonElastiCacheFullAccess                  |
| 操作日志                                          | AWSCloudTrailReadOnlyAccess                       | AWSCloudTrail_FullAccess                     |
| NAS                                               | AmazonElasticFileSystemReadOnlyAccess             | AmazonElasticFileSystemFullAccess            |
| WAF                                               | AWSWAFReadOnlyAccess                              | AWSWAFFullAccess                             |
| IAM                                               | IAMReadOnlyAccess                                 | IAMFullAccess                                |
| DNS                                               | AmazonRoute53DomainsReadOnlyAccess                | AmazonRoute53DomainsFullAccess               |
| 账单,费用                                         | AWSBillingReadOnlyAccess                          | Billing                                      |
| 监控                                              | CloudWatchReadOnlyAccess                          | CloudWatchFullAccess                         |

## 如何在AWS平台获取账单存储桶URL和文件前缀？

**新版**

2019/08/07日期之后创建的AWS账号必须采用该方式配置并获取存储桶的URL和文件前缀。

1. 使用AWS主账号登录AWS管理控制台，单击右上角[用户名]的下拉菜单 **_"我的账单控制面板"_** 菜单项，进入账单和成本管理控制面板页面。
    
    ![](../../image/awsbilling.png)

2. 单击左侧菜单 **_"Cost & Usage Reoports"_** 菜单项，在AWS成本和使用率报告页面，单击 **_"创建报告"_** 按钮，进入创建报告页面。

    ![](../../image/awscostreport.png)

3. 配置报告名称、勾选“包括资源ID”，单击 **_"下一步"_** 按钮，进入交付选项页面。

    ![](../../image/awscreatecostreport.png)

4. 配置S3存储桶，支持选择已有的存储桶或创建新的存储桶。

    ![](../../image/awscosts3.png)
    ![](../../image/awscosts3policy.png)

5. 配置报告路径前缀、时间粒度选择“每小时”、报告版本为“创建新报告版本”、压缩类型选择“ZIP”，单击 **_"下一步"_** 按钮，进入审核页面。

    ![](../../image/awscostreportconfig.png)

6. 确认配置无误后，记录红框中的S3存储桶和报告路径前缀，单击 **_"查看和完成"_** 按钮，完成配置，创建报告。

    ![](../../image/awscostreportfinish.png)

7. 在AWS控制台的S3存储管理页面中查看对应存储桶中任意账单文件的概述信息，并记录对象URL，存储桶URL即为去掉后面文件名称的URL，如红框所示。

    ![](../../image/awscosts3bucketurl.png)

8. 文件前缀即为步骤6中红框中的报告路径前缀。

**旧版**

1. 使用AWS主账号登录AWS管理控制台，单击右上角[用户名]的下拉菜单 **_"我的账单控制面板"_** 菜单项，进入账单和成本管理控制面板页面。
    
    ![](../../image/awsbilling.png)

2. 单击左侧菜单 **_"账单首选项"_** ，在首选项页面的“成本管理首选项”中查看并记录“接收账单报告”的S3存储桶，如未配置，需要勾选“接收账单报告”并配置S3存储桶并验证，设置完成后，将根据设置的粒度将增量账单数据将同步存储到对应的OSS上。建议该bucket中仅存放账单文件。
    
    ![](../../image/awsbillingbucket.png)
   
3. 在AWS控制台的S3存储管理页面中查看对应存储桶中任意账单文件的概述信息，并记录对象URL，存储桶URL即为去掉后面文件名称的URL，如红框所示。
    
    ![](../../image/awsbillingbucketurl.png)

4. AWS的文件前缀为AWS账号ID。

{{% alert title="说明" %}}
当账单bucket中除账单文件外还存放了其他文件时，需要配置文件前缀仅获取bucket中的账单文件等。
{{% /alert %}}

## 如何纳管AWS Organizations组织账户?

1. 配置AWS Organizations：使用AWS组织账号关联AWS账户，支持创建新的AWS账户和邀请现有的AWS账户；被邀请的AWS账户上需要存在“OrganizationAccountAccessRole”角色。
2. 获取访问密钥：在AWS组织账号上的管理账号的IAM用户创建访问密钥，建议使用具有AdministratorAccess权限的用户。

### 配置AWS Organizations

1. 使用AWS主账号（或拥有AdministratorAccess管理权限的子账号）登录AWS管理控制台，单击右上角[用户名]的下拉菜单 **_"我的账单控制面板"_** 菜单项，进入账单和成本管理控制面板页面。

    ![](../../image/awsbilling.png)

2. 单击右侧 **_"整合账单"_** 菜单项，进入AWS Organizations页面。

    ![](../../image/awsorgmenu.png)

3. 在AWS Organizations - AWS 账户页面，添加AWS账户，目前支持两种将AWS账号添加到Organization的方式。
    - 创建AWS账户：设置AWS账户名、账户拥有者的电子邮件地址以及IAM角色名称（OrganizationAccountAccessRole），单击 **_"创建AWS账户"_** 按钮，创建AWS账户。
        
        ![](../../image/awscreateorgaccount.png)
    - 邀请现有AWS账户：设置要邀请的AWS账户的电子邮件地址或账户ID，单击 **_"发送邀请"_** 按钮，等待账户拥有者接收请求，加入Organizations，此外还需要现有的AWS账号存在OrganizationAccountAccessRole的角色，如不存在请参考[如何在AWS账户中添加OrganizationAccountAccessRole的角色?](#如何在aws账户中添加organizationaccountaccessrole的角色)。
        
        ![](../../image/awsorginviteaccount.png)

### 获取访问密钥

1. 在AWS Organizations的管理账户上获取访问密钥，建议使用具有AdministratorAccess权限的IAM用户，创建访问密钥。
2. 获取访问密钥的具体步骤，请参考[获取AWS的访问密钥](#获取aws的访问密钥)。

### 如何在AWS账户中添加OrganizationAccountAccessRole的角色?

1. 使用AWS主账号（或拥有AdministratorAccess管理权限的子账号）登录AWS管理控制台，单击 **_"IAM"_** 菜单项，进入IAM控制面板页面。
2. 单击右侧 **_"角色"_** 菜单项，在角色页面，单击 **_"创建角色"_** 按钮，进入创建角色页面。

    ![](../../image/awscreaterole.png)

3. 选择受信任实体的类型为“其他AWS账户”,并填入管理AWS组织的账号ID，单击 **_"下一步：权限"_** 按钮。
    
    ![](../../image/awsroleconfig.png)

4. Attach 权限策略选择“AdministratorAccess”，单击 **_"下一步：标签"_** 按钮。
    
    ![](../../image/awsroleconfigpolicy.png)

5. 请根据需求配置标签，配置完成后，单击 **_"下一步：审核"_** 按钮。
6. 配置角色名称为“OrganizationAccountAccessRole”，单击 **_"创建角色"_** 按钮。

    ![](../../image/awsroleconfigconfirm.png)