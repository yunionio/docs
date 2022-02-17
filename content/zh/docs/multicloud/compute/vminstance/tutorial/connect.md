---
title: "登录虚拟机"
date: 2019-07-19T17:38:36+08:00
weight: 30
description: >
  介绍如何连接登录虚拟机。
---

创建好虚拟机后，登录的方式大概分为以下几种：

- ssh: linux 通用，要求虚拟机网络可达;
- rdp: windows 远程桌面，要求虚拟机网络可达；可通过RDP对应的客户端连接Windows操作系统的虚拟机。
- vnc: vnc 链接，对虚拟机网络没有要求，只要能链接云平台 vnc proxy 即可;

## 界面操作

该功能用于通过过VNC远程终端或Web SSH远程连接到虚拟机。
{{% alert title="注意" color="warning" %}}
- AWS、Azure、Google、天翼云、Nutanix不支持VNC远程终端；
- Windows操作系统的虚拟机只支持通过VNC远程终端；
- ZStack、DStack、HCSO、阿里云、AWS、Azure、华为云、腾讯云、UCloud需要虚拟机上存在EIP才可以通过Web SSH远程连接。
- VNC长时间连接黑屏后，按空格键会恢复显示。
{{% /alert %}}

1. 在左侧导航栏，选择 **_"主机/主机/虚拟机"_** 菜单项，进入虚拟机页面。
2. 单击虚拟机右侧操作列操作列 **_"远程终端"_** 按钮，选择 **_"VNC远程终端"_** 菜单项，新建Web Console名称的浏览器标签页。
    - 发送远程命令：单击 **_"发送远程命令"_** 按钮，选择下拉菜单 **_"Ctrl-Alt-F1~F6"_** 菜单项，向虚拟机控制台发送具体的命令。
    - Ctrl-Alt-Delete：单击\ **_Ctrl-Alt-Delete_** 按钮，若虚拟机为Windows系统，则向虚拟机控制台发送Ctrl-Alt-Delete命令，若虚拟机为Linux系统，则将弹出重启服务器提示，单击 **_"确定"_** 按钮后将重启虚拟机。
    - 发送文字：单击 **_发送文字_** 按钮，在弹出的发送文字对话框中输入需要发送的内容，单击 **_"确定"_** 按钮，向虚拟机控制台发送文字，如发送内容为登录密码，在发送文字后，需要键入回车键确认登录。
2. 单击 **_"远程终端"_** 按钮，选择 **_"SSH IP地址"_** 菜单项，与虚拟机建立web SSH连接。
3. 单击 **_远程终端_** 按钮，选择 **_"SSH IP地址:任意端口"_** 菜单项，在弹出的对话框中设置端口号，单击 **_"确定"_** 按钮，与虚拟机建立web SSH连接。

## climc操作

针对以上的链接方式，我们提供以下接口链接云虚拟机：

### vnc 连接

`climc webconsole-server` 命令提供通过 vnc 的方式链接虚拟机，该方式对裸金属服务器不可用。

```bash
$ climc webconsole-server <server_id>
```

### ssh 连接

查询 server 的 ip

```bash
# 可通过 server-list --search --details 的方式找到虚拟机的 ip
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

![](../../images/webssh.png)
