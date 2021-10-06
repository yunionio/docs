---
title: "认证源"
date: 2019-08-04T20:51:23+08:00
weight: 02
description: >
  介绍Keystone的认证源
---

认证源定义了用户信息的来源。每个认证源有driver和template两个属性，说明这个认证源的工作机制。目前，driver支持如下多种认证源：


认证源定义了用户的来源，每个认证源有driver和template两个属性，说明这个认证源的工作机制。目前，driver只支持两种：sql和ldap。后续会增加更多认证源，例如openid, saml认证源。

Driver | Template | 说明                                |用户或组归属域 | 导入行为
-------|----------|-------------------------------------|---------------|--------------------
sql	   | -        | 用户和组的定义来自于本地的sql数据库	| 任意多个域	| 不需要导入
ldap   | msad_one_domain | 用户和组的定义来自于本地的Microsoft Active Diectoy Domain | 单个域 | 自动导入一个域以及用户和组
ldap   | msad_multi_domain | 用户和组以及域的定义来自于本地的Microsoft Active Directory Domain | 多个域 | 自动导入多个域，一个域对应domain_dn下的一个OU，OU下的用户和组导入对应的域。
ldap   | openldap_one_domain | 用户和组的定义来自于本地openldap或者freeIPA	                   | 单个域	| 自动导入一个域，user_dn和group_dn下的
ldap   | -	                 | 用户和组的定义来自于任意的ldap数据源	                           | 单个或多个域 |
cas    | -        | Java CAS Server                     | 单个域        | 每次用户登录时导入
oauth2 | dingtalk | 钉钉企业认证                        | 单个域        | 每次用户登录时导入 
oauth2 | feishu   | 飞书企业认证                        | 单个域        | 每次用户登录时导入 
oauth2 | wecom    | 企业微信SSO认证                     | 单个域        | 每次用户登录时导入 
oidc   | GitHub   | GitHub SSO                          | 单个域        | 每次用户登录时导入 
oidc   | Azure    | Azure OpenID Connect SSO            | 单个域        | 每次用户登录时导入 
oidc   | dex      | Dex OpenID Connect SSO              | 单个域        | 每次用户登录时导入 
saml   | Azure    | Azure SAML 2.0 SSO                  | 单个域        | 每次用户登录时导入 


## 常用命令

### 查看认证源

```bash
climc idp-list --scope system
```

### 查看认证源的配置

```bash
climc idp-config-show <idp_id>
```

### 编辑认证源的配置

```bash
climc idp-config-edit <idp_id>
```
