---
title: "监控代理"
date: 2021-08-05
weight: 20
description: >
  监控代理的工作原理
---

监控 Agent 是运行在虚拟机上的 daemon，采集监控数据，并把数据传回{{<oem_name>}}的 InfluxDB。

由此，可以衍生出三个问题：如何安装 Agent，如何采集数据，以及如何传输监控数据。

## 如何安装 Agent

{{<oem_name>}}使用 Ansible 将 Agent 安装到虚拟机上，为了能够做到这一点，我们需要保证
{{<oem_name>}}能够连接到虚拟机并且能够登录到虚拟机；这里我们先假设{{<oem_name>}}能够过连接到
虚拟机，故而来优先讨论解决登录问题。

![host_install](../../images/20210805163249.png)

### 如何登录虚拟机

假设{{<oem_name>}}已经能够连接到 VPC 内部的虚拟机，比如说通过 NAT网关或者虚拟机已经绑
定了 EIP 等。

![connect_direct](../../images/20210805163416.png)

#### 直接免密登录

如果虚拟机是通过{{<oem_name>}}平台创建出来的，那么{{<oem_name>}}是可以直接免密登录到虚拟机，
它是通过在虚拟机上自动创建一个可以通过公钥登录的 cloudroot 用户而实现的，对应的
私钥存储在{{<oem_name>}}的本地数据库。

#### 用户协助配置免密登录

如果虚拟机并非通过{{<oem_name>}}平台创建出来的，那么就需要用户协助配置免密登录了。

用户需要在前端相关界面输入虚拟机的用户名和密钥/密码，以使{{<oem_name>}}能够暂时登录到
目标虚拟机，然后借助 Ansible 在目标虚拟机上创建 cloudroot 用户并配置公钥登录。

![set_root](../../images/20210805164138.png)

同理，其实也可以直接让用户在虚拟机上执行脚本，以达到创建 cloudroot 用户以及配置
公钥登录的目的。

![exec_script](../../images/20210805164239.png)

### 如何连接虚拟机

{{<oem_name>}}不能直接连接到虚拟机，是一种最广泛的情况。比如公有云 VPC 内部且没有配置
Nat 以及 EIP 的虚拟机。对于此种情况，我们使用 SSH 代理，具体来说是 Local Port 
Forwarding。

#### SSH Local Port Forwarding 

![question1](../../images/20210805165213.png)

假设网络 A 和网络 B 是两个隔离的网络，如果想让 VMA 能够访问 VMB 上监听在 80 端口
的 web 服务应该怎么办呢？

在 proxyA 上执行

```bash
ssh –NfL 10.127.30.251:12345:172.31.25.194:80  cloudroot@140.179.54.109
```


上面的命令会在 proxyA 和 proxyB 之间建立 SSH隧道，并在 proxyA 上创建一个 port forwarding，
它将监听`10.127.30.251:12345`，一旦有请求发来，就会通过 SSH 隧道转发到 proxyB，
proxyB 会把请求转发到`172.31.25.194:80`

![answer1](../../images/20210805165029.png)

然后 VMA 只要访问`10.127.30.251:12345`就能够访问 VMB 上的 web 服务。

## 如何收集数据

我们的监控数据存储在 InfluxDB 中，所以采集数据的 Agent 优先选择了 Telegraf，在其
基础上修改了一些代码并定制了配置文件以满足{{<oem_name>}}采集数据的要求。

配置主要描述了需要什么样的监控数据，数据的标签以及数据存储的地址。

## 如何传输监控数据

最简单的，如果虚拟机可以直接连接到{{<oem_name>}}中的 InfluxDB，那么数据就可以直接传输
回来。

在安装 Agent 的过程中，{{<oem_name>}}回去检测是否可以从虚拟机直接访问 InfluxDB，如何不
可以，就要使用 SSH 代理，具体来说是 Remote Port Forwarding。

### SSH Remote Port Forwarding

![question2](../../images/20210805165957.png)

网络 A 和网络 B 是两个隔离的网络，proxyB 具有公网 IP，所以 proxyA 可以访问到 proxyB，
如何让 VMB 访问 DB？

在 proxyA 上执行:
```bash
ssh –NfR 172.31.25.194:12345:10.127.40.251:30086  cloudroot@140.179.54.109
```

上面的命令会在 proxyA 和 proxyB 之间建立 SSH 隧道，并在 proxyB 上创建一个 port 
forwarding，它将监听`172.31.25.194:12345`，一旦有请求发来，就会通过 SSH 隧道转
发到 proxyA，proxyA 会把请求转发到`10.172.40.251:80`

![answer2](../../images/20210805170059.png)

通过上面的方式，网络B 内部的 VMB 只要访问`172.31.25.194:12345`就可以访问到 DB。

总结来说，Local Port Forwarding 和 Remote Port Forwarding 的区别在于，Port 
Forwarding 建立的位置对于执行命令的一方来说是 Local 还是 Remote。

### 传输数据

在 proxy 和 proxyVM 之间建立 SSH 隧道，并在 proxy 执行命令以在 proxyVM 上建立 
port fowarding，对 proxy 来说就是 remote port forwarding。

VPC 内部的虚拟机就可以通过访问 proxyVM 的 port，访问{{<oem_name>}}的 DB 以把数据传输
回来。


![tarnsfer](../../images/20210805170450.png)

## 总结

总结来说，对于大多数情况，{{<oem_name>}}通过 SSH 代理连接到目标虚拟机，借助 Ansible 将
监控 Agent 安装到目标虚拟机上，并做好 Agent 的配置，而监控数据数据也将通过 SSH 
代理传回到{{<oem_name>}}中的 InfluxDB 中。

![summarize](../../images/20210805170928.png)

