---
title: "MiniKube 安装"
linkTitle: "MiniKube 安装"
weight: 1
description: >
  使用 MiniKube, 快速部署体验单机版本的Cloudpods服务
---

## 前提
{{% alert title="注意" color="warning" %}}
本章内容是方便快速体验Cloudpods, 通过 MiniKube 快速搭建Cloudpods服务，无法在生产环境使用，也无法验证云联内置私有云相关功能(因为内置私有云需要节点上面安装配置 qemu, openvswitch 等各种虚拟化软件)。

仅适用于多云管理功能的体验，比如管理 VMware, 公有云(aws, 阿里云, 腾讯云等)或者其它私有云(zstack, openstack 等)。

如果想部署生产可用的环境请参考: [安装部署](/docs/setup/) 。
{{% /alert %}}

## 环境准备

Cloudpods 相关的组件运行在 MiniKube 之上，环境以及相关的软件依赖如下:

- 操作系统: CentOS 7.6
- 最低配置要求: CPU 4核, 内存 8G, 存储 100G

## 部署

### 启动 minikube 集群

下载 minikue/kubectl, 并启动 minikube 集群, 具体请参考： https://kubernetes.io/docs/tasks/tools/install-minikube/

```bash
# 配置 minikube
$ minikube config -p onecloud set memory 8192 

# 启动 kubernetes 集群, 并且从 aliyun 拉取镜像，这样速度会快一点
$ minikube start  -p onecloud --image-repository=registry.aliyuncs.com/google_containers
```
### 部署Cloudpods onecloud operator

Cloudpods k8s operator地址： https://github.com/yunionio/onecloud-operator

```bash
# 下载 onecloud-operator 的 yaml 文件
$ wget https://raw.githubusercontent.com/yunionio/onecloud-operator/master/manifests/onecloud-operator.yaml
# 部署 onecloud-operator 到集群
$ kubectl apply -f onecloud-operator.yaml

# 将 kubernetes node 打上 onecloud.yunion.io/controller=enable 标签
# 如果不打标签，operator 服务就不会把对应的后端服务调度到这个节点
$ kubectl get nodes
NAME       STATUS   ROLES    AGE   VERSION
onecloud   Ready    master   20m   v1.15.9-beta.0
# 加上标签，这个 node 就可以运行 onecloud 相关服务
$ kubectl label nodes onecloud onecloud.yunion.io/controller=enable

# 这里需要等待 onecloud-operator 的 pod 状态变为 Running
$ kubectl get pods -n onecloud
NAME                                 READY   STATUS    RESTARTS   AGE
onecloud-operator-7fd65d6489-kwdkr   1/1     Running   0          5m2s
```

### 部署Cloudpods服务

