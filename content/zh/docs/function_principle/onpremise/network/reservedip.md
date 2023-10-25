---
title: "IP预留"
weight: 2000
description: >
  介绍IP地址预留的功能
---

## IP预留池

平台维护了IP预留池，将未被平台分配但被其他系统使用的IP放入IP预留池，防止IP被分配给虚拟机或其他平台管理的资源。

### IP地址占用检测

平台会每隔6小时做一次全局ping检测，把所有经典网络的IP地址进行ping。并且把平台未维护，但是响应ping的IP标记为预留IP，防止被平台分配，避免IP冲突。如果IP被检测在线并预留后，就不会被自动释放了。需要用户手动释放。

在创建主机时，如果确认这个IP没有被使用，并且有可能放到预留IP里，可以在创建的network参数里，加一个reserved: true的参数，这样即使IP被预留了，也会被自动从预留IP池中释放用于分配。

## 预留IP的使用

### 预留IP

预留指定网络里的指定IP地址，并且可以预留自动释放的预留IP，即先预留IP，在指定时间后，自动释放该预留IP。

```bash
climc network-reserve-ip [--duration DURATION] <NETWORK> <NOTES> <IPS> ...
```

### 查看预留IP

```bash
climc reserved-ip-list [--network NETID]
```

### 释放预留IP

```bash
climc network-release-reserved-ip <NETWORK> <IP>
```

