---
title: "配置认证源"
weight: 3
description: 该章节用于帮助用户配置认证源并支持设置通过第三方应用免密登录到 var_oem_name 平台。
---

认证源将用户导入平台并提供认证登录的功能，支持第三方应用登录到{{<oem_name>}}平台。目前平台支持多种认证协议的认证源：SQL、LDAP、CAS、SAML（通用SAML、Azure AD SAML 2.0）、OIDC（通用OIDC、Github、Azure AD OAuth2）、OAuth2（飞书、钉钉、企业微信）等。

{{% alert title="说明" %}}
若认证源不启用“自动创建用户”，则该认证源仅提供认证登录的功能。当认证源不启用“自动创建用户”，则还需要在**_"用户信息-第三方账号关联"_** 中将本地用户与第三方认证源关联，
{{% /alert %}}

下面以Azure AD SAML 2.0认证源为例，介绍如何配置Azure AD SAML 2.0认证源。如需配置其他认证源，请参考[新建认证源](../../../web_ui/iam/keystone/ldp/#新建认证源)章节。

### Azure平台配置SAML 2.0

只支持Azure全球区的账号。

1. 登录[Azure](https://portal.azure.com)。
2. 在 **_"Azure Active Directory-企业应用程序-所有应用程序"_** 中新建应用程序。

    ![](../../../web_ui/images/system/azuresamlapp.png)

3. 单击 **_"创建你自己的应用程序"_** 后，在弹出的对话框中设置应用名称，选择 **_"集成库中未发现的任何其他应用程序"_** ，单击 **_"创建"_** 按钮。

    ![](../../../web_ui/images/system/azuresamlappcategory.png)

4. 创建成功后进入应用程序详情后，在单一登录页面，选择 **_"SAML"_** 。
    
    ![](../../../web_ui/images/system/azuresamlsetting.png)

5. 在设置SAML单一登录页面配置标识符ID和回复URL，可在{{<oem_name>}}平台的 **_"认证与安全-认证源"_** 页面获取标识符ID和回复URL。

    ![](../../images/quickstart/ldpsaml.png)
    ![](../../../web_ui/images/system/azuresamledit.png)

6. 在Azure Active Directory-概述页面，可以获取到TenantID（租户ID）。

    ![](../../../web_ui/images/system/azuresamlappkey.png) 

### 新建Azure AD SAML 2.0认证源

1. 在{{<oem_name>}}平台上单击左上角![](../../../web_ui/images/intro/nav.png)导航菜单，在弹出的左侧菜单栏中单击 **_"认证与安全/认证体系/认证源"_** 菜单项，进入认证源页面。

    ![](../../images/quickstart/ldp.png)

2. 单击列表上方 **_"新建"_** 按钮，进入新建认证源页面。
3. 配置以下参数：
    - 名称：认证源的名称。
    - 认证协议：选择“SAML”。
    - 认证类型：选择Azure AD SAML2.0。
    - 当认证类型为通用SAML时：
    - 当认证类型为Azure AD SAML2.0时仅需要配置TenantId。TenantId获取方式请参考[Azure平台配置SAML 2.0](#azure平台配置saml-2-0)。
    - 自动创建用户：选择自动创建用户，即通过该认证方式登录平台的用户将会自动在平台创建用户。
    - 用户归属目标域：勾选自动创建用户后才需要设置该参数。即通过该认证方式登录平台的用户的所属域。

    **高级配置**：默认隐藏，可根据需求进行配置。

    - 默认项目：设置通过SAML认证协议的认证源登录并在平台自动创建的用户加入的默认项目。
    - 默认角色：设置通过SAML认证协议的认证源登录并在平台自动创建的用户加入的默认角色。
    ![](../../images/quickstart/createldp.png)
4. 单击 **_"确定"_** 按钮，完成操作。

### 用户登录

1. 配置认证源后，可以通过Azure AD SAML 2.0免密登录到{{<oem_name>}}平台。
2. 在登录页面，设置登录域。

    ![](../../images/quickstart/logindomain.png)
    ![](../../images/quickstart/azurelogin1.png)

3. 在指定域的登录页面，单击第三方登录的图标，跳转到第三方平台进行认证登录。
