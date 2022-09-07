---
title: "配置云账号"
weight: 1
description: 该章节用于帮助用户配置云账号，纳管云平台。
---

{{<oem_name>}}平台支持纳管以下云平台：

- 公有云：AWS、Azure、Google、阿里云、腾讯云、华为云、天翼云、UCloud；

下面介绍添加Azure和AWS的步骤，如需添加更多云平台，请参考[新建云账号](../../../user/multiplecloud/cloudaccount/cloudaccount/#新建云账号)。

## 配置Azure账号

### 步骤一：获取Azure账号的相关参数

#### 获取Tenant ID、Client ID和Client Secret

1. 登录Azure控制台，单击左侧导航栏 **_"Azure Active Directory/应用注册"_** 菜单项，进入应用注册页面。建议新建一个专门的应用程序供{{<oem_name>}}平台调用Azure API。
    ![](../../../faq/image/azureregisterapp.png)

2. 单击 **_新注册_** 按钮，在进入的注册应用程序页面，设置名称为任意值、设置受支持的账户类型为“仅此目录中的账户”，重定向URI设置为web，并输入以"[https://](https://)"或"[http://localhost](http://localhost)"开头的URL地址，单击 **_"注册"_** 按钮。
    ![](../../../faq/image/azureregisteredapp.png)

3. 创建成功后，系统自动显示刚创建的应用程序详情页面。该页面的应用程序（客户端）ID即为所需的客户端ID、目录（租户）ID即为所需的租户ID。
    ![](../../../faq/image/azureclientid.png)

4. 在应用程序详情页面单击 **_"证书和密码"_** 菜单项。进入证书和密码页面。单击 **_"新客户端密码"_** 按钮。
    ![](../../../faq/image/azureclientsecretlist.png)

5. 在弹出的添加客户端对话框输入密码说明、截止日期为“从不”，单击 **_"添加"_** 按钮新建客户端密码。
    ![](../../../faq/image/azurecreatesecret.png)

6. 保存成功后，页面密码的值即为需要的客户端密码信息。
    ![](../../../faq/image/azureclientsecret.png)

#### 将资源组的权限授权给应用程序

1. 登录Azure控制台，单击左侧导航栏 **_"资源组"_** 菜单项，查看资源组列表，单击需要被授权的资源组名称项，进入资源组管理页面。单击 **_"访问控制(标识和访问管理)"_** 菜单项，进入访问控制页面。
    ![](../../../faq/image/azureresourseapp.png)

2. 在访问控制页面单击 **_添加角色分配_** 按钮，在进入的添加角色分配页面中设置角色为“所有者”，将访问权限分配到对话框为“用户、组或服务主体”、在选择搜索框中搜索上一步骤创建的应用程序的名称，并选中应用程序，单击 **_"保存"_** 按钮。
    ![](../../../faq/image/azureresourserole.png)

3. 在角色分配页面，查看资源组的权限已授权给了应用程序。

    ![](../../../faq/image/azureresourseapprole.png)

#### 将订阅的权限授权给应用程序

1. 登录Azure控制台，单击左侧导航栏 **_"所有服务"_** 菜单项，在所有服务列表中选择并单击 **_"订阅"_** 菜单项，进入订阅列表。
    ![](../../../faq/image/azuresub.png)

2. 单击需要被授权的订阅，进入订阅的详情页面；
    ![](../../../faq/image/azuresublist.png)

3. 单击[访问控制(标识和访问管理)]，在进入的访问控制页面中单击 **_"添加角色分配"_** 按钮，进入添加角色分配页面。
   
    ![](../../../faq/image/azuresubrole.png)

4. 角色为“所有者”，单击 **_"下一步"_** 按钮，将访问权限分配到对话框为“用户、组或服务主体”，单击 **_"选择成员"_** 按钮，在选择搜索框中搜索上一步骤创建的应用程序的名称，并选中应用程序，单击 **_"下一步"_** 按钮，再单击 **_"审阅和分配"_** 按钮。

    ![](../../../faq/image/azure1.png)
    ![](../../../faq/image/azure2.png)
    ![](../../../faq/image/azure3.png)
    ![](../../../faq/image/azure4.png)

5. 在角色分配页面，查看订阅的权限已授权给应用程序。

    ![](../../../faq/image/azure5.png)

#### 应用程序API权限设置

请确保应用程序拥有Azure Active Directory API下的以下权限。

区域 | API权限
---------|----------
 Azure中国 | Directory: Directory.Read.All, Directory.ReadWrite.All</br> Domain: Domain.Read.All
 Azure国际区 | Directory: Directory.Read.All, Directory.ReadWrite.All</br> Domain: Domain.Read.All, Domain.ReadWrite.All; </br>Member:  Member.Read.Hidden; </br>Policy: Policy.Read.All;
 
**查看及设置步骤**

以Azure国内区为例。

1. 在Azure控制台，单击左侧导航栏 **_"Azure Active Directory/应用注册"_** 菜单项，进入应用注册页面。
2. 在新注册的应用程序详情页面，单击 **_"API权限"_** 菜单项，进入API权限页面，查看API权限。

    ![](../../../faq/image/azureapilist.png)

3. 检查应用程序的API权限是否满足上面的要求，如不满足，单击 **_"添加权限"_** 按钮，弹出请求获取API权限对话框。

    ![](../../../faq/image/azurerequestapi1.png)

4. 选择“Microsoft Graph”，应用程序选择“应用程序权限”，并勾选Directory和Domian下的所有权限，单击 **_"添加权限"_** 按钮，完成配置。

    ![](../../../faq/image/azurecreateapi1.png)

#### 获取Azure Enterprise Account (EA)的合约编号和密钥

1. 登录[Azure中国EA Portal](https://ea.azure.cn/)or[Azure EA Portal](https://ea.azure.com/)，登录系统后，左上角数字即为合约编号。
    ![](../../../faq/image/azure_number.png)

2. 单击左侧导航栏 **_"报表"_** 菜单项，选择“下载使用量>API访问密钥”页签，该页面的主密钥即为密钥。
    ![](../../../faq/image/azure_apikey.png) 

### 步骤二：添加Azure账号

1. 在{{<oem_name>}}平台单击左上角![](../../../user/images/intro/nav.png)导航菜单，在弹出的左侧菜单栏中单击 **_"多云管理/云账号/云账号"_** 菜单项，进入云账号页面。

    ![](../../images/quickstart/accountlist.png)

2. 单击列表上方 **_"新建"_** 按钮，进入新建云账号页面。
3. 选择云平台为Azure，单击 **_"下一步：配置云账号"_** 按钮，进入配置云账号页面。
    
    ![](../../images/quickstart/azure.png)

4. 设置以下参数：
    - 名称：Azure账号的名称
    - 账号类型：目前支持对接全球区、中国区、美国政务区、德国区的Azure云账号。
    - 租户（Tenant）ID/客户端ID/客户端密码请参考[获取Tenant ID、Client ID和Client Secret](#获取tenant-id-client-id和client-secret)。
    - 资源归属项目：选择将云账号上的资源同步到{{<oem_name>}}平台的本地项目。如需将云账号上的资源按照云上项目归类，请先指定默认资源归属项目，并勾选自动创建项目。勾选后，将会在{{<oem_name>}}平台创建与云上项目同名的本地项目，并将资源同步到对应项目中。云上没有项目归属的资源将会同步到默认资源归属项目。
    - 代理：当云账号需要代理才可以正常访问时设置该项，留空代表直连。如没有合适的代理，直接单击“新建”超链接，在弹出的新建代理对话框中设置相关参数，创建代理。
    - 开启免密登录：启用该项后，系统成为云上登录的身份提供商。实现通过本系统单点登录到公有云平台。目前仅Azure全球区支持免密登录的功能，此外还需要在Azure平台上配置External Identies，具体请参考[Azure配置External Identies](#azure配置external-identies)。
    - 自动同步：设置是否自动同步Azure平台上的信息，并设置自动同步的时间间隔。
   
    ![](../../images/quickstart/createazure.png)

5. 单击 **_"连接测试"_** 按钮，测试输入的参数是否正确。
6. 单击 **_"确定"_** 按钮，创建Azure云账号，并进入账单文件访问信息页面配置云账号的账单参数以便用户可以在费用中查看云账号的账单信息。
7. EA（Enterprise Agreement）账户支出通过合约编号和密钥获取账单信息，请配置相关参数，配置完成并测试成功后，单击 **_"确定"_** 按钮。
    - 合约编号：在线高级服务协议关联的唯一标识符，V570开头的数字。
    - 密钥：API访问密钥。具体请参考[获取Azure Enterprise Account (EA)的合约编号和密钥](#获取azure-enterprise-account-ea-的合约编号和密钥)。
    - 立即采集账单：{{<oem_name>}}平台默认每天凌晨4点自动采集账单。开启该项后，配置完账单文件访问信息后，将会立即采集账单。
    - 时间范围：当启用立即采集账单后，支持设置时间范围，立即采集时间范围内的账单，请确保在选择的时间范围内有账单数据。建议采集1~6个月内的账单，否则会因为数据太多，造成系统压力多大影响日常采集账单的任务。
   
    ![](../../images/quickstart/azurebill.png)

8. 单击 **_"连接测试"_** 按钮，测试输入的参数是否正确。
9. 非EA账户或无需在{{<oem_name>}}平台上管理账单数据时，可单击 **_"跳过"_** 按钮。

### 步骤三：免密登录Azure

下面介绍如何从{{<oem_name>}}平台免密登录Azure平台。目前仅Azure全球区支持免密登录。

#### 开启免密登录

{{% alert title="说明" %}}
将{{<oem_name>}}平台设置为域名访问，并在全局设置-控制台地址中设置访问域名。非域名访问的平台否则无法作为Azure的External Identies。
{{% /alert %}}

1. 在{{<oem_name>}}平台上添加Azure云账号配置参数时，账号类型选择“全球区”，并勾选“开启免密登录”。

    ![](../../images/quickstart/azuresso.png)

2. 云账号创建成功后，获取云账号的ID。

    ![](../../../user/images/multiplecloud/azureaccountid.png)

3. 在浏览器中输入“https://<域名>/api/saml/idp/metadata/<账号ID>”，将显示的XML文件内容保存。例如：“[https://saml.test.cn/api/saml/idp/metadata/7c6c10d5-953a-444c-8685-d0b8f53984b2](#azure配置external-identies)”，并保存该文件。

    ![](../../../user/images/multiplecloud/azurexml.png)

#### Azure配置External Identies

1. 在[Azure](https://portal.azure.com/)控制台，搜索“external identies”并进入该页面。

    ![](../../../user/images/multiplecloud/externalidenties.png)

2. 单击左侧菜单项“All identity providers”，进入“All identity providers”页面.

    ![](../../../user/images/multiplecloud/createexternalidenties.png)
    
3. 单击“New SAML/WS-Fed Idp”，在弹出的对话框中配置以下参数。
    - Identity provider protocol：选择SAML。
    - Domain name of federating IdP：设置为平台的域名，例如saml.test.cn。
    - Select a method for populating metadata：建议选择“Parse metadata file”，并上传上面步骤保存的xml文件，并单击“Parse”，自动填充下面参数。如选择“Input metadata manually”，需要安装上面的截图对应项，分别填入，注意，直接复制的Certificate项有空格，需要将空格完全删除。

    ![](../../../user/images/multiplecloud/newsaml.png)

4. 除此之外，还需要为Azure的应用程序添加用户权限，Azure应用程序具体可参考[获取Tenant ID、Client ID和Client Secret](#获取tenant-id-client-id和client-secret)。
5. 在应用程序详情页面，单击“API permission”，进入API permission页面，确保应用程序有Microsoft Graph下的“User.Invite.ALL”和“User.ReadWrite.All”的权限，若没有该权限，需要单击“add a permission”，添加对应权限。

    ![](../../../user/images/multiplecloud/permission.png)
    ![](../../../user/images/multiplecloud/addpermission.png)
    ![](../../../user/images/multiplecloud/adduserpermission.png)

#### 设置Chrome浏览器

当在{{<oem_name>}}平台免密登录Azure平台时，在登录Azure过程中需要携带Cookie回调{{<oem_name>}}平台，Chrome浏览器默认不允许跨网站携带Cookie，所以需要进行以下配置：

1. 在Chrome浏览器地址栏输入“chrome://flags/”，并搜索“SameSite by default cookies”。
2. 禁用“SameSite by default cookies”和“Cookies without SameSite must be secure”。
    ![](../../images/quickstart/disablesamesite.png)

3. 重启浏览器使配置生效。

#### 添加免密登录用户

1. 在{{<oem_name>}}平台上的 **_"云账号列表-Azure账号-详情-免密登录用户"_** 页面，添加平台上的用户作为免密登录用户。

    ![](../../images/quickstart/azuresamluser.png)

2. 单击 **_"新建"_** 按钮，在弹出的新建对话框中选择平台上的用户以及对应的云用户组，单击 **_"确定"_** 按钮。

    ![](../../images/quickstart/createazuresamluser.png)

3. 免密登录用户可以在右上角 **_"用户信息-多云统一登录-免密登录"_** 页面，单击**_"免密登录"_** 按钮。

    ![](../../images/quickstart/azuressologin1.png)

4. 在弹出的提示信息对话框中，单击 **_"复制且登录"_** 按钮，跳转到Azure平台，输入复制的账户，免密登录Azure平台。

## 配置AWS账号

### 步骤一：获取AWS账号的相关参数


#### AWS账号权限要求

| 策略名称            | 策略说明                                                     |
| :------------------ | :----------------------------------------------------------- |
| AdministratorAccess | 完全的云资源访问权限，如果拥有此权限，您便拥有了管理所有资源的权限，无需再关注其它策略。 |
| AmazonEC2FullAccess | 如果没有AdministratorAccess策略而又需要管理虚拟机（EC2），请开启该权限。 |

#### 获取AWS的访问密钥

1. 使用AWS主账号（或拥有Administrator Access管理权限的子账号）登录AWS管理控制台，单击 **_"IAM"_** 菜单项，进入IAM控制面板页面。
   ![](../../../faq/image/faq_account_aws_1.png) 

2. 单击左侧菜单栏 **_"用户"_** 菜单项，进入用户管理列表，单击用户名名称项，进入指定用户详情页面。注意需要选择有足够管理权限的用户。
   ![](../../../faq/image/faq_account_aws_2.png)

3. 单击“**安全证书**”页签。
   ![](../../../faq/image/faq_account_aws_3.png)

4. 单击 **_"创建访问密钥"_** 按钮，在弹出的创建访问密钥对话框中即可看到密钥信息，即密钥ID（Access Key ID）、密码（Access Key Secret）。
   ![](../../../faq/image/faq_account_aws_4.png)

{{% alert title="注意" color="warning" %}}
私有访问密钥仅创建时可见，请复制另存，如果不慎丢失，重新创建即可。
{{% /alert %}}

#### 获取S3存储桶URL

**新版**

2019/08/07日期之后创建的AWS账号必须采用该方式配置并获取存储桶的URL和文件前缀。

1. 使用AWS主账号登录AWS管理控制台，单击右上角[用户名]的下拉菜单 **_"我的账单控制面板"_** 菜单项，进入账单和成本管理控制面板页面。
    
    ![](../../../faq/image/awsbilling.png)

2. 单击左侧菜单 **_"Cost & Usage Reoports"_** 菜单项，在AWS成本和使用率报告页面，单击 **_"创建报告"_** 按钮，进入创建报告页面。

    ![](../../../faq/image/awscostreport.png)

3. 配置报告名称、勾选“包括资源ID”，单击 **_"下一步"_** 按钮，进入交付选项页面。

    ![](../../../faq/image/awscreatecostreport.png)

4. 配置S3存储桶，支持选择已有的存储桶或创建新的存储桶。

    ![](../../../faq/image/awscosts3.png)
    ![](../../../faq/image/awscosts3policy.png)

5. 配置报告路径前缀、时间粒度选择“每小时”、报告版本为“创建新报告版本”、压缩类型选择“ZIP”，单击 **_"下一步"_** 按钮，进入审核页面。

    ![](../../../faq/image/awscostreportconfig.png)

6. 确认配置无误后，记录红框中的S3存储桶和报告路径前缀，单击 **_"查看和完成"_** 按钮，完成配置，创建报告。

    ![](../../../faq/image/awscostreportfinish.png)

7. 在AWS控制台的S3存储管理页面中查看对应存储桶中任意账单文件的概述信息，并记录对象URL，存储桶URL即为去掉后面文件名称的URL，如红框所示。

    ![](../../../faq/image/awscosts3bucketurl.png)

8. 文件前缀即为步骤6中红框中的报告路径前缀。

**旧版**

1. 使用AWS主账号登录AWS管理控制台，单击右上角[用户名]的下拉菜单 **_"我的账单控制面板"_** 菜单项，进入账单和成本管理控制面板页面。
    
    ![](../../../faq/image/awsbilling.png)

2. 单击左侧菜单 **_"账单首选项"_** ，在首选项页面的“成本管理首选项”中查看并记录“接收账单报告”的S3存储桶，如未配置，需要勾选“接收账单报告”并配置S3存储桶并验证，设置完成后，将根据设置的粒度将增量账单数据将同步存储到对应的OSS上。建议该bucket中仅存放账单文件。
    
    ![](../../../faq/image/awsbillingbucket.png)
   
3. 在AWS控制台的S3存储管理页面中查看对应存储桶中任意账单文件的概述信息，并记录对象URL，存储桶URL即为去掉后面文件名称的URL，如红框所示。
    
    ![](../../../faq/image/awsbillingbucketurl.png)

4. AWS的文件前缀为AWS账号ID。

{{% alert title="说明" %}}
当账单bucket中除账单文件外还存放了其他文件时，需要配置文件前缀仅获取bucket中的账单文件等。
{{% /alert %}}

### 步骤二：添加AWS云账号

1. 在公有云账号页面单击列表上方 **_"新建"_** 按钮，进入新建云账号页面。
2. 选择云平台为AWS，单击 **_"下一步：配置云账号"_** 按钮，进入配置云账号页面。
2. 设置以下参数：
   - 名称：AWS账号的名称。
   - 账号类型：目前支持对接全球区和中国区的AWS云账号。
   - 密钥ID/密码：对接AWS平台的密钥ID和密码信息。具体请参考[获取AWS访问密钥](#获取aws的访问密钥)。
   - 域：选择云账号所属的域。当云账号私有状态下，域下所有项目用户都可以使用云账号创建资源。
   - 资源归属项目：选择将云账号上的资源同步到{{<oem_name>}}平台的本地项目。如需将云账号上的资源按照云上项目归类，请先指定默认资源归属项目，并勾选自动创建项目。勾选后，将会在{{<oem_name>}}平台创建与云上项目同名的本地项目，并将资源同步到对应项目中。云上没有项目归属的资源将会同步到默认资源归属项目。
   - 代理：当云账号需要代理才可以正常访问时设置该项，留空代表直连。如没有合适的代理，直接单击“新建”超链接，在弹出的新建代理对话框中设置相关参数，创建代理。
   - 开启免密登录：启用该项后，会自动将系统的SAML信息同步到云账号上，并成为云上登录的身份提供商。实现通过本系统单点登录到公有云平台。
   - 自动同步：设置是否自动同步AWS平台上的信息，并设置自动同步的时间间隔。
3. 单击 **_"连接测试"_** 按钮，测试输入的参数是否正确。
4. 单击 **_"确定"_** 按钮，创建AWS账号。并进入账单文件访问信息页面配置云账号的账单参数以便用户可以在费用中查看云账号的账单信息。
5. 如需要在{{<oem_name>}}平台中查看账单信息等，请配置相关参数。
   - 云账号类型：包括主账号和关联账号，使用关联账号之前请确保主账号已导入{{<oem_name>}}平台，并在使用关联账号时选择该主账号。
   - 存储桶URL：账单文件所在存储桶的URL。具体请参考[获取S3存储桶URL](#获取s3存储桶url)。
   - 文件前缀：当账单bucket中除账单文件外还存放了其他文件时，需要配置文件前缀仅获取bucket中的账单文件等。AWS的文件前缀为账号ID。 
   - 立即采集账单：{{<oem_name>}}平台默认每天凌晨4点自动采集账单。开启该项后，配置完账单文件访问信息后，将会立即采集账单。
   - 时间范围：当启用立即采集账单后，支持设置时间范围，立即采集时间范围内的账单，请确保在选择的时间范围内有账单数据。建议采集1~6个月内的账单，否则会因为数据太多，造成系统压力多大影响日常采集账单的任务。
6. 单击 **_"连接测试"_** 按钮，测试输入的参数是否正确。配置完成且测试通过后，单击 **_"确定"_** 按钮。
7. 如不需要在{{<oem_name>}}平台查看云账号账单信息，可直接单击 **_跳过_** 按钮。

### 步骤三：免密登录AWS

下面介绍如何从{{<oem_name>}}平台免密登录AWS平台。

#### 开启免密登录

1. 在{{<oem_name>}}平台上添加AWS云账号配置参数时，勾选“开启免密登录”。

    ![](../../images/quickstart/awssso.png)

#### 添加免密登录用户

1. 在{{<oem_name>}}平台上的 **_"云账号列表-AWS账号-详情-免密登录用户"_** 页面，添加平台上的用户作为免密登录用户。

    ![](../../images/quickstart/awssamluser.png)

2. 单击 **_"新建"_** 按钮，在弹出的新建对话框中选择平台上的用户以及对应的云用户组，单击 **_"确定"_** 按钮。

    ![](../../images/quickstart/createazuresamluser.png)

3. 免密登录用户可以在右上角 **_"用户信息-多云统一登录-免密登录"_** 页面，单击**_"免密登录"_** 按钮。

    ![](../../images/quickstart/awsssologin.png)
