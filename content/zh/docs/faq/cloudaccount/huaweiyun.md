---
title: "华为云"
linktitle: "华为云"
weight: 4
description: >
   介绍在华为云平台获取在var_oem_name平台需要使用的配置参数。
---

## 如何获取华为云的API密钥

### 新版

1. 登录华为云控制台，鼠标悬停在右上角用户名处，选择下拉菜单 **_"我的凭证"_** 菜单项，进入我的凭证页面。

    ![](../../image/huaweinewaccount.png)

2. 单击左侧[访问密钥]菜单，在访问密钥页面单击 **_"新增访问密钥"_** 按钮。

    ![](../../image/huaweinewak.png)

3. 通过验证后，会下载credentials名称的Excel表格，打开表格后即可获取密钥ID（Access Key ID）和密码（Secret Access Key）。
    ![](../../image/faq_account_huawei_3.png)

### 旧版

1. 登录华为云控制台，鼠标悬停在右上角用户名处，选择下拉菜单 **_"我的凭证"_** 菜单项，进入我的凭证页面。
   ![](../../image/faq_account_huawei_1.png)

2. 单击“**管理访问密钥**”页签，在管理访问密钥页面单击 **_"新增访问密钥"_** 按钮。
   ![](../../image/faq_account_huawei_2.png)

3. 通过验证后，会下载credentials名称的Excel表格，打开表格后即可获取密钥ID（Access Key ID）和密码（Secret Access Key）。
   ![](../../image/faq_account_huawei_3.png)

## 管理华为云资源，需要云账号具备哪些权限

| 功能                                          | 只读权限                                          | 可读可写权限                                     |
| :----------                                   | :--------                                         | :----------                                      |
| 所有功能总和                                  | Tenant Guest<br>IAM ReadOnlyAccess                | Tenant Administrator<br>Security Administrator   |
| 虚拟机                                        | ECS ReadOnlyAccess                                | ECS FullAccess                                   |
| 磁盘, 快照                                    | EVS ReadOnlyAccess                                | EVS FullAccess                                   |
| 项目                                          | EPS ReadOnlyAccess                                | EPS FullAccess                                   |
| 镜像                                          | IMS ReadOnlyAccess                                | IMS FullAccess                                   |
| Vpc, Vpc对等连接, 路由表, 弹性网卡,EIP,安全组 | VPC ReadOnlyAccess                                | VPC FullAccess                                   |
| NAT                                           | NAT ReadOnlyAccess                                | NAT FullAccess                                   |
| 对象存储                                      | OBS ReadOnlyAccess                                | OBS Administrator                                |
| 负载均衡                                      | ELB ReadOnlyAccess                                | ELB FullAccess                                   |
| RDS                                           | RDS ReadOnlyAccess                                | RDS FullAccess                                   |
| 弹性缓存                                      | DCS ReadOnlyAccess                                | DCS FullAccess                                   |
| 操作日志                                      | CTS ReadOnlyAccess                                | CTS FullAccess                                   |
| NAS                                           | SFS ReadOnlyAccess<br>SFS Turbo ReadOnlyAccess    | SFS FullAccess<br>SFS Turbo FullAccess           |
| WAF                                           | WAF ReadOnlyAccess                                | WAF FullAccess                                   |
| IAM                                           | IAM ReadOnlyAccess                                | Security Administrator                           |
| DNS                                           | DNS ReadOnlyAccess                                | DNS FullAccess                                   |
| 账单,余额,费用                                | BSS Operator                                      | BSS Administrator                                |
| 监控                                          | CES ReadOnlyAccess                                | CES FullAccess                                   |

## 如何在华为云平台获取账单存储桶的URL？

### 新版

1. 登录华为云平台，单击顶部 **_"费用中心-费用账单"_** 菜单项，进入费用中心页面。
    ![](../../image/huaweinewconsum.png)

2. 单击左侧[总览]菜单，在总览页面的右侧部分“账单数据存储”中查看并记录对象存储名称，如未配置，需要在该页面启用账单数据存储，并配置存储的OBS桶并进行授权验证操作等，设置完成后，每天的增量账单数据将同步存储到对应的OBS上。建议该bucket中仅存放账单文件。

    ![](../../image/huaweinewbillingbucket.png)

3. 在华为云控制台的对象存储服务(OBS)中查看对应存储桶的概览信息，获取访问域名即为存储桶URL。

    ![](../../image/huaweibillingbucketurl.png) 

### 旧版

1. 登录华为云平台，单击顶部[更多]菜单的下拉菜单 **_"费用-消费总览"_** 菜单项，进入费用中心页面。
   ![](../../image/huaweiconsum.png)

2. 单击左侧[消费数据存储]菜单，在进入的消费数据存储中查看并记录对象存储桶名称，如未配置，需要在该页面设置存储的OBS桶并进行授权验证操作等，设置完成后，每天的增量账单数据将同步存储到对应的OBS上。建议该bucket中仅存放账单文件。
   ![](../../image/huaweibillingbucket.png)

3. 在华为云控制台的对象存储服务(OBS)中查看对应存储桶的概览信息，获取访问域名即为存储桶URL。
   ![](../../image/huaweibillingbucketurl.png) 
   
