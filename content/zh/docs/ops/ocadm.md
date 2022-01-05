---
title: "Ocadm部署工具常用命令"
date: 2021-11-10T15:43:09+08:00
weight: 40
description: >
    介绍ocadm工具的常用命令，例如切换镜像源、启用/禁用服务、切换开源版/商业版等
---

部署管理工具ocadm类似于Kubernetes集群中的kubeadm工具，下面介绍ocadm的常用命令.

```bash
# 创建集群 
$ ocadm cluster create
```

```bash
# 查看集群认证信息
$ ocadm cluster rcadmin
```

```bash
# 将本地镜像源切换到阿里云镜像源
$ ocadm cluster update --image-repository registry.cn-beijing.aliyuncs.com/yunionio --wait
```

```bash
# 将产品升级或回滚到指定版本，当系统镜像源为阿里云镜像源的情况下才可以使用下面的命令升级
$ ocadm cluster update --version $version 
```

```bash
# 禁用节点的host服务
$ ocadm node disable-host-agent --node $node_name 
```

```bash
# 启用节点的host服务
$ ocadm node enable-host-agent --node $node_name 
```

```bash
# 禁用节点的controller服务
$ ocadm node disable-onecloud-controller --node $node_name 
```

```bash
# 启用节点的controller服务
$ ocadm node enable-onecloud-controller --node $node_name 
```

```bash
# 禁用Baremetal服务
$ ocadm baremetal disable --node $node_name
```

```bash
# 如在node1主机上启用baremetal服务，并监听br0网卡。
$ ocadm baremetal enable --node node1 --listen-interface br0
```

```bash
# 在First Node节点获取加入节点的token信息
$ ocadm token create
```

```bash
# 在First Node查看token信息
$ ocadm token list
```

```bash
# 切换到开源版前端，ce(community edition)为开源版前端；
$ ocadm cluster update --use-ce --wait 
# 切换到商业版前端，ee(enterprise edition)为商业版前端 
$ ocadm cluster update --use-ee --wait
```

```bash
# 启用itsm组件
$ ocadm component enable itsm
# 禁用itsm组件
$ ocadm component disable itsm
# 安装失败时清理环境，请谨慎使用该命令
$ ocadm reset --force
```
