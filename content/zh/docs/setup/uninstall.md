---
title: "卸载"
weight: 1001
edition: ce
description: >
  本节介绍如何卸载平台
---

根据平台安装方式，卸载方式各有不同

## All in One 安装

All in One 安装本质是在服务器上安装了一个Kubernets集群，进而在集群中部署了Cloudpods。因此卸载Cloupods只需要卸载安装的Kubernetes集群，以及在服务器上安装的相关rpm即可。

卸载服务器上的Kubernetes服务:

```bash
ocadm reset --force
ipvsadm --clear
kubeadm reset --force
```

停止并禁用相关服务：

```bash
systemctl stop kubelet && systemctl disable kubelet
systemctl stop yunion-executor && systemctl disable yunion-executor
systemctl stop openvswitch && systemctl disable openvswitch
```

进一步地，可以卸载kubelet, yunion-executor, openvswitch等rpm，并清除相关的数据目录：

```bash
rm -fr /etc/kubernetes /var/lib/etcd /opt/yunion /opt/cloud /etc/openvswitch
```

## Kubernetes Helm 安装

使用如下命令卸载：

```bash
helm uninstall -n onecloud  default
```

## Docker Compose 安装

使用如下命令卸载：

```bash
docker compose down
````
