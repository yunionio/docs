---
title: "Kubernetes 安装"
linkTitle: "Kubernetes 安装"
weight: 3
description: >
  在已有的 Kubernetes 集群上面部署云管服务
---

## 前提

{{% alert title="注意" color="warning" %}}
通过在已有的 Kubernetes 集群上部署 Cloudpods 云管服务，无法验证内置私有云相关功能(因为内置私有云需要节点上面安装配置 qemu, openvswitch 等各种虚拟化软件)。

目前该部署方法可能会因为不同 Kubernetes 集群的 CSI，CNI 和 Ingress controller 不同，在部署中出现不同的错误，如果部署失败，又想快速体验产品功能，建议还是使用 [All in One 安装](../allinone) 的方式部署。

仅适用于多云管理功能的体验，比如管理 VMware, 公有云(aws, 阿里云, 腾讯云等)或者其它私有云(zstack, openstack 等)。

另外 Kubernetes 集群的版本，目前只支持 v1.15 - v1.20 的版本，高版本的 CRD 定义发生了变化，目前还没有适配。
{{% /alert %}}

## 环境准备

Cloudpods 相关的组件运行在 Kubernetes 之上，环境以及相关的软件依赖如下:

- Kubernetes 集群配置最低要求:
    - CPU 4核, 内存 8G, 节点有存储 100G
    - 版本 v1.15 - v1.20
    - 节点需要能够访问公网
    - 提供 nginx ingress controller
    - 内部 coredns 解析
- 提供 Mysql 数据库

## 部署

### 查看 Kubernetes 环境

以下部署在阿里云的 3 节点 Kubernetes v1.20.11 集群进行，查看节点信息：

```bash
$ kubectl get nodes
NAME                      STATUS   ROLES    AGE   VERSION
cn-shanghai.10.71.69.80   Ready    <none>   20h   v1.20.11-aliyun.1
cn-shanghai.10.71.69.81   Ready    <none>   20h   v1.20.11-aliyun.1
cn-shanghai.10.71.69.82   Ready    <none>   20h   v1.20.11-aliyun.1
```

### 部署 Cloudpods operator

Cloudpods k8s operator地址： https://github.com/yunionio/cloudpods-operator

```bash
# 下载 onecloud-operator 的 yaml 文件
$ wget https://raw.githubusercontent.com/yunionio/onecloud-operator/master/manifests/onecloud-operator.yaml
# 部署 onecloud-operator 到集群
$ kubectl apply -f onecloud-operator.yaml

# 将 kubernetes node 打上 onecloud.yunion.io/controller=enable 标签
# 如果不打标签，operator 服务就不会把对应的后端服务调度到这个节点
# 另外如果没有 master role ，还需要加上标签 node-role.kubernetes.io/master=
# 这个 node 就可以运行 onecloud 相关服务
$ kubectl label nodes cn-shanghai.10.71.69.80 onecloud.yunion.io/controller=enable
$ kubectl label nodes cn-shanghai.10.71.69.80 node-role.kubernetes.io/master=
$ kubectl label nodes cn-shanghai.10.71.69.81 onecloud.yunion.io/controller=enable
$ kubectl label nodes cn-shanghai.10.71.69.81 node-role.kubernetes.io/master=
$ kubectl label nodes cn-shanghai.10.71.69.82 onecloud.yunion.io/controller=enable
$ kubectl label nodes cn-shanghai.10.71.69.82 node-role.kubernetes.io/master=

# 这里需要等待 onecloud-operator 的 pod 状态变为 Running
$ kubectl get pods -n onecloud
NAME                                 READY   STATUS    RESTARTS   AGE
onecloud-operator-7fd65d6489-kwdkr   1/1     Running   0          5m2s
```

### 部署 Cloudpods 服务

```bash
# 下载 onecloud cluster 的 yaml 文件
$ wget https://raw.githubusercontent.com/yunionio/onecloud-operator/master/manifests/example-aliyun-onecloud-cluster.yaml -O onecloud-cluster.yaml
```

修改下载的 onecloud-cluster.yaml 文件内容，主要是修改 spec.mysql 里面内容，比如下面是修改 mysql 对应的 host 为 test.mysql.rds.aliyuncs.com，用户为 db_admin，密码为 test@password；然后修改 spec.loadBalancerEndpoint 为访问集群的外部 ip (根据自己的环境决定，可以写成当前节点的 ip)，这里假设当前节点的 ip 为 10.127.0.2：

```bash
$ vim onecloud-cluster.yaml
```

下面是修改的 diff：

