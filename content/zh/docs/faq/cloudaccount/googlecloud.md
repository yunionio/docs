---
title: "谷歌云"
linktitle: "谷歌云"
weight: 7
description: >
  介绍如何在谷歌云平台获取在var_oem_name平台需要使用的配置参数。
---

## 如何获取谷歌云服务帐号密钥信息？

### 纳管指定项目

1. 打开“[GCP Console中的IAM和管理-IAM页面](https://console.cloud.google.com/project/_/iam-admin)”页面并登录。

    ![](../../image/google_iam.png)

2. 单击顶部“选择项目”，选择需要授权的项目。
 
    ![](../../image/google_project.png)

3. 在左侧导航栏中选择“服务账号”，进入指定项目的服务账号页面。
4. 单击 **_"创建服务账号"_** 按钮，进入创建服务账号页面。
5. 配置服务账号名称、服务账号ID、服务账号说明等，单击 **_"创建"_** 按钮，创建服务账号并向此服务帐号授予对项目的访问权限。

    ![](../../image/google_createserviceaccount.png)

6. 选择Project-Owner或Project-Viewer角色，Owner代表对项目的管理权限，Viewer代表对项目的只读权限，如需云管平台对Google云账号资源进行管理操作，请选择Project-Owner角色，单击 **_"继续"_** 按钮。

    ![](../../image/google_serviceaccountpolicy.png)

7. 向用户授予访问此服务帐号的权限 (可选)步骤对云管平台无影响，请用户根据需求设置，配置完成后，单击 **_"继续"_** 按钮。
8. 在服务账号页面，单击新创建的服务账号右侧操作列![colum](../../image/colum.png)按钮，单击 **_"创建密钥"_** 菜单项。
 
    ![](../../image/google_serviceaccount1.png) 

9. 选择密钥类型为“JSON”，单击 **_"创建"_** 按钮，下载json格式的密钥文件，内容如下，分别获取project_id、private_key_id、private_key、client_email等内容。

    ![](../../image/google_create.png) 

    ```bash
    {
     "type": "service_account",
     "project_id": "[PROJECT-ID]",
     "private_key_id": "[KEY-ID]",
     "private_key": "-----BEGIN PRIVATE KEY-----\n[PRIVATE-KEY]\n-----END PRIVATE KEY-----\n",
     "client_email": "[SERVICE-ACCOUNT-EMAIL]",
     "client_id": "[CLIENT-ID]",
     "auth_uri": "https://accounts.google.com/o/oauth2/auth",
     "token_uri": "https://accounts.google.com/o/oauth2/token",
     "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
     "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/[SERVICE-ACCOUNT-EMAIL]"
     }
    ```

### 纳管多个项目

如需要使用上面获取的服务账户的密钥纳管多个项目，可按照以下步骤进行设置。

1. 打开“[GCP Console中的IAM和管理-IAM页面](https://console.cloud.google.com/project/_/iam-admin)”页面，选择其他需要纳管的项目。
2. 单击顶部 **_"添加"_** 按钮，在新成员中添加上面步骤创建的服务账号，并设置角色为Project-Owner或Project-Viewer，Owner代表对项目的管理权限，Viewer代表对项目的只读权限，如需云管平台对Google云账号资源进行管理操作，请选择Project-Owner角色，单击 **_"保存"_** 按钮。

    ![](../../image/google_serviceaccount_otherproject.png)

3. 重复上面的步骤，纳管更多项目。

## 启用相关API

{{% alert title="说明" %}}
谷歌云的API具有项目属性，当需要纳管谷歌云上多个项目时，需要分别在每个项目中启用相关API。
{{% /alert %}}

**{{<oem_name>}}管理谷歌云需要启用API**：

获取密钥文件后，还需要在Google API库中启用授权项目中的项目资源管理API（Cloud Resource Manager API）和自定义镜像创建机器API（Cloud Build API）。启用API后，用户可在{{<oem_name>}}平台管理使用谷歌云。
  
1. 在API库的[Cloud Resource Manager API](https://console.developers.google.com/apis/library/cloudresourcemanager.googleapis.com)页面中启用授权项目的Cloud Resource Manager API。可通过顶部切换授权项目。
   ![](../../image/cloudresourcemanagerapi.png)
         
2. 在API库的[Cloud Build API](https://console.developers.google.com/apis/library/cloudbuild.googleapis.com )页面中启用授权项目的Cloud Build API。可通过顶部切换授权项目。
   ![](../../image/cloudbuildapi.png)

**{{<oem_name>}}管理谷歌云RDS需要启用API**：

1. 如需在{{<oem_name>}}上管理谷歌云的RDS，需要在API库的[Cloud SQL Admin API](https://console.developers.google.com/apis/library/sqladmin.googleapis.com)页面中启用Cloud SQL Admin API。可通过顶部切换授权项目。
   ![](../../image/cloudsqladminapi.png)

## 管理谷歌云资源，需要云账号具备哪些权限

| 功能                                                      | 只读权限                                              | 可读可写权限                     |
| :----------                                               | :--------                                             | :----------                      |
| 所有功能总和                                              | Viewer                                                | Editor                           |
| 虚拟机, 磁盘, 安全组, 镜像, 快照, 磁盘, 镜像, 负载均衡    | Compute Viewer                                        | Compute Editor                   |
| 项目                                                      | -                                                     | -                                |
| Vpc, Vpc对等连接, 路由表, NAT, 弹性网卡,EIP, NAT          | Compute Network Viewer                                | Compute Network Admin            |
| 对象存储                                                  | Storage Legacy Bucket Reader<br>Storage Object Viewer | Storage Admin                    |
| RDS                                                       | Cloud SQL Viewer                                      | Cloud SQL Admin                  |
| 弹性缓存                                                  | Redis Enterprise Cloud Viewer                         | Redis Enterprise Cloud Admin     |
| 操作日志                                                  | Logs Viewer                                           | Logging Admin                    |
| NAS                                                       | Cloud Filestore Viewer                                | Cloud Filestore Editor           |
| WAF                                                       | -                                                     | -                                |
| IAM                                                       | Role Viewer                                           | Role Administrator               |
| DNS                                                       | DNS Reader                                            | DNS Administrator                |
| 账单,费用                                                 | Billing Account Viewer                                | Billing Account Administrator    |
| 监控                                                      | Monitoring Viewer                                     | Monitoring Admin                 |

## 如何在谷歌云平台配置并获取Bigquery配置信息?

1. 登录谷歌云控制台，单击左侧菜单 **_"结算"_** 菜单项，进入结算页面。
   ![](../../image/googlebilling.png)

2. 单击左侧菜单[结算导出]，在BIGQUERY EXPORT页签下，启用详细使用费，并配置项目和数据集名称。

    ![](../../image/googlebigqueryconfig.png)

3. 单击数据集名称，跳转到Bigquery，展开右侧节点，选中数据集名称下的分区表，在进入的页面中单击顶部“详情”页签，获取表ID信息。

    ![](../../image/gcpbigquerytableid.png)

4. 在表详情页面，单击右上角 **_"修改详情"_** 按钮，将有效期设置为None。若设置有效期则会从bigquery中清理过期的数据，请谨慎设置。

    ![](../../image/gcomodifytable.png)

## 如何在谷歌云平台获取账单文件以及使用量文件的存储桶URL和文件前缀？

### 如何获取账单文件的存储桶URL以及文件前缀？

1. 登录谷歌云控制台，单击左侧菜单 **_"结算"_** 菜单项，进入结算页面。
   ![](../../image/googlebilling.png)

2. 单击左侧菜单[结算导出]，在进入的账单页面中单击“文件导出”页签，查看并记录存储分区名称以及报告前缀的信息。其中报告前缀即文件前缀。如果未设置，需要在该页面配置存储分区名称和报告前缀信息等，设置完成后，每天的增量账单数据将同步存储到对应的存储上。建议该bucket中仅存放账单文件。
   ![](../../image/googlebillingbucket.png)

3. 单击左侧菜单[Storage/浏览器]，在进入的存储页面中单击对应存储分区名称，并单击“概览”页签，查看存储分区的概览信息，其中链接网址为存储桶URL。
   ![](../../image/googlebillingbucketurl.png) 

4. 当账单bucket中除账单文件外还存放了其他文件时，需要配置文件前缀仅获取bucket中的账单文件等。

### 如何获取使用量文件存储桶URL和文件前缀？

1. 在谷歌云控制台中单击左侧菜单[Compute Engine/设置]，进入设置页面。</br>
   ![](../../image/googleusagesetting.png)

2. 请确保已勾选“启用使用情况导出功能”，并记录存储分区名称和报告前缀信息，其中报告前缀即文件前缀。如未配置，需要勾选“启用使用情况导出功能”，并配置存储分区等。
   ![](../../image/googleusagebucket.png) 

3. 单击左侧菜单[Storage/浏览器]，在进入的存储页面中单击对应存储分区名称，并单击“概览”页签，查看存储分区的概览信息，其中链接网址为存储桶URL。
   ![](../../image/googleusagebucketurl.png)

4. 当使用量bucket中除使用量文件外还存放了其他文件时，需要配置文件前缀仅获取bucket中的使用量文件等。
