---
title: "LDAP认证源"
date: 2019-08-04T20:51:23+08:00
weight: 03
description: >
  LDAP认证源
---

{{<oem_name>}} LDAP认证源支持从LDAP导入用户和组，其中支持Microsoft Active Directory (MSAD) 和OpenLDAP，以及通用的LDAP服务端。

域，用户和组的定义来源于LDAP。不允许添加删除。不可修改字段如下表所示。

资源 | 不可修改字段名称
-----|------------------------------------------------------
域   | name
组   | name, displayname
用户 | name, displayname, enabled, mobile, email, password

ldap认证源的基础配置如下：

配置项     | 说明                                          | 举例
-----------|-----------------------------------------------|------------------------------------------
url	       | 服务器地址，必须以ldap://或者ldaps://开头 | ldap://192.168.222.201:389
suffix	   | LDAP根路径的DN	                                   | DC=ipa,DC=yunionyun,DC=com
user       | 接入LDAP只读账户的用户名，对于AD，是用户名，对于openldap，是用户的DN	| UID=dcadmin,CN=users,CN=accounts,DC=ipa,DC=yunionyun,DC=com
password   | 接入LDAP只读账户的密码                                          | 	

对于导入单域的模板，需要指定user_tree_dn和group_tree_dn两个参数

配置项        | 说明                                           | 举例
--------------|------------------------------------------------|------------------------------------------------- 
user_tree_dn  | 用户查找根路径，将会在该路径下递归查找用户 | CN=users,CN=accounts,DC=ipa,DC=yunionyun,DC=com
group_tree_dn | 组查找跟路径，将会在该路径下递归查找组     | CN=groups,CN=accounts,DC=ipa,DC=yunionyun,DC=com


对于导入多域的模板，需要指定domain_tree_dn

配置项         | 说明                                                 | 举例
---------------|------------------------------------------------------|----------------------------------
domain_tree_dn | 域查找根路径，将会在该路径下的一级子节点中查找域 | OU=集团公司,DC=yuniondc,DC=com


对于非模板的LDAP配置，有如下的配置项：

配置项          | 说明                                                  | msad_one_domain默认值  | msad_multi_domain默认值 | openldap_one_domain默认值
---------------|------------------------------------------------------|------------|----------|----------
query_scope	   | 默认查找范围：tree_dn下的整个substree（sub）还是当前级别（one）  | NA | NA | NA
import_domain  | 是否导入域 | false | true | false
domain_tree_dn | 如果import_domain为true，导入域信息的根路径 | NA | - | NA
domain_filter  | 查找域的过滤器 | NA | - | NA
domain_objectclass | 对应域的对象的class | NA | organizationalUnit | NA
domain_id_attribute	| 域ID对应的属性名 | NA | objectGUID | NA
domain_name_attribute | 域名称对应的属性名   | NA | name | NA
domain_query_scope | 查找域信息的范围：sub或one | NA | one | NA
user_tree_dn          | 导入用户信息的根节点的DN，如果import_domain为true，则该字段无意义   | - | NA | -
user_filter	          | 查找用户的过滤器   | - | - | -
user_objectclass      | 对应用户的对象的class   | organizationalPerson | organizationalPerson | person
user_id_attribute     | 用户ID对应的对象属性名   | sAMAccountName | sAMAccountName | uid
user_name_attribute   | 用户名对应的对象属性名   | sAMAccountName | sAMAccountName | uid
user_enabled_attribute | 用户启用的属性名  | userAccountControl | userAccountControl | nsAccountLock
user_enabled_mask      | 用户启用属性对应的掩码  | 2 (0x10) | 2 (0x10) | 0
user_enabled_default   | 用户启用属性的缺省值  | 512 | 512 | FALSE
user_enabled_invert	   | 用户启用属性是否取反  | true | true | true
user_additional_attribute_mapping | 用户额外属性的映射表 | {"displayName:displayname", "telephoneNumber:mobile", "mail:email" } | {"displayName:displayname", "telephoneNumber:mobile", "mail:email" } | {"displayName:displayname", "mobile:mobile", "mail:email" }
user_query_scope                  | 查找用户信息的范围：sub或one | sub | sub | sub
group_tree_dn                     | 导入组信息的根路径 | - | - | -
group_filter                      | 查找组的过滤器 | - | - | -
group_objectclass                 | 对应组的对象的class | group | group | ipausergroup
group_id_attribute                | 组ID对应的对象属性名 | sAMAccountName | sAMAccountName | cn
group_name_attribute              | 组名对应的对象属性名 | name | name | cn
group_member_attribute            | 组的成员属性对应的对象属性名 | member | member | member
group_members_are_ids             | 租的成员列表包含的是用户ID还是用户名 | false | false | false
group_query_scope                 | 查找组信息的范围：sub或one | sub | sub | sub

### 认证源的同步

对于ldap等可以全量同步的认证源，会定期全量同步域、用户和组信息，同步周期默认15分钟，可以通过参数 default_sync_interval_seoncds 配置。

### 配置命令

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
