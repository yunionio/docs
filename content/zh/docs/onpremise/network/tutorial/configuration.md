---
title: "网络配置"
weight: 100
description: >
  介绍如何DNS, NTP等网络参数配置
---

本节介绍私有云虚拟机的网络设置，包括DHCP，DNS，NTP等设置。

## DHCP

虚拟机默认开启DHCP，通过DHCP获取IP地址，静态路由，域名，NTP等设置。物理机则默认是通过静态写入配置文件方式获取这些配置。

## DNS配置

全局主机DNS server需要在两个地方配置：

1. region配置

climc service-config-edit region2

修改配置：dns_server

2. endpoint配置

首先注册dns服务

```bash
climc service-create dns dns
```

其次注册DNS服务的地址，可以注册多个。每个对应一条endpoint记录。

```bash
climc endpoint-create dns region0 public <dns_ip>
```

针对每个IP子网，可以修改这个IP子网的guest_dns配置，可以设置多个，以逗号分隔。

## NTP配置

从v3.8开始，支持通过平台配置虚拟机的NTP服务器，并通过DHCP自动下发到虚拟机。

通过注册ntp的endpoint来配置平台的NTP服务器信息。

首先注册ntp服务

```bash
climc service-create ntp ntp
```

其次注册NTP服务的地址，可以注册多个。每个对应一条endpoint记录。

```bash
climc endpoint-create ntp region0 public <dns_ip>
```

针对每个IP子网，可以修改这个IP子网的guest_ntp配置，可以设置多个，以逗号分隔。