```diff
 spec:
   mysql:
-    host: mysql.rds.aliyuncs.com
-    username: "root"
-    password: "password"
+    host: test.mysql.rds.aliyuncs.com
+    username: "db_admin"
+    password: "teste@password"
   region: "region0"
-  loadBalancerEndpoint: 192.168.121.21
+  loadBalancerEndpoint: 10.127.0.2
   imageRepository: "registry.cn-beijing.aliyuncs.com/yunionio"
   version: v3.8.10
```

还有一些服务的 storageClassName ，可以根据自己环境的 csi storageclass 设置，阿里云默认用的 alicloud-disk-ssd，还有以下的 storageclass 可以选择：

```bash
$ kubectl get storageclass
NAME                       PROVISIONER                       RECLAIMPOLICY   VOLUMEBINDINGMODE      ALLOWVOLUMEEXPANSION   AGE
alibabacloud-cnfs-nas      nasplugin.csi.alibabacloud.com    Delete          Immediate              true                   8d
alicloud-disk-available    diskplugin.csi.alibabacloud.com   Delete          Immediate              true                   8d
alicloud-disk-efficiency   diskplugin.csi.alibabacloud.com   Delete          Immediate              true                   8d
alicloud-disk-essd         diskplugin.csi.alibabacloud.com   Delete          Immediate              true                   8d
alicloud-disk-ssd          diskplugin.csi.alibabacloud.com   Delete          Immediate              true                   8d
alicloud-disk-topology     diskplugin.csi.alibabacloud.com   Delete          WaitForFirstConsumer   true                   8d
```

比如要使用 alicloud-disk-available 的 storageclass，修改 onecloud-cluster.yaml 的 diff 如下：

```diff
   baremetalagent:
     disable: true
     requests:
       storage: 100G
-    storageClassName: alicloud-disk-ssd
+    storageClassName: alicloud-disk-available
   glance:
     requests:
       cpu: 10m
       memory: 10Mi
       storage: 100G
-    storageClassName: alicloud-disk-ssd
+    storageClassName: alicloud-disk-available
   influxdb:
     requests:
       cpu: 10m
       memory: 10Mi
       storage: 100G
-    storageClassName: alicloud-disk-ssd
+    storageClassName: alicloud-disk-available
   meter:
     requests:
       cpu: 10m
       memory: 10Mi
       storage: 25G
-    storageClassName: alicloud-disk-ssd
+    storageClassName: alicloud-disk-available
```

修改完 onecloud-cluster.yaml 的配置后，使用下面的命令部署：

```bash
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
# 因为是在 k8s 上部署的，没有注入一些默认的配置，这个问题现在不好解决
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
onecloud-operator-69bf9fb476-dsw6d                   1/1     Running             0          13m
```

因为阿里云的 k8s 集群开通了 nginx ingress controller 的 ingress 组件，可以查看 ingress 分配的地址：

```bash
$ kubectl get ingress -n onecloud
NAME          CLASS    HOSTS   ADDRESS           PORTS     AGE
default-web   <none>   *       139.196.226.11    80, 443   7d2h
```

然后就可以通过访问 https://139.196.226.11 访问平台前端了，公有云纳管操作请参考：[导入公有云或者其它私有云平台资源](../allinone/#导入公有云或者其它私有云平台资源)。

## 其它问题

### 切换成开源版本

现在默认 k8s 部署的集群是企业版本，可以通过下面的操作切换成开源版本：

```bash
# 查看 onecloud cluster 配置
$ kubectl edit oc -n onecloud default

# 修改 metadata.annotations.onecloud.yunion.io/edition 为 ce
...
    onecloud.yunion.io/edition: ce
...
```

然后对应的企业版本组件就会切换成开源组件，需要注意的是 default-web 的 configmap 和 deployment 需要手动删除下，等待 operator 重建，才能访问前端，操作如下：

```bash
$ kubectl delete configmap -n onecloud default-web
$ kubectl delete deployment -n onecloud default-web
```

### 创建账号登录 Web UI

如果是企业版，前端会提示注册，获取 license ，下面的操作适用与开源版本：

- 创建账号: 部署完成后，需要使用我们的命令行工具 climc 创建帐号

```bash
# 进入 climc 容器
$ kubectl exec -n onecloud `kubectl -n onecloud get pods  | grep "default-climc"| cut -f1 -d" "` -c climc  -i -t -- /bin/bash -il
# 创建用户 demo , 密码为 demo123A 的管理员
$ /opt/yunion/bin/climc user-create demo --password demo123A --enabled
# 将用户 demo 加入 system 项目，并且赋予 admin 权限
$ /opt/yunion/bin/climc project-add-user system demo admin
```
### 待解决的问题

- default-host-deployer pod 无法启动，会处于 ContainerCreating 状态，这个是没有用 ocadm 部署集群导致的。未来会想办法支持该服务在 minikube 的集群里面运行，目前启动不了，不影响体验Cloudpods。[issue #8910](https://github.com/yunionio/onecloud/issues/8910)
