---
title: "白名单设置"
date: 2021-11-29T11:55:20+08:00
weight: 20
description: >
    Redis实例的白名单管理
---

为了保证Redis数据库的安全性，用户可以将访问Redis实例的IP地址和IP地址段添加到对应实例的白名单中，仅在白名单上的IP地址被允许访问Redis实例。不设置白名单默认允许所有IP访问Redis实例。

目前仅阿里云平台的Redis实例支持白名单功能。