```bash
# 下载 onecloud cluster 的 yaml 文件
$ wget https://raw.githubusercontent.com/yunionio/onecloud-operator/master/manifests/example-onecloud-cluster.yaml -O onecloud-cluster.yaml

# 部署Cloudpods服务
# 将 onecloud-cluster.yaml 部署到 kubernetes 集群
$ kubectl apply -f onecloud-cluster.yaml

# 等待 onecloud 相关服务启动，这个过程会拉取各个服务的镜像，配置服务
# 需要等待几分钟让所有服务状态变为 Running
# 可以多次使用下面的命令查看 pods 状态
$ kubectl get pods -n onecloud
NAME                                                 READY   STATUS              RESTARTS   AGE
default-ansibleserver-6955fb8d66-gb8w7               1/1     Running             0          8m57s
default-apigateway-57f78c9cfb-8xvgw                  1/1     Running             0          8m54s
default-autoupdate-5f8bf779dd-6drtb                  1/1     Running             0          8m41s
default-climc-6c49f88df9-s4f5g                       1/1     Running             0          8m45s
default-cloudevent-6775bf8d66-bppcv                  1/1     Running             0          8m39s
default-cloudid-7798948bc8-blkxw                     1/1     Running             0          8m30s
default-cloudnet-55fd8ff98b-2gnm4                    1/1     Running             0          8m36s
default-devtool-7db6b87cf9-bvxsm                     1/1     Running             0          8m32s
default-esxi-agent-bb555858c-ft6dz                   1/1     Running             0          8m50s
default-etcd-dvfcg6jfjp                              1/1     Running             0          11m
default-glance-86d99c66-7v4lg                        1/1     Running             0          9m1s
# 这里注意下，如果 host-deployer 一直为 ContainerCreating 的状态，可以先忽略，不影响使用
# 因为是 minikube 部署的，没有注入一些默认的配置，这个问题以后会解决
default-host-deployer-vmkxm                          0/1     ContainerCreating   0          8m17s
default-influxdb-69dcbdb4c-l4lp9                     1/1     Running             0          8m44s
default-keystone-78f45cc8db-xstk2                    1/1     Running             0          9m48s
default-logger-5576dbc7f4-8mdl4                      1/1     Running             0          8m35s
default-monitor-64d9c65b7b-4wf8t                     1/1     Running             0          8m33s
default-notify-59cc65d479-hccs8                      11/11   Running             0          8m38s
default-onecloud-service-operator-584989c746-8ndvf   2/2     Running             0          8m31s
default-ovn-north-866c9fbc6f-87wkg                   1/1     Running             0          8m49s
default-region-5bc599845-nb882                       1/1     Running             0          9m36s
default-region-dns-hdj5k                             1/1     Running             0          8m55s
default-s3gateway-69b9c5b56c-hb64l                   1/1     Running             0          8m32s
default-scheduler-57c66964b7-qh9f2                   1/1     Running             0          9m1s
default-telegraf-f7rvx                               2/2     Running             0          8m27s
default-vpcagent-8ff58c47d-5b4j8                     1/1     Running             0          8m41s
default-web-79df8f97b9-c6lgm                         1/1     Running             0          8m52s
default-webconsole-79cc5cfb9-xd9tk                   1/1     Running             0          8m36s
default-yunionconf-5f79b9655f-trmls                  1/1     Running             0          8m37s
mysql-7d4f67979b-8gl4g                               1/1     Running             0          11m
onecloud-operator-69bf9fb476-dsw6d                   1/1     Running             0          13m
```

也可打开 kubernetes dashboard 确认相关服务正常启动完成。

```bash
# 启用 kubernetes dashboard
$ minikube dashboard -p onecloud
```

### 创建账号登录 Web UI

- 创建账号: 部署完成后，需要使用我们的命令行工具 climc 创建帐号

```bash
# 进入 climc 容器
$ kubectl exec -n onecloud `kubectl -n onecloud get pods  | grep "default-climc"| cut -f1 -d" "` -c climc  -i -t -- /bin/bash -il
# 创建用户 demo , 密码为 demo123A 的管理员
$ /opt/yunion/bin/climc user-create demo --password demo123A --enabled
# 将用户 demo 加入 system 项目，并且赋予 admin 权限
$ /opt/yunion/bin/climc project-add-user system demo admin
```

- 登陆 web 前端 UI 界面

```bash
# 使用 kubectl port-forward 将 web 前端 forward 到本地 9999 端口
$ kubectl -n onecloud port-forward `kubectl -n onecloud get pods | grep "default-web-" | cut -f1 -d" "` 9999:443 --address=0.0.0.0
```
打开浏览器：https://localhost:9999 

## 集群清理

```bash
# 删除所有 onecloud 服务
$ kubectl delete -f onecloud-cluster.yaml
$ kubectl delete -f onecloud-operator.yaml
# stop kubernetes 集群，以后还可以用 minikube start 开启
$ minikube -p onecloud stop

# 以下命令删除整个 minikube 创建的 kubernetes 集群
$ minikube -p onecloud delete
```

## 待解决的问题

- default-host-deployer pod 无法启动，会处于 ContainerCreating 状态，这个是没有用 ocadm 部署集群导致的。未来会想办法支持该服务在 minikube 的集群里面运行，目前启动不了，不影响体验Cloudpods。[issue #8910](https://github.com/yunionio/onecloud/issues/8910)
