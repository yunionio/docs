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

## 界面操作

该功能用于通过过VNC远程终端或Web SSH远程连接到虚拟机。
{{% alert title="注意" color="warning" %}}
- Windows操作系统的虚拟机只支持通过VNC远程终端；
- 在{{<oem_name>}}平台经典网络的虚拟机可以直接使用Web SSH和VNC远程终端；{{<oem_name>}}平台VPC网络的虚拟机可以直接使用Web SSH和VNC远程终端，也可以绑定EIP后使用EIP的Web SSH。请注意，未绑定EIP的VPC网络的虚拟机只能通过平台的Web SSH连接，无法使用SSH工具进行连接，如需使用SSH工具连接虚拟机，请为虚拟机绑定EIP。
- VNC长时间连接黑屏后，按空格键会恢复显示。
{{% /alert %}}

1. 在虚拟机页面，单击虚拟机右侧操作列操作列 **_"远程终端"_** 按钮，选择 **_"VNC远程终端"_** 菜单项，新建Web Console名称的浏览器标签页。
    - 发送远程命令：单击 **_"发送远程命令"_** 按钮，选择下拉菜单 **_"Ctrl-Alt-F1~F6"_** 菜单项，向虚拟机控制台发送具体的命令。
    - Ctrl-Alt-Delete：单击\ **_Ctrl-Alt-Delete_** 按钮，若虚拟机为Windows系统，则向虚拟机控制台发送Ctrl-Alt-Delete命令，若虚拟机为Linux系统，则将弹出重启服务器提示，单击 **_"确定"_** 按钮后将重启虚拟机。
    - 发送文字：单击 **_发送文字_** 按钮，在弹出的发送文字对话框中输入需要发送的内容，单击 **_"确定"_** 按钮，向虚拟机控制台发送文字，如发送内容为登录密码，在发送文字后，需要键入回车键确认登录。
2. 单击 **_"远程终端"_** 按钮，选择 **_"SSH IP地址"_** 菜单项，与虚拟机建立web SSH连接。
3. 单击 **_远程终端_** 按钮，选择 **_"SSH IP地址:任意端口"_** 菜单项，在弹出的对话框中设置端口号，单击 **_"确定"_** 按钮，与虚拟机建立web SSH连接。

## Climc

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
