---
title: "虚拟IP（VIP）"
weight: 75
description: >
  介绍如何使用虚拟IP（VIP）
---

{{<oem_name>}}现已支持在VPC内或经典网络的IP子网分配虚拟IP给一组虚拟机共享，通过keepalived等高可用软件实现在VIP这组虚拟机之间的漂移，keepalived检测服务在主机上的状态，自动地将虚拟IP设置在服务可用的优先级最高的虚拟机的网卡上。

## 模型概念

在资源模型上，VIP绑定到一个反亲和组（instancegroup）。可以通过前端，或者climc的命令，为一个反亲和组绑定一个VIP。绑定后，该VIP可以用于在该反亲和组包含的虚拟机之间使用。

同时，VIP通常是为了对外提供服务。对于VPC内的虚拟机，为了允许VPC外能够访问VIP提供的服务，平台允许给VIP绑定EIP。绑定后，VPC外可以通过该EIP访问VIP绑定的服务。

## climc命令

### 为反亲和组绑定一个VIP。

限制：
1. 目前一个反亲和组只能绑定一个VIP。
2. 如果反亲和组没有虚拟机成员，则可以指定待绑定的VIP的IP子网。绑定后，则该反亲和组只能添加该IP子网下的虚拟机。且这些虚拟机只能有一个虚拟网卡。
2. 如果反亲和组已经有虚拟机成员，反亲和组能绑定VIP的前提是反亲和组内的所有虚拟机都加入同一个VPC下的IP子网，并且这些虚拟机都只有一个虚拟网卡。反亲和组绑定的VIP将从这个IP子网内分配。

```bash
climc instancegroup-attachnetwork [--ip-addr IP_ADDR] [--alloc-dir ALLOC_DIR] [--reserved] [--require-designated-ip] [--network-id NETWORK_ID] <instancegroup>
```

### 为VPC内反亲和组绑定EIP

限制：
1. 一个反亲和组只能绑定一个EIP，并且该反亲和组需要已经绑定了VIP之后，才能绑定EIP。绑定后EIP自动映射到对应的VIP。

分为两种情况，一种是自动申请一个EIP，绑定到反亲和组；一种是将已有的EIP绑定到反亲和组。

```bash
climc instancegroup-create-eip [--bandwidth BANDWIDTH] [--bgp-type BGP_TYPE] [--auto-dellocate] [--ip-addr IP_ADDR] [--charge-type CHARGE_TYPE] <instancegroup>
```

```bash
climc instancegroup-associate-eip [--ip-addr IP_ADDR] [--eip-id EIP_ID] <instancegroup>
```

### 为VPC内反亲和组解绑EIP

```bash
climc instancegroup-dissociate-eip <instancegroup>
```

### 为反亲和组解绑VIP

限制：
1. 只有反亲和组没有绑定EIP的前提下，才能解绑该反亲和组的EIP

```bash
climc instancegroup-detachnetwork [--ip-addr IP_ADDR] <ID>
```

### 应用举例

现要部署一套主备的nginx集群，申请两台虚拟机nginx-master和nginx-slave，在同一个IP子网 192.168.4.0/22下，IP分别为192.168.7.247/22和192.168.7.248/22。

创建反亲和组nginx，将nginx-master和nginx-slave加入。

为反亲和组nginx绑定VIP 192.168.7.246/22。

ningx-master配置如下：

```bash
sudo yum install -y nginx keepalived
```

修改/etc/keepalived/keepalived.conf如下：

```
global_defs {
    notification_email {
        notify@example.cn
    }
    notification_email_from sns-lvs@example.cn
    smtp_server smtp.example.cn
    smtp_connection_timeout 30
    router_id nginx_master        # 设置nginx master的id，在一个网络应该是唯一的
}
vrrp_script chk_http_port {
    script "/root/check_httpd.sh"    #最后手动执行下此脚本，以确保此脚本能够正常执行
    interval 2                          #（检测脚本执行的间隔，单位是秒）
    weight 2
}
vrrp_instance VI_1 {
    state MASTER            # 指定keepalived的角色，MASTER为主，BACKUP为备
    interface eth0            # 当前进行vrrp通讯的网络接口卡(当前centos的网卡)
    virtual_router_id 66        # 虚拟路由编号，主从要一直
    priority 100            # 优先级，数值越大，获取处理请求的优先级越高
    advert_int 1            # 检查间隔，默认为1s(vrrp组播周期秒数)
    authentication {
        auth_type PASS
        auth_pass 1111
    }
    track_script {
        chk_http_port            #（调用检测脚本）
    }
    virtual_ipaddress {
        192.168.7.246/22            # 定义虚拟ip(VIP)，可多设，每行一个
    }
}
```

nginx-slave配置如下：

```bash
sudo yum install -y nginx keepalived
```

修改/etc/keepalived/keepalived.conf如下：

```
global_defs {
    notification_email {
        notify@example.cn
    }
    notification_email_from sns-lvs@example.com
    smtp_server smtp.example.cn
    smtp_connection_timeout 30
    router_id nginx_slave        # 设置nginx master的id，在一个网络应该是唯一的
}
vrrp_script chk_http_port {
    script "/root/check_httpd.sh"    #最后手动执行下此脚本，以确保此脚本能够正常执行
    interval 2                          #（检测脚本执行的间隔，单位是秒）
    weight 2
}
vrrp_instance VI_1 {
    state BACKUP            # 指定keepalived的角色，MASTER为主，BACKUP为备
    interface eth0            # 当前进行vrrp通讯的网络接口卡(当前centos的网卡)
    virtual_router_id 66        # 虚拟路由编号，主从要一直
    priority 99            # 优先级，数值越大，获取处理请求的优先级越高
    advert_int 1            # 检查间隔，默认为1s(vrrp组播周期秒数)
    authentication {
        auth_type PASS
        auth_pass 1111
    }
    track_script {
        chk_http_port            #（调用检测脚本）
    }
    virtual_ipaddress {
        192.168.7.246/22            # 定义虚拟ip(VIP)，可多设，每行一个
    }
}
```

在nginx-master和nginx-slave上的/root/check_httpd.sh内容如下：

```bash
#!/bin/bash
A=`ps -C nginx --no-header |wc -l`        
if [ $A -eq 0 ];then                            
    systemctl restart nginx                #重启nginx
    if [ `ps -C nginx --no-header |wc -l` -eq 0 ];then    #nginx重启失败
        exit 1
    else
        exit 0
    fi
else
    exit 0
fi
```

以上配置完成后，分别在nginx-master和nginx-slave重启nginx和keepavlied服务。

```bash
systemctl restart nginx keepalived
```

此时，可以在nginx-master上通过ip addr查看到eth0增加了附属VIP 192.168.7.246/22。

```bash
[root@nginx-master ~]# ip addr show dev eth0
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1440 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 00:24:b1:6d:9b:7d brd ff:ff:ff:ff:ff:ff
    inet 192.168.7.247/22 brd 192.168.7.255 scope global dynamic eth0
       valid_lft 94550864sec preferred_lft 94550864sec
    inet 192.168.7.246/22 scope global secondary eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::224:b1ff:fe6d:9b7d/64 scope link 
       valid_lft forever preferred_lft forever
```

最后，为反亲和组nginx绑定一个EIP，则可以在VPC外通过该EIP访问nginx集群。
