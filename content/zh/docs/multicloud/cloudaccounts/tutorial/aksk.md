---
title: "获取云平台AccessKey"
date: 2021-06-11T08:22:33+08:00
weight: 210
description: >
    介绍如何获取公有云平台的AccessKey
---

## 获取云平台AccessKey

{{< tabs >}}
{{% tab name="阿里云" %}}

### 主账号获取AccessKey

1. 使用主账号登录阿里云控制台，单击页面右上角个人信息，展开下拉菜单，单击 **_"Accesskeys"_** 菜单项进入安全信息管理页面。
   ![](../../images/aliyun-accesskeys1.png)

2. 在安全信息管理页面，可以查看已存在的AccessKey信息，也可以单击 **_"创建AccessKey"_** 按钮新建用户AccessKey，新建AccessKey时阿里云会向账号联系人手机发送验证码，验证通过后才可以创建AccessKey。
   ![](../../images/aliyun-get_acceesskey_list.png)

3. Access Key Secret默认不显示，单击"**显示** "链接，阿里云将向账号所属的联系人手机发送一个验证码，验证通过后，才会显示Access Key Secret。
   ![](../../images/aliyun-get_access_key_secret.png)

### RAM子账号如何获取Access Key

1. 使用子账号登录阿里云控制台，单击页面右上角个人信息，展开下拉菜单，单击 "**accesskey...**" 进入安全信息管理页面。
   ![](../../images/aliyun_ram_get_access_key.png)

2. 在安全信息管理页面，单击 **_"创建AccessKey"_** 按钮，创建AccessKey。
   ![](../../images/aliyun_get_ram_access_key_create.png)

3. 创建成功后，AccessKeySecret信息只会展示一次，请及时保存。
   ![](../../images/aliyun_ram_access_key_get.png)

{{% alert title="注意" color="warning" %}}
已创建的AccessKey，无法再查看AccessKeySecret。
{{% /alert %}}
 

{{% /tab %}}


{{% tab name="AWS" %}}

{{% alert title="注意" color="warning" %}}
私有访问密钥仅创建时可见，请复制另存，如果不慎丢失，重新创建即可。
{{% /alert %}}

### 主账号获取AccessKey

1. 使用AWS主账号（或拥有Administrator Access管理权限的子账号）登录AWS管理控制台，单击 **_"IAM"_** 菜单项，进入IAM控制面板页面。
   ![](../../images/faq_account_aws_1.png) 

2. 单击左侧菜单栏 **_"用户"_** 菜单项，进入用户管理列表，单击用户名名称项，进入指定用户详情页面。注意需要选择有足够管理权限的用户。
   ![](../../images/faq_account_aws_2.png)

3. 单击“**安全证书**”页签。
   ![](../../images/faq_account_aws_3.png)

4. 单击 **_"创建访问密钥"_** 按钮，在弹出的创建访问密钥对话框中即可看到密钥信息，即密钥ID（Access Key ID）、密码（Access Key Secret）。
   ![](../../images/faq_account_aws_4.png)

### 如何纳管AWS Organizations组织账户?

1. 配置AWS Organizations：使用AWS组织账号关联AWS账户，支持创建新的AWS账户和邀请现有的AWS账户；被邀请的AWS账户上需要存在“OrganizationAccountAccessRole”角色。
2. 获取访问密钥：在AWS组织账号上的管理账号的IAM用户创建访问密钥，建议使用具有AdministratorAccess权限的用户。

#### 配置AWS Organizations

1. 使用AWS主账号（或拥有AdministratorAccess管理权限的子账号）登录AWS管理控制台，单击右上角[用户名]的下拉菜单 **_"我的账单控制面板"_** 菜单项，进入账单和成本管理控制面板页面。

    ![](../../images/awsbilling.png)

2. 单击右侧 **_"整合账单"_** 菜单项，进入AWS Organizations页面。

    ![](../../images/awsorgmenu.png)

3. 在AWS Organizations - AWS 账户页面，添加AWS账户，目前支持两种将AWS账号添加到Organization的方式。
    - 创建AWS账户：设置AWS账户名、账户拥有者的电子邮件地址以及IAM角色名称（OrganizationAccountAccessRole），单击 **_"创建AWS账户"_** 按钮，创建AWS账户。
        
        ![](../../images/awscreateorgaccount.png)
    - 邀请现有AWS账户：设置要邀请的AWS账户的电子邮件地址或账户ID，单击 **_"发送邀请"_** 按钮，等待账户拥有者接收请求，加入Organizations，此外还需要现有的AWS账号存在OrganizationAccountAccessRole的角色，请参考下面步骤配置OrganizationAccountAccessRole的角色。
        
        ![](../../images/awsorginviteaccount.png)

