---
title: "Azure"
linktitle: "Azure"
weight: 3
description: >
 介绍Azure租户ID和Client信息的获取方式
---

## 获取Azure的租户（Tenant）ID和Client信息

1. 登录Azure控制台，单击左侧导航栏 **_"Azure Active Directory/应用注册"_** 菜单项，进入应用注册页面。建议新建一个专门的应用程序供云管平台调用Azure API。
   ![](../../image/azureregisterapp.png)

2. 单击 **_新注册_** 按钮，在进入的注册应用程序页面，设置名称为任意值、设置受支持的账户类型为“仅此目录中的账户”，重定向URI设置为web，并输入以"[https://](https://)"或"[http://localhost](http://localhost)"开头的URL地址，单击 **_"注册"_** 按钮。
   ![](../../image/azureregisteredapp.png)

3. 创建成功后，系统自动显示刚创建的应用程序详情页面。该页面的应用程序（客户端）ID即为所需的客户端ID、目录（租户）ID即为所需的租户ID。
   ![](../../image/azureclientid.png)

4. 在应用程序详情页面单击 **_"证书和密码"_** 菜单项。进入证书和密码页面。单击 **_"新客户端密码"_** 按钮。
   ![](../../image/azureclientsecretlist.png)

5. 在弹出的添加客户端对话框输入密码说明、截止日期为“从不”，单击 **_"添加"_** 按钮新建客户端密码。
   ![](../../image/azurecreatesecret.png)

6. 保存成功后，页面密码的值即为需要的客户端密码信息。
   ![](../../image/azureclientsecret.png)

## 如何把订阅的权限授权给应用程序

1. 登录Azure控制台，单击左侧导航栏 **_"所有服务"_** 菜单项，在所有服务列表中选择并单击 **_"订阅"_** 菜单项，进入订阅列表。
   ![](../../image/azuresub.png)

2. 单击需要被授权的订阅，进入订阅的详情页面；
   ![](../../image/azuresublist.png)

3. 单击[访问控制(标识和访问管理)]，在进入的访问控制页面中单击 **_"添加角色分配"_** 按钮，进入添加角色分配页面。
   ![](../../image/azuresubrole.png)

4. 角色为“所有者”，将访问权限分配到对话框为“用户、组或服务主体”、在选择搜索框中搜索上一步骤创建的应用程序的名称，并选中应用程序，单击 **_"保存"_** 按钮。
   ![](../../image/azuresubaddrole.png)

5. 在角色分配页面，查看订阅的权限已授权给应用程序。
   ![](../../image/azuresubapprole.png)

## 应用程序API权限设置

请确保应用程序拥有Azure Active Directory API下的以下权限。

区域 | API权限
---------|----------
 Azure中国 | Directory: Directory.Read.All, Directory.ReadWrite.All</br> Domain: Domain.Read.All
 Azure国际区 | Directory: Directory.Read.All, Directory.ReadWrite.All</br> Domain: Domain.Read.All, Domain.ReadWrite.All; </br>Member:  Member.Read.Hidden; </br>Policy: Policy.Read.All;
 
**查看及设置步骤**

以Azure国内区为例。

1. 在Azure控制台，单击左侧导航栏 **_"Azure Active Directory/应用注册"_** 菜单项，进入应用注册页面。
2. 在新注册的应用程序详情页面，单击 **_"API权限"_** 菜单项，进入API权限页面，查看API权限。

    ![](../../image/azureapilist.png)

3. 检查应用程序的API权限是否满足上面的要求，如不满足，单击 **_"添加权限"_** 按钮，弹出请求获取API权限对话框。

    ![](../../image/azurerequestapi1.png)

4. 选择“Microsoft Graph”，应用程序选择“应用程序权限”，并勾选Directory和Domian下的所有权限，单击 **_"添加权限"_** 按钮，完成配置。

    ![](../../image/azurecreateapi1.png)

## 管理Azure云资源，需要云账号具备哪些权限

| 功能                                                      | 只读权限                                              | 可读可写权限                                                      |
| :----------                                               | :--------                                             | :----------                                                       |
| 所有功能总和                                              | Reader                                                | Owner                                                             |
| 虚拟机, 磁盘, 安全组, 镜像, 快照, 磁盘, 镜像, 负载均衡    | -                                                     | Virtual Machine Contributor<br>Classic Virtual Machine Contributor|
| 项目                                                      | -                                                     | -                                                                 |
| Vpc, Vpc对等连接, 路由表, NAT, 弹性网卡,EIP, NAT, WAF     | -                                                     | Network Contributor,<br>Classic Network Contributor               |
| 对象存储                                                  | Storage Blob Data Reader                              | Storage Blob Data Owner                                           |
| RDS                                                       | Cloud SQL Viewer                                      | Cloud SQL Admin                                                   |
| 弹性缓存                                                  | Redis Enterprise Cloud Viewer                         | Redis Enterprise Cloud Admin                                      |
| NAS                                                       | Storage File Data SMB Share Reader                    | Storage File Data SMB Share Contributor                           |
| WAF                                                       | -                                                     | -                                                                 |
| IAM                                                       | -                                                     | Graph Owner<br>Resource Policy Contributor                        |
| DNS                                                       | -                                                     | DNS Zone Contributor<br>Private DNS Zone Contributor              |
| 账单,费用                                                 | Billing Reader<br>Cost Management Reader              | Cost Management Contributor                                       |
| 监控,操作日志                                             | Monitoring Reader                                     | Monitoring Contributor                                            |

## 如何获取Azure合约编号和密钥？

1. 登录[Azure中国EA Portal](https://ea.azure.cn/)or[Azure EA Portal](https://ea.azure.com/)，登录系统后，左上角数字即为合约编号。
   ![](../../image/azure_number.png)

2. 单击左侧导航栏 **_"报表"_** 菜单项，选择“下载使用量>API访问密钥”页签，该页面的主密钥即为密钥。
   ![](../../image/azure_apikey.png) 

