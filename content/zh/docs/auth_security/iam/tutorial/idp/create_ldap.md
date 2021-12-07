---
title: "新建LDAP认证源"
date: 2021-12-06T15:34:43+08:00
weight: 10
description: >
    新建LDAP认证源，支持Microsoft Active Diretory和OpenLDAP/FreeIPA
---

请确保用户环境中存在LDAP服务器。

1. 在认证源页面，单击列表上方 **_"新建"_** 按钮，进入新建认证源页面。
2. 配置以下参数：
    - 认证源归属：设置认证源的归属范围，当认证源归属于系统时，即系统中所有用户都可以使用该认证源登录平台。当认证源归属于域时，只有该域中的用户可以使用该认证源登录平台。域管理后台下，认证源归属于域管理员所属域。
    - 名称：认证源的名称。
    - 认证协议：选择“LDAP”。
    - 认证类型：支持从Microsoft Active Diretory导入单域、Microsoft Active Diretory导入多个域、OpenLDAP/FreeIPA导入单域。不同认证类型配置参数略有不同。
    - 当认证类型是Microsoft Active Diretory导入单域时：
        - 用户归属目标域：可选项，选择LDAP服务器上用户在云管平台的所属域。
        - 服务器地址：搭建AD域控服务器的URL地址，格式为ldap(s)://服务器IP地址，必须以ldap://或者ldaps://开头。
        - 基本DN：DN即Distinguished Name，基本DN是条目在整个目录树的唯一名称标识。格式为”DC=xx,DC=com“
        - 用户名：连接AD域控服务器的用户名。
        - 密码：连接AD域控服务器的用户对应密码。
        - 用户DN：用户DN为LDAP目录中查找用户的根路径，将会在该根路径下递归查找用户，格式为”CN=users,OU=xx,DC=xx,DC=com“。
        - 组DN：组DN为LDAP目录中查找组的根路径，将会在该根路径下递归查找组，格式”CN=groups,OU=xx,DC=xx,DC=com“。
        - 用户启用状态：设置从认证源导入的用户的状态，当设置为启用时，则用户可以登录本系统，禁用则无法登录系统。 
    - 当认证类型是Microsoft Active Diretory导入多个域时（当认证源归属于域时，不支持设置该项）：
        - 服务器地址、基本DN、用户名、密码同导入单域。
        - 域DN：域对应LDAP中的OU（organization，组织单位），域DN为LDAP查找域的根路径，将会在该路径下查找所有域。格式为”OU=xx,DC=xx,DC=com“.
        - 用户启用状态：设置从认证源导入的用户的状态，当设置为启用时，则用户可以登录本系统，禁用则无法登录系统。
    - 当认证类型是OpenLDAP/FreeIPA导入单域时：
        - 目标域：可选项，选择LDAP服务器上用户在云管平台的所属域。
        - 服务器地址：搭建OpenLDAP或FreeIPA服务器的URL地址，格式为ldap(s)://服务器IP地址，必须以ldap://或者ldaps://开头。
        - 基本DN：DN即Distinguished Name，基本DN是条目在整个目录树的唯一名称标识。格式为”DC=ocdc,DC=com“
        - 用户名：连接服务器的用户UID，格式为”UID=admin,CN=users,CN=xx,DC=xx,DC=com“。
        - 密码：对应用户密码。
        - 用户DN：用户DN为LDAP目录中查找用户的根路径，将会在该根路径下递归查找用户，格式为”CN=users,OU=xx,DC=xx,DC=com“
        - 组DN：组DN为LDAP目录中查找组的根路径，将会在该根路径下递归查找组，格式”CN=groups,OU=xx,DC=xx,DC=com“
        - 用户启用状态：设置从认证源导入的用户的状态，当设置为启用时，则用户可以登录本系统，禁用则无法登录系统。
3. 单击 **_"确定"_** 按钮，新建认证源。
