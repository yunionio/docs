---
title: "免密登录Azure平台"
weight: 200
description: 以Azure为例介绍如何使用 var_oem_name 平台免密登录到Azure平台。
---

下面举例介绍如何从{{<oem_name>}}平台免密登录Azure平台。目前仅Azure全球区支持免密登录。

### 开启免密登录

{{% alert title="说明" %}}
将{{<oem_name>}}平台设置为域名访问，并在全局设置-控制台地址中设置访问域名。非域名访问的平台否则无法作为Azure的External Identies。
{{% /alert %}}

1. 在{{<oem_name>}}平台上添加Azure云账号配置参数时，账号类型选择“全球区”，并勾选“开启免密登录”。

    ![](../../../images/azuresso.png)

2. 云账号创建成功后，获取云账号的ID。

    ![](../../../images/azureaccountid.png)

3. 在浏览器中输入“https://<域名>/api/saml/idp/metadata/<账号ID>”，将显示的XML文件内容保存。例如：“[https://saml.test.cn/api/saml/idp/metadata/7c6c10d5-953a-444c-8685-d0b8f53984b2](#azure配置external-identies)”，并保存该文件。

    ![](../../../images/azurexml.png)

### Azure配置External Identies

1. 在[Azure](https://portal.azure.com/)控制台，搜索“external identies”并进入该页面。

    ![](../../../images/externalidenties.png)

2. 单击左侧菜单项“All identity providers”，进入“All identity providers”页面.

    ![](../../../images/createexternalidenties.png)
    
3. 单击“New SAML/WS-Fed Idp”，在弹出的对话框中配置以下参数。
    - Identity provider protocol：选择SAML。
    - Domain name of federating IdP：设置为平台的域名，例如saml.test.cn。
    - Select a method for populating metadata：建议选择“Parse metadata file”，并上传上面步骤保存的xml文件，并单击“Parse”，自动填充下面参数。如选择“Input metadata manually”，需要安装上面的截图对应项，分别填入，注意，直接复制的Certificate项有空格，需要将空格完全删除。

    ![](../../../images/newsaml.png)

4. 除此之外，还需要为Azure的应用程序添加用户权限，Azure应用程序具体可参考[获取Tenant ID、Client ID和Client Secret](#获取tenant-id-client-id和client-secret)。
5. 在应用程序详情页面，单击“API permission”，进入API permission页面，确保应用程序有Microsoft Graph下的“User.Invite.ALL”和“User.ReadWrite.All”的权限，若没有该权限，需要单击“add a permission”，添加对应权限。

    ![](../../../images/permission.png)
    ![](../../../images/addpermission.png)
    ![](../../../images/adduserpermission.png)

### 设置Chrome浏览器

当在{{<oem_name>}}平台免密登录Azure平台时，在登录Azure过程中需要携带Cookie回调{{<oem_name>}}平台，Chrome浏览器默认不允许跨网站携带Cookie，所以需要进行以下配置：

1. 在Chrome浏览器地址栏输入“chrome://flags/”，并搜索“SameSite by default cookies”。
2. 禁用“SameSite by default cookies”和“Cookies without SameSite must be secure”。
    ![](../../../images/disablesamesite.png)

3. 重启浏览器使配置生效。

### 添加免密登录用户

1. 在{{<oem_name>}}平台上的 **_"云账号列表-Azure账号-详情-免密登录用户"_** 页面，添加平台上的用户作为免密登录用户。

    ![](../../../images/azuresamluser.png)

2. 单击 **_"新建"_** 按钮，在弹出的新建对话框中选择平台上的用户以及对应的云用户组，单击 **_"确定"_** 按钮。

    ![](../../../images/createazuresamluser.png)

3. 免密登录用户可以在右上角 **_"用户信息-多云统一登录-免密登录"_** 页面，单击**_"免密登录"_** 按钮。

    ![](../../../images/azuressologin1.png)

4. 在弹出的提示信息对话框中，单击 **_"复制且登录"_** 按钮，跳转到Azure平台，输入复制的账户，免密登录Azure平台。

