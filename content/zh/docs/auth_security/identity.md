---
title: "认证体系"
date: 2019-08-04T20:51:23+08:00
weight: 03
description: >
  介绍Keystone的认证体系概念和操作
---

## 认证源

{{<oem_name>}}支持如下多种认证源

认证源类型 | 说明
-----------+-------
SQL        | 认证数据存储在本地MySQL数据库的认证源，这是内置的默认认证源
LDAP       | LDAP
CAS        | Java CAS Server
OAuth2     | OAuth2认证源
OIDC       | OpenID Connect认证源
SAML       | SAML 2.0认证源


## LDAP认证源

{{<oem_name>}} LDAP认证源支持从LDAP导入用户和组，其中支持Microsoft Active Directory (MSAD) 和OpenLDAP，以及通用的LDAP服务端。

LDAP认证源支持三种模式：

1) 单域模式

将指定LDAP dn_tree下的用户和组导入到指定的一个域下。其中，该模式支持两种导入模板，一种是 msad_one_domain，也就是 MSAD 的导入模板，另外一种是 openldap_one_domain, 也就是OpenLDAP的导入模板。

```bash
climc idp-create-ldap-single-domain --target-domain example_domain --url ldap://192.168.222.102 --suffix 'DC=ipa,DC=example,DC=com' --user 'UID=dcadmin,CN=users,CN=accounts,DC=ipa,DC=example,DC=com' --password <password> --user-tree-dn 'CN=users,CN=accounts,DC=ipa,DC=example,DC=com' --group-tree-dn 'CN=groups,CN=accounts,DC=ipa,DC=example,DC=com' mainLdap openldap_one_domain
```

2) 多域模式

将指定LDAP dn_tree下的每个OU导入为一个新的域，将对应OU下的用户和组分别导入到对应域下。该模式只支持一种模板 msad_multi_domain，也就是只支持 MSAD 的导入(因为只有MSAD支持OU的概念）。

```bash
climc idp-create-ldap-multi-domain --url 'ldap://192.168.222.102' --suffix 'DC=example,DC=com' --user 'dcadmin' --password <password> --domain-tree-dn 'OU=集团公司,DC=example,DC=com' multildap msad_multi_domain
```

3) 自定义模式

完全自定义模式，需要用户指定所有的LDAP参数。这种模式参数比较复杂，只有在以上模式不生效情况下才建议使用。

```bash
climc idp-create-ldap [--no-auto-create-project] [--target-domain TARGET_DOMAIN] [--auto-create-project] [--query-scope {one,sub}] [--user USER] [--password PASSWORD] [--disable-user-on-import] [--domain-tree-dn DOMAIN_TREE_DN] [--domain-filter DOMAIN_FILTER] [--domain-objectclass DOMAIN_OBJECTCLASS] [--domain-id-attribute DOMAIN_ID_ATTRIBUTE] [--domain-name-attribute DOMAIN_NAME_ATTRIBUTE] [--domain-query-scope {one,sub}] [--user-tree-dn USER_TREE_DN] [--user-filter USER_FILTER] [--user-objectclass USER_OBJECTCLASS] [--user-id-attribute USER_ID_ATTRIBUTE] [--user-name-attribute USER_NAME_ATTRIBUTE] [--user-enabled-attribute USER_ENABLED_ATTRIBUTE] [--user-enabled-mask USER_ENABLED_MASK] [--user-enabled-default USER_ENABLED_DEFAULT] [--user-enabled-invert] [--user-additional-attribute USER_ADDITIONAL_ATTRIBUTE] [--user-query-scope {one,sub}] [--group-tree-dn GROUP_TREE_DN] [--group-filter GROUP_FILTER] [--group-objectclass GROUP_OBJECTCLASS] [--group-id-attribute GROUP_ID_ATTRIBUTE] [--group-name-attribute GROUP_NAME_ATTRIBUTE] [--group-member-attribute GROUP_MEMBER_ATTRIBUTE] [--group-members-are-ids] [--group-query-scope {one,sub}] <--url URL> <--suffix SUFFIX> <NAME>
```
