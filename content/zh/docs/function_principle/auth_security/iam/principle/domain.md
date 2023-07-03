---
title: "域（租户）"
date: 2019-08-04T20:51:23+08:00
weight: 2
description: >
  介绍域或者租户的概念
---

为了实现多租户的效果，认证服务提供了域的概念，一个域下有一个完整的用户认证体系和资源和权限体系，从而允许一个域管理员能够完全自治地管理本域的用户、组、项目、角色和权限策略。

## 域属性

| 字段名称 | 说明     |
|----------|----------|
| id       | ID，只读 |
| name     | 名称     |
| enabled  | 是否启用 |


## 域限制

- 域只有在域内没有项目、角色和策略之后，并且置于enabled=false状态才能够被删除
- default域无法删除
- ldap同步过来的域的如下属性无法修改：name

## 域名字空间

域的名字空间为全局，也就是说域的名字全局唯一

## 预置值

系统初始化后，预置一个default域，作为初始sysadmin账户和system项目所在的域