#### 获取访问密钥

1. 在AWS Organizations的管理账户上获取访问密钥，建议使用具有AdministratorAccess权限的IAM用户，创建访问密钥。
2. 获取访问密钥的具体步骤

#### 如何在AWS账户中添加OrganizationAccountAccessRole的角色?

1. 使用AWS主账号（或拥有AdministratorAccess管理权限的子账号）登录AWS管理控制台，单击 **_"IAM"_** 菜单项，进入IAM控制面板页面。
2. 单击右侧 **_"角色"_** 菜单项，在角色页面，单击 **_"创建角色"_** 按钮，进入创建角色页面。

    ![](../../images/awscreaterole.png)

3. 选择受信任实体的类型为“其他AWS账户”,并填入管理AWS组织的账号ID，单击 **_"下一步：权限"_** 按钮。
    
    ![](../../images/awsroleconfig.png)

4. Attach 权限策略选择“AdministratorAccess”，单击 **_"下一步：标签"_** 按钮。
    
    ![](../../images/awsroleconfigpolicy.png)

5. 请根据需求配置标签，配置完成后，单击 **_"下一步：审核"_** 按钮。
6. 配置角色名称为“OrganizationAccountAccessRole”，单击 **_"创建角色"_** 按钮。

    ![](../../images/awsroleconfigconfirm.png)


{{% /tab %}}


{{% tab name="Azure" %}}

1. 登录Azure控制台，单击左侧导航栏 **_"Azure Active Directory/应用注册"_** 菜单项，进入应用注册页面。建议新建一个专门的应用程序供云管平台调用Azure API。
   ![](../../images/azureregisterapp.png)

2. 单击 **_新注册_** 按钮，在进入的注册应用程序页面，设置名称为任意值、设置受支持的账户类型为“仅此目录中的账户”，重定向URI设置为web，并输入以"[https://](https://)"或"[http://localhost](http://localhost)"开头的URL地址，单击 **_"注册"_** 按钮。
   ![](../../images/azureregisteredapp.png)

3. 创建成功后，系统自动显示刚创建的应用程序详情页面。该页面的应用程序（客户端）ID即为所需的客户端ID、目录（租户）ID即为所需的租户ID。
   ![](../../images/azureclientid.png)

4. 在应用程序详情页面单击 **_"证书和密码"_** 菜单项。进入证书和密码页面。单击 **_"新客户端密码"_** 按钮。
   ![](../../images/azureclientsecretlist.png)

5. 在弹出的添加客户端对话框输入密码说明、截止日期为“从不”，单击 **_"添加"_** 按钮新建客户端密码。
   ![](../../images/azurecreatesecret.png)

6. 保存成功后，页面密码的值即为需要的客户端密码信息。
   ![](../../images/azureclientsecret.png)


{{% /tab %}}


{{% tab name="华为云" %}}

### 获取访问密钥

**新版**

1. 登录华为云控制台，鼠标悬停在右上角用户名处，选择下拉菜单 **_"我的凭证"_** 菜单项，进入我的凭证页面。

    ![](../../images/huaweinewaccount.png)
2. 单击左侧[访问密钥]菜单，在访问密钥页面单击 **_"新增访问密钥"_** 按钮。

    ![](../../images/huaweinewak.png)

3. 通过验证后，会下载credentials名称的Excel表格，打开表格后即可获取密钥ID（Access Key ID）和密码（Secret Access Key）。
    ![](../../images/faq_account_huawei_3.png)

**旧版**

1. 登录华为云控制台，鼠标悬停在右上角用户名处，选择下拉菜单 **_"我的凭证"_** 菜单项，进入我的凭证页面。
     ![](../../images/faq_account_huawei_1.png)
2. 单击“**管理访问密钥**”页签，在管理访问密钥页面单击 **_"新增访问密钥"_** 按钮。
     ![](../../images/faq_account_huawei_2.png)
3. 通过验证后，会下载credentials名称的Excel表格，打开表格后即可获取密钥ID（Access Key ID）和密码（Secret Access Key）。
     ![](../../images/faq_account_huawei_3.png)


{{% /tab %}}


{{% tab name="腾讯云" %}}

### 获取访问密钥

