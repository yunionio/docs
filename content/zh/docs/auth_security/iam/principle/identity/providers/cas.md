---
title: "CAS认证源"
date: 2019-08-04T20:51:23+08:00
weight: 04
edition: ee
description: >
  CAS认证源
---

Apereo CAS（Central Authentication Server)是开源的企业级SSO（single sign on）解决方案，其认证流程描述如下。

1. 当用户需要访问需要登录的网站（例如，https://app.example.org），用户在该网站还未被认证，被跳转到CAS认证服务器的SSO登录页: https://cas.example.org/cas/login?service=https://app.example.org，其中service参数告知CAS服务该单点登录的来源网站
2. 用户在CAS服务器的登录页面完成登录，并颁发认证凭证ticket=ST-123456
3. CAS服务器将用户的浏览器重新定位到来源网站：https://app.example.org?ticket=ST-123456，其中query中的ticket参数携带了CAS服务器为此次登录颁发的凭证
4. app.example.org的后端服务器访问CAS服务器的ticket验证接口：https://cas.example.org/cas/serviceValidate?ticket=ST-123456&service=https://app.example.org，其中ticket携带登录凭证，service携带该网站的标示。
5. 如果serviceValidate接口在ticket颁发的12秒内被访问，并且是首次访问，则验证成功，返回该用户的用户名。
6. app.example.org验证ticket成功后，获得用户名，则认为该CAS用户名对应的用户认证成功，则将该用户设置为已登录

keystone集成CAS SSO认证流程如图所示：

<img src="../../../../images/keystone_cas.png">
