---
title: "监控代理"
date: 2021-08-05
weight: 20
description: >
  监控代理的工作原理
---

监控代理 是运行在虚拟机上的 telegraf 守护进程，采集监控数据，并把数据传回{{<oem_name>}}的 InfluxDB。

本文介绍三个问题：如何安装监控代理，如何采集监控数据，以及如何传输监控数据。

## 安装监控代理

针对KVM虚拟机，平台支持在创建虚拟机时或关机时自动安装telegraf二进制和服务，安装路径在 /opt/.cloud-monitor/。

针对运行时的KVM虚拟机，以及纳管的虚拟机，{{<oem_name>}} 使用 ansible 将 Agent 安装到虚拟机上。 为此，我们需要保证 ansible 控制服务能够 ssh 登录虚拟机

![host_install](../images/20210805163249.png)

### SSH免密登录虚拟机

{{<oem_name>}}已经能够连接到 VPC 内部的虚拟机，比如说通过 NAT网关或者虚拟机已经绑定了 EIP 等。

![connect_direct](../images/20210805163416.png)

#### 直接免密登录

如果虚拟机是通过{{<oem_name>}}平台创建出来的，那么{{<oem_name>}}是可以直接免密登录到虚拟机，
它是通过在虚拟机上自动创建一个可以通过公钥登录的 cloudroot 用户而实现的，对应的
私钥存储在{{<oem_name>}}的本地数据库。

#### 用户协助配置免密登录

如果虚拟机并非通过{{<oem_name>}}平台创建出来的，那么就需要用户协助配置免密登录了。

用户需要在前端相关界面输入虚拟机的用户名和密钥/密码，以使{{<oem_name>}}能够暂时登录到
目标虚拟机，然后借助 Ansible 在目标虚拟机上创建 cloudroot 用户并配置公钥登录。

![set_root](../images/20210805164138.png)

同理，其实也可以直接让用户在虚拟机上执行脚本，以达到创建 cloudroot 用户以及配置
公钥登录的目的。

![exec_script](../images/20210805164239.png)

### ansible服务访问虚拟机

{{<oem_name>}}的ansible服务一般不能直接访问云平台内的虚拟机。比如公有云 VPC 内部且没有配置
NAT 以及 EIP 的虚拟机。对于此种情况，我们使用 SSH 代理，具体来说是 Local Port 
Forwarding。

#### SSH Local Port Forwarding 

![question1](../images/20210805165213.png)

假设网络 A 和网络 B 是两个隔离的网络，如果想让 VMA 能够访问 VMB 上监听在 80 端口
的 web 服务应该怎么办呢？

在 proxyA 上执行

```bash
ssh –NfL 10.127.30.251:12345:172.31.25.194:80  cloudroot@140.179.54.109
```


上面的命令会在 proxyA 和 proxyB 之间建立 SSH隧道，并在 proxyA 上创建一个 port forwarding，
它将监听`10.127.30.251:12345`，一旦有请求发来，就会通过 SSH 隧道转发到 proxyB，
proxyB 会把请求转发到`172.31.25.194:80`

![answer1](../images/20210805165029.png)

然后 VMA 只要访问`10.127.30.251:12345`就能够访问 VMB 上的 web 服务。

## 采集监控数据

监控数据存储在 InfluxDB 服务中，所以采集数据的 Agent 优先选择了 Telegraf，在其基础上修改了一些代码并定制了配置文件以满足{{<oem_name>}}采集数据的要求。

配置主要描述了需要什么样的监控数据，数据的标签以及数据存储的地址。

## 上报监控数据

Telegraf 可以通过以下几种方式向influxdb上报数据

### 直接上报

如果虚拟机可以直接连接到{{<oem_name>}}中的 InfluxDB，那么数据就可以直接上报。一般KVM虚拟机，裸金属都适用这个场景。

如果是KVM虚拟机，可以向虚拟机所在宿主机本地的metadata服务接口上报监控数据，上报地址为：http://169.254.169.254/monitor 

通过向metadata上报数据，就不要求云平台的 InfluxdDB 必须要被虚拟机网络访问。

### SSH Remote Port Forwarding

如果主机无法直接访问influxdb，则需要设置ssh代理服务，通过SSH Remote Port Forwarding 建立从虚拟机到Influxdb的通信通道。

![question2](../images/20210805165957.png)

网络 A 和网络 B 是两个隔离的网络，proxyB 具有公网 IP，所以 proxyA 可以访问到 proxyB，
如何让 VMB 访问 DB？

在 proxyA 上执行:
```bash
ssh –NfR 172.31.25.194:12345:10.127.40.251:30086  cloudroot@140.179.54.109
```

上面的命令会在 proxyA 和 proxyB 之间建立 SSH 隧道，并在 proxyB 上创建一个 port 
forwarding，它将监听`172.31.25.194:12345`，一旦有请求发来，就会通过 SSH 隧道转
发到 proxyA，proxyA 会把请求转发到`10.172.40.251:80`

![answer2](../images/20210805170059.png)

通过上面的方式，网络B 内部的 VMB 只要访问`172.31.25.194:12345`就可以访问到 DB。

总结来说，Local Port Forwarding 和 Remote Port Forwarding 的区别在于，Port 
Forwarding 建立的位置对于执行命令的一方来说是 Local 还是 Remote。

### 传输数据

在 proxy 和 proxyVM 之间建立 SSH 隧道，并在 proxy 执行命令以在 proxyVM 上建立 
port fowarding，对 proxy 来说就是 remote port forwarding。

VPC 内部的虚拟机就可以通过访问 proxyVM 的 port，访问{{<oem_name>}}的 DB 以把数据传输
回来。


![tarnsfer](../images/20210805170450.png)

## 总结

总结来说，对于大多数情况，{{<oem_name>}}通过 SSH 代理连接到目标虚拟机，借助 Ansible 将
监控 Agent 安装到目标虚拟机上，并做好 Agent 的配置，而监控数据数据也将通过 SSH 
代理传回到{{<oem_name>}}中的 InfluxDB 中。

![summarize](../images/20210805170928.png)

