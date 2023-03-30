---
title: "OIDC认证"
weight: 4
edition: ee
description: >
  介绍云平台OIDC认证对接
---

## 基本原理

OIDC为标准的SSO认证协议，协议标准参见：[https://openid.net/specs/openid-connect-basic-1_0.html](https://openid.net/specs/openid-connect-basic-1_0.html)。

OIDC主要定义了用户浏览器，认证提供方（IDP）和服务提供方（SP）之间基于web/http交换的标准接口协议，实现用户基于浏览器，以IDP为统一登录入口，实现用户以在IDP注册的身份实现对SP提供的内容的认证访问。

OIDC定义的用户认证登录流程如下图所示，该流程从未登录的用户浏览器访问SP内容开始，以用户浏览器登录并获得请求的内容结束。

![](../images/oidc.png)

## 接口定义

该流程中，IDP和SP需要提供如下接口：

| 接口       | 提供者 | 访问者    | 实现功能  |
|-------------|----------------|-----------|------------|
| Auth接口       | IDP             | 用户浏览器        | 用户浏览器携带SP的redirect_uri, client_id等信息访问IDP的auth URL，开始用户在IDP的认证流程         |
| Redirect接口        | SP             | 用户浏览器       | 用户浏览器在IDP完成认证后，被IDP重定向到SP的Redirect接口，通过该接口，浏览器将从IDP获得的临时token提交给SP        |
| Token接口        | IDP          | SP后端     | SP后端获得用户浏览器从IDP携带的token后，调用IDP的token接口，获得访问userinfo的AccessToken         | 
| Userinfo接口        | IDP          | SP后端        | SP后端获得AccessToken后，调用IDP的userinfo接口，获得登录用户的认证信息，包括用户ID，名称等         |
| Logout接口        | IDP             | 用户浏览器        | 用户在SP页面登出时，重定向到IDP的logout页面清除用户在IDP的登录session         |

### Auth接口

Auth接口由IDP提供给用户浏览器访问，触发用户在IDP的认证流程。该接口的访问形式如下：

```markdown
GET /authorize?
    response_type=code
    &client_id=s6BhdRkqt3
    &redirect_uri=https%3A%2F%2Fclient.example.org%2Fcb
    &scope=openid%20profile
    &state=af0ifjsldkj HTTP/1.1
  Host: server.example.com
```

该接口的参数含义解释如下：

| 参数       | 含义 |
|-------------|----------------|
| response_type       | 总是为code             |
| client_id        | SP在IDP注册的client_id             |
| redirect_uri        | SP在IDP注册的回调URL，认证成功后，IDP将重定向用户浏览器到该URL          |
| scope        | 认证获取信息的访问，由IDP定义，一般为user profile等          |
| state        | 认证之前的状态信息，例如用户访问的页面URL等             |

### Redirect接口

该接口由SP提供，用户浏览器访问IDP Auth接口并认证成功后，将被重定向到该接口，以想SP通知认证的token。该接口的访问形式如下：

```markdown
GET /cb?
    code=SplxlOBeZQQYbYS6WxSbIA
    &state=af0ifjsldkj
Host: client.example.org
```

该接口的参数含义解释如下：

| 参数       | 含义 |
|-------------|----------------|
| code       | 用户在IDP认证成功后，获得的临时认证code             |
| state        | 用户访问IDP Auth接口时携带的state参数内容，用于SP恢复用户认证前的状态             |

### Token接口

该接口由IDP提供，被SP访问，用于获取访问userinfo的token，该接口的访问形式如下：

```markdown
  POST /token HTTP/1.1
  Host: server.example.com
  Authorization: Basic czZCaGRSa3F0MzpnWDFmQmF0M2JW
  Content-Type: application/x-www-form-urlencoded

  grant_type=authorization_code&code=SplxlOBeZQQYbYS6WxSbIA
    &redirect_uri=https%3A%2F%2Fclient%2Eexample%2Ecom%2Fcb
```

该接口的参数含义解释如下：

| 参数       | 含义 |
|-------------|----------------|
| grant_type       | 总是为authorization_code             |
| code        | 用户浏览器提交给SP的从IDP获得的code             |
| redirect_uri        | SP在IDP注册的回调URL             |

请求该接口需要认证，认证参数为：

```markdown
Authorization: Basic czZCaGRSa3F0MzpnWDFmQmF0M2JW
```

其中，认证信息有SP在IDP注册的client_id和secret编码组成，按如下方式编码：

```markdown
Base64Encode(URLEncode(client_id)+”:”+URLEncode(secret))
```

该接口响应形式如下：

```markdown
  HTTP/1.1 200 OK
  Content-Type: application/json
  Cache-Control: no-cache, no-store
  Pragma: no-cache

  {
   "access_token":"SlAV32hkKG",
   "token_type":"Bearer",
   "expires_in":3600,
   "refresh_token":"tGzv3JOkF0XG5Qx2TlKWIA",
   "id_token":"eyJ0 ... NiJ9.eyJ1c ... I6IjIifX0.DeWt4Qu ... ZXso"
  }
```

各个参数含义解释如下：

| 参数       | 含义 |
|-------------|----------------|
| access_token       | 用户在IDP认证成功后，获得的临时认证code             |
| token_type        | 总是为bear             |
| expires_in       | 改access_token的超时时间             |
| refresh_token        | 刷新access_token的token，没有用             |
| id_token        | 用户信息的JWT token，没有用             |

### Userinfo接口

该接口由IDP提供，向SP提供用户的信息。该接口的访问形式如下：

```markdown
  GET /userinfo HTTP/1.1
  Host: server.example.com
  Authorization: Bearer SlAV32hkKG
```

其中，请求Header的Authorization的Bearer为上一步获得的access_token。

该接口返回数据格式在协议中未定义。在{<oem_name>}}场景中，该接口返回数据为包含用户信息的json，包含字段以及字段含义如下：

