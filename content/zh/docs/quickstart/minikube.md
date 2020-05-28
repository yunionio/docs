---
title: "MiniKube 安装"
linkTitle: "MiniKube 安装"
weight: 1
description: >
  使用MiniKube,快速部署体验单机版本的OneCloud服务
---

## 前提
{{% alert title="注意" color="warning" %}}
本章内容是方便快速体验OneCloud, 通过MiniKube快速搭建OneCloud服务，如果想了解部署的细节或者部署高可用环境请参考: [安装部署](/docs/setup/) 。
{{% /alert %}}

## 环境准备
OneCloud 相关的组件运行在MiniKube之上，环境以及相关的软件依赖如下:
- 操作系统: Centos 7.6
- 最低配置要求: CPU 4核, 内存 8G, 存储 100G
- 数据库: mariadb (CentOS 7自带的版本：Ver 15.1 Distrib 5.5.56-MariaDB）

mysql初始化
```
update mysql.user set authentication_string=password('root') where user='root';
use mysql;
update user set  plugin="mysql_native_password";
flush privileges;
```

```
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
flush privileges;
```

## 开始部署
### 下载并启动minikube
Our recommendation is to always run the latest (*) version of Minikube available for your platform of choice, following their installation instructions.
https://kubernetes.io/docs/tasks/tools/install-minikube/

```bash
minikube config -p onecloud set memory 8192 
minikube start  --nodes 2 -p onecloud
minikube dashboard -p onecloud
```
### 部署local-path-storage
https://github.com/rancher/local-path-provisioner
```bash
wget https://raw.githubusercontent.com/rancher/local-path-provisioner/master/deploy/local-path-storage.yaml -O local-path-storage.yaml 
kubectl apply -f local-path-storage.yaml 
```

### 部署onecloud k8s operator
onecloud k8s operator地址： https://github.com/yunionio/onecloud-operator
```bash
wget https://github.com/yunionio/onecloud-operator/blob/master/manifests/onecloud-operator.yaml -O onecloud-operator.yaml
kubectl apply -f onecloud-operator.yaml
```
### 部署onecloud 集群
```bash
wget https://github.com/yunionio/onecloud-operator/blob/master/manifests/example-onecloud-cluster.yaml -O onecloud-cluster.yaml
vim onecloud-cluster.yaml
```
修改onecloud-cluster.yaml mysql相关配额 增加imageRepository相关配置
```
  imageRepository: "registry.cn-beijing.aliyuncs.com/yunionio"
```

```bash
kubectl apply -f onecloud-cluster.yaml
```
打开K8s Dashboard确认相关服务正常启动完成

### 创建账号登陆webUI
创建账号
```bash
./kubectl exec -n onecloud `./kubectl -n onecloud get pods  | grep "example-onecloud-cluster-climc"| cut -f1 -d" "` -c climc  -i -t -- /bin/bash -il
climc user-create demo --password demo123A --system-account --enabled
```
登陆webUI
```bash
./kubectl -n onecloud port-forward `./kubectl -n onecloud get pods  | grep "example-onecloud-cluster-web"| cut -f1 -d" "` 9999:443
```
打开浏览器：https://localhost:9999 

### 集群清理
```bash
./kubectl delete -f onecloud-cluster.yaml
./kubectl delete -f onecloud-operator.yaml
./kubectl delete -f local-path-storage.yaml
./minikube -p onecloud stop
```