1. 登录腾讯云控制台，单击右上角 **_"云产品"_** 菜单项，在展开的菜单中搜索 **_"云API密钥"_** 菜单项，单击进入API密钥管理页面。
   ![](../../images/faq_account_qcloud_1.png)

2. 在API密钥管理页面获取APP ID、密钥ID（SecretId）、密码（SecretKey）对应的值。
   ![](../../images/faq_account_qcloud_2.png)

{{% /tab %}}

{{% tab name="UCloud" %}}

### 获取访问密钥

1. 登录 UCloud 控制台，单击顶部 **_"全部产品"_** ，搜索或选择 **_"开放API UAPI"_** 菜单项 ，进入 API 产品页面；
    
    ![](../../images/ucloudapi.png)

2. 单击“API密钥”页签，进入API 密钥页面。单击 **_"显示"_** 按钮，进行手机短信二次验证；

    ![](../../images/ucloudapikeyshow.png)

3. 通过手机验证后获取公钥和私钥值。

    ![](../../images/ucloudapikeypair.png)

4. 若使用子账号，除获取公钥或私钥外，还需要获取project_id，在“访问控制-用户管理-子账户详情”中获取project_id为个人权限中的应用项目的项目ID。

    ![](../../images/ucloudprojectid.png)


{{% /tab %}}


{{% tab name="Google云" %}}

### 获取访问密钥

**纳管指定项目**