|字段名称|	类型|	说明|
|-------------|----------------|----------------|
|data|	object|	用户信息的json object|
|+allow_web_console|	boolean|	是否支持web控制台登录|
|+created_at|	datetime|	用户的创建时间|
|+displayname|	string|	用户的显示名称|
|+domain|	object|	用户所在的域|
|++id|	string|	域id|
|++name|	string|	域的名称|
|+domain_policies|	[string]|	当前用户的域级别权限|
|+email|	string|	用户的邮箱|
|+enable_mfa|	boolean|	是否启用MFA|
|+ enable_quota_check|	Boolean|	是否启用配额|
|+ enabled|	Boolean|	是否启用|
|+failed_auth_count|	Integer|	改用连续认证失败的次数|
|+id|	String|	用户的ID|
|+idps|	Object|	用户关联的外部认证源的用户信息|
|++idp|	String|	认证源名称|
|++idp_dirver|	String|	认证源的类型，如oidc|
|++idp_entity_id|	String|	用户在该认证源对应的用户的外部ID|
|++idp_id|	String|	认证源的ID|
|++template|	String|	认证源的模板|
|+is_local|	String|	该用户是否为本地SQL维护的用户|
|+is_system_account|	Boolean|	该用户是否为系统账号（服务账号）|
|+last_active_at|	datetime|	上次用户登录时间|
|+last_login_ip|	Ipaddr|	上次用户登录IP|
|+last_login_source|	string|	上次用户登录来源|
|+mobile	|String|	手机号|
|+name|	String|	用户名|
|+need_reset_password|	Boolean|	该用户是否需要重置密码|
|+non_default_domain_projects	|Boolean|	是否开启三级权限|
|+projectDomain|	String|	该用户当前所在项目的归属域名称|
|+projectDomainId|	String|	该用户当前所在项目的归属域ID|
|+projectId|	String|	该用户当前所在项目ID|
|+projectName|	String|	该用户当前所在项目名称|
|+project_meta|	Object|	该用户当前所在项目的标签|
|+project_policies|	[string]|	该用户的项目级别权限|
|+projects|	Array|	该用户加入的所有项目的列表|
|++domain|	String|	此项目的归属域|
|++domain_id|	String|	此项目的归属域ID|
|++id|	String|	此项目的ID|
|++name|	String|	此项目的名称|
|++roles|	Object|	该用户在此项目的角色列表|
|+++id|	String|	角色ID|
|+++name|	String|	角色名称|
|++system_capable|	Boolean|	该用户在此项目是否具备系统级别权限|
|++system_policies|	[string]|	该用户在此项目的系统级别权限列表|
|++domain_capable|	Boolean|	该用户在此项目是否具备域级别权限|
|++domain_policies|	[string]|	该用户在此项目的域级别权限列表|
|++project_capable|	Boolean|	该用户在此项目是否具备项目级别权限|
|++project_policies|	[string]|	该用户在此项目的项目级别权限列表|
|+roles|	String|	该用户在当前项目的角色列表|
|+system_policies|	[string]|	该用户的系统级别权限|

