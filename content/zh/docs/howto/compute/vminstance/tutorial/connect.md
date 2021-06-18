---
title: "登录虚拟机"
date: 2019-07-19T17:38:36+08:00
weight: 2
---

创建好主机后，登录的方式大概分为以下几种：

- ssh: linux 通用，要求主机网络可达;
- rdp: windows 远程桌面，要求主机网络可达；
- vnc: vnc 链接，对主机网络没有要求，只要能链接云平台 vnc proxy 即可;
- ipmi sol: 只对装有 BMC 的物理机可用;

针对以上的链接方式，我们提供以下接口链接云主机：

### vnc 链接

`climc webconsole-server` 命令提供通过 vnc 的方式链接虚拟机，该方式对裸金属服务器不可用。

```bash
$ climc webconsole-server <server_id>
```

### ssh 链接

查询 server 的 ip

```bash
# 可通过 server-list --search --details 的方式找到主机的 ip
$ climc server-list --search <server_name> --details 

# 或者通过 server-show <server_id> 的方式得到 ip
$ climc server-show <server_name> | grep ip
| ips                  | 10.168.222.226 |
```

查询 server 的登录信息

```bash
$ climc server-logininfo <server_name>
+----------+-----------------------------+
|  Field   |            Value            |
+----------+-----------------------------+
| password | @2aWXB6AmCbV                |
| updated  | 2019-07-03T10:00:20.801716Z |
| username | root                        |
+----------+-----------------------------+
```

ssh 登录

```bash
$ ssh root@10.168.222.226
```

通过 webconsole 登录

```
$ climc webconsole-ssh 10.168.222.226
https://console.yunion.cn/web-console?access_token=y7bjpBwtvJHLHpwOUMzNVvsYiAgY1vskIuVwB-aINfH4mm8MsZqwxKSfHqm2pCvY6O8bBA%3D%3D&api_server=https%3A%2F%2Foffice.yunion.io&protocol=tty
```

在浏览器打开 webconsole 放回的 url ，就会到对应虚拟机的登录界面

![](../images/webssh.png)