1. 打开“[GCP Console中的IAM和管理-IAM页面](https://console.cloud.google.com/project/_/iam-admin)”页面并登录。

    ![](../../images/google_iam.png)

2. 单击顶部“选择项目”，选择需要授权的项目。
 
    ![](../../images/google_project.png)

3. 在左侧导航栏中选择“服务账号”，进入指定项目的服务账号页面。
4. 单击 **_"创建服务账号"_** 按钮，进入创建服务账号页面。
5. 配置服务账号名称、服务账号ID、服务账号说明等，单击 **_"创建"_** 按钮，创建服务账号并向此服务帐号授予对项目的访问权限。

    ![](../../images/google_createserviceaccount.png)

6. 选择Project-Owner或Project-Viewer角色，Owner代表对项目的管理权限，Viewer代表对项目的只读权限，如需云管平台对Google云账号资源进行管理操作，请选择Project-Owner角色，单击 **_"继续"_** 按钮。

    ![](../../images/google_serviceaccountpolicy.png)

7. 向用户授予访问此服务帐号的权限 (可选)步骤对云管平台无影响，请用户根据需求设置，配置完成后，单击 **_"继续"_** 按钮。

8. 在服务账号页面，单击新创建的服务账号右侧操作列按钮，单击 **_"创建密钥"_** 菜单项。
 
    ![](../../images/google_serviceaccount1.png) 

9. 选择密钥类型为“JSON”，单击 **_"创建"_** 按钮，下载json格式的密钥文件，内容如下，分别获取project_id、private_key_id、private_key、client_email等内容。

    ![](../../images/google_create.png) 

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

**纳管多个项目**

如需要使用上面获取的服务账户的密钥纳管多个项目，可按照以下步骤进行设置。

1. 打开“[GCP Console中的IAM和管理-IAM页面](https://console.cloud.google.com/project/_/iam-admin)”页面，选择其他需要纳管的项目。
2. 单击顶部 **_"添加"_** 按钮，在新成员中添加上面步骤创建的服务账号，并设置角色为Project-Owner或Project-Viewer，Owner代表对项目的管理权限，Viewer代表对项目的只读权限，如需云管平台对Google云账号资源进行管理操作，请选择Project-Owner角色，单击 **_"保存"_** 按钮。

    ![](../../images/google_serviceaccount_otherproject.png)

3. 重复上面的步骤，纳管更多项目。

### 启用相关API

{{% alert title="说明" %}}
谷歌云的API具有项目属性，当需要纳管谷歌云上多个项目时，需要分别在每个项目中启用相关API。
{{% /alert %}}

**管理谷歌云需要启用API**：

获取密钥文件后，还需要在Google API库中启用授权项目中的项目资源管理API（Cloud Resource Manager API）和自定义镜像创建机器API（Cloud Build API）。启用API后，用户可在平台管理使用谷歌云。

1. 在API库的[Cloud Resource Manager API](https://console.developers.google.com/apis/library/cloudresourcemanager.googleapis.com)页面中启用授权项目的Cloud Resource Manager API。可通过顶部切换授权项目。
   ![](../../images/cloudresourcemanagerapi.png)

2. 在API库的[Cloud Build API](https://console.developers.google.com/apis/library/cloudbuild.googleapis.com )页面中启用授权项目的Cloud Build API。可通过顶部切换授权项目。
   ![](../../images/cloudbuildapi.png)

**管理谷歌云RDS需要启用API**：

1. 在API库的[Cloud SQL Admin API](https://console.developers.google.com/apis/library/sqladmin.googleapis.com)页面中启用Cloud SQL Admin API。可通过顶部切换授权项目。
   ![](../../images/cloudsqladminapi.png)

{{% /tab %}}

{{% tab name="天翼云 " %}}

### 获取访问密钥

1. {{<oem_name>}}平台部署完成后，需要记录所在服务器的出口公网IP。

```
# 联系网管或通过工具获取
$ curl 'https://api.ipify.org?format=json'
{"ip":"8.210.190.83"}

```
2. 联系天翼云技术支持，将此公网IP加入到天翼云白名单中。
3. 联系天翼云技术支持，获取api 访问所需的AccessKey。

{{% alert title="注意" color="warning" %}}

{{% /alert %}}
- 自行从天翼云web控制台生成的AccessKey，有可能无法正常使用。请联系天翼云技术支持获取AccessKey。
- 只支持天翼云线下账号。由于天翼云省公司CRM线上账号权限限制，VPC列表始终返回空，因此无法完成网络同步。

{{% /tab %}}


{{% tab name="移动云" %}}
1. 登录移动云控制台，在所有产品中搜索“AK管理”，进入AccessKey管理页面。

    ![](../../images/ecloud.png)

2. 在AccessKey管理页面创建密钥或查看已有密钥的Access key和Secret key。

    ![](../../images/ecloudaccesskey.png)


{{% /tab %}}

{{% tab name="京东云" %}}

1. 登录京东云控制台，鼠标悬停在右上角用户名处，选择下拉菜单 **_"Access Key管理"_** 菜单项，进入Access Key管理页面。

    ![](../../images/jdak.png)

2. 查看已有Access Key信息，或单击 **_"新建"_** 按钮，新建Access Key，单击 **_"查看"_** 按钮，获取Access Key Secret信息。

    ![](../../images/jdaksk.png)

{{% /tab %}}

{{% tab name="ZStack" %}}
用户可在ZStack管理平台的[平台管理-Access Key]页面中生成新的Access Key信息或使用已有的Access Key。
{{% /tab %}}


{{% tab name="阿里云飞天私有云(Apsara)" %}}

只有运营管理员和一级组织管理员可以获取组织AccessKey。

1. 管理员登录ASCM控制台。
2. 在页面顶部菜单栏上，单击 **_"企业"_** 。
3. 在 **_"企业"_** 页面的左侧导航栏中，单击 **_"组织管理"_** 。
4. 在组织结构中，单击要添加的上级组织后面的设置图标。
5. 在弹出的下拉菜单中，选择 **_"获取AccessKey"_** 。
6. 在弹出的对话框中，查看组织Accesskey信息。

### 飞天云获取Endpoint

1. 在地址栏中，输入ASO的访问地址region-id.aso.intranet-domain-id.com，按回车键。
2. 输入正确的用户名及密码，单击 **_"登录"_** ，进入ASO页面。
3. 在页面左侧导航栏中，单击 **_"产品运维管理 > 产品列表 > 天基"_** ，跳转到天基控制台页面。
4. 在天基控制台左侧导航栏中选择 **_"报表"_** 。
5. 在 **_"全部报表"_** 页面搜索 **_"服务注册变量"_** 。单击 **_"服务注册变量"_** 。
6. 在服务注册变量页面，单击Service旁边的图标，搜索对应产品服务。
7. 在服务的Service Registration列中，单击鼠标右键，选择 **_"选择更多"_** 。
8. 在 **_"详情"_** 页面查看产品服务的Endpoint地址。

{{% /tab %}}


{{% tab name="Cloudpods" %}}

### Cloudpods获取AccessKey

1. 登录Cloudpods平台，鼠标悬停在右上角用户名处，选择下拉菜单 **_"访问凭证"_** 菜单项，进入访问凭证页面。

    <img src= "../../images/cloudpodsaksk.png" width="400" alt="aksk">

2. 在AccessKey管理页面中单击 **_"新建"_** 按钮，新建Accesskey。

    ![](../../images/cloudpodsaddaksk.png)

3. 已有AccessKey，则对应的ID、Client Secret即对应的密钥ID和密码信息。

    ![](../../images/cloudpodsaksklist.png)


{{% /tab %}}


{{< /tabs >}}