### Logout接口

该接口由IDP提供。当用户在SP发起退出时，SP重定向用户浏览器到IDP的logout接口清除用户浏览器在IDP的登录session。具体接口定义于[https://openid.net/specs/openid-connect-rpinitiated-1_0-02.html](https://openid.net/specs/openid-connect-rpinitiated-1_0-02.html)。
该接口可以用GET或POST方法请求，请求路径一般为：

```markdown
GET /api/v1/auth/oidc/logout
```

接口参数：

| 参数       | 含义 |
|-------------|----------------|
| post_logout_redirect_uri       | 用户浏览器在IDP清除session成功后，重定向到指定URI             |
| state        | 状态信息，浏览器重定向到post_logout_redirect_uri是将携带该state             |
| id_token_hint       | 没有用             |
| logout_hint        | 没有用             |
| client_id        | 没有用           |
| ui_locales        | 没有用           |

## 对接步骤

和{{<oem_name>}}OIDC对接一般需要如下步骤：

1. 在{{<oem_name>}}申请OIDC对接的认证信息，主要为client_id和secret。申请位置在用户登入的右上角用户此单的“访问凭证”，选择“OpenID Connect/OAuth2”页签，点击“创建”。输入当前OIDC应用的回调URL。创建成功后，可以在该页签的列表查看所有的OIDC认证信息。其中，和{{<oem_name>}}对接的OIDC的认证接口的信息可以在该页签查看：

![](../images/openid.png)

2. 配置第三方应用使用OIDC认证。如果第三方应用还未实现和OIDC对接的，请参考协议和本文档实现对接。

## 应用举例（Grafana）

Grafana支持以OIDC认证源实现SSO登录，{<oem_name>}}可以作为Grafana的OIDC认证源，Grafana需要做如下配置。

### 配置文件

下面仅列出了认证需要的配置项。其中，Grafana会在认证响应中查找用户的email字段，当且仅当用户email的域名在allowed_domains中，该用户才认为是有效的。allow_sign_up需要为true，这样才会自动会用户新建一个本地用户。

```markdown
[auth.anonymous]
enabled = true
org_role = Viewer
[auth.generic_oauth]
enabled = true
client_id = fcc98ad5a22a4de5831cf806980ffb75
client_secret = SzQyVEtaelZFMkZFbmJOeDRTWmh3Y0JKNFNzTlhtekM=
scopes = user
auth_url = https://www.gzgzyun.com:8888/api/v1/auth/oidc/auth
token_url = https://www.gzgzyun.com:8888/api/v1/auth/oidc/token
api_url = https://www.gzgzyun.com:8888/api/v1/auth/oidc/user
allowed_domains = gzgzyun.com
allow_sign_up = true
role_attribute_path = projectName == 'system' && contains(roles, 'admin') && 'Admin' || 'Editor'
[server]
root_url = https://grafana.gzgzyun.com
domain = grafana.gzgzyun.com
enforce_domain = true
```

### 环境变量

grafana容器启动环境变量：设置这个变量GF_AUTH_GENERIC_OAUTH_TLS_SKIP_VERIFY_INSECURE为true之后，才会忽略验证token时的TLS错误。

```markdown
- name: GF_AUTH_GENERIC_OAUTH_TLS_SKIP_VERIFY_INSECURE
  value: 'true'
```

### 要求

user必须有email的属性
