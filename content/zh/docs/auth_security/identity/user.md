---
title: "用户与组"
date: 2019-08-04T20:51:23+08:00
weight: 04
description: >
  介绍Keystone的用户和组
---

## 用户

用户是平台的使用者和操作者，具有如下属性：

属性  | 说明
------|-------------------------------------------------------
id	  | 用户ID
name  | 用户名称，只能为字母和数字
displayname | 显示名称，可以使中文	
mobile	    | 用户手机号
email	    | 用户邮箱地址
description	| 描述	
enabled	    | 是否启用，禁用用户无法认证	
domain_id   | 域ID	
project_domain | 域名称	
is_system_account | 是否为系统账号，如果是系统账号，user-list时无法看到用户，只有指定system属性时才能查看	
enable_mfa  | 是否开web控制台启双因子认证	
allow_web_console | 是否允许登入控制台	


### 用户资源的限制

* 用户只能加入同一个域下的组
* ldap用户的组成员属性无法更改，ldap用户不能加入或者离开ldap组
* sysadmin用户无法删除和修改

### 用户名字空间

用户的名字空间为域，不同域下的用户的名称可以相同，一个域下的用户名称不能冲突。

### 预置用户

系统初始化后，default域有一个预置用户sysadmin，以admin的角色加入system项目，作为系统的root用户。每个服务都有一个预置的用户，例如 regionadmin, meteradmin 等。

## 组

组是用户的集合，目前不支持组的嵌套，组内成员只能是用户。

### 组的限制

* 组内的用户必须和组归属同一个域
* ldap用户的组成员属性无法更改，ldap用户不能加入或者离开ldap组

### 组名字空间

组的名字空间为域，不同域下的组的名称可以相同。
