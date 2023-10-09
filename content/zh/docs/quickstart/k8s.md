---
title: "Kubernetes Helm 安装"
linkTitle: "Kubernetes Helm 安装"
weight: 3
description: >
  使用 [Helm](https://helm.sh/) 在 Kubernetes 上部署 Cloudpods CMP 多云管理版本
---

## 前提

{{% alert title="注意" color="warning" %}}
该方案通过 Helm 在已有的 Kubernetes 集群上自动部署 Cloudpods 多云管理版本。

该部署方法可能会因为不同 Kubernetes 发行版的 CSI，CNI 和 Ingress controller 配置不同出现兼容性错误，如果部署失败，又想快速体验产品功能，建议还是使用 [All in One 安装](../allinone) 的方式部署。

已经验证过的Kubernetes发行版本包括：
- 阿里云 ACK
- 腾讯云 TKE
- Azure AKS
- AWS ECS

该部署方法仅适用于多云管理功能的使用，比如管理公有云(aws, 阿里云, 腾讯云等)或者其它私有云(zstack, openstack 等)，无法使用内置私有云相关功能(因为内置私有云需要节点上面安装配置 qemu, openvswitch 等各种虚拟化软件)
{{% /alert %}}

## 环境准备

Cloudpods 相关的组件运行在 Kubernetes 之上，环境以及相关的软件依赖如下:

- Kubernetes 集群配置要求:
    - Kubernetes 版本: 1.15 ~ 1.24
    - 系统配置：至少 CPU 4核, 内存 8G, 节点存储 100G
    - 节点需要能够访问公网
    - 提供 ingress controller
    - 内部 coredns 解析
    - 支持 Helm，安装 helm 工具请参考 https://helm.sh/docs/intro/install/
- 提供 Mysql 数据库(可选): 可以选择使用连接的数据库是在部署在 Kubernetes 集群内还是使用外部的，生产环境建议使用外部单独管理的 Mysql (如果公有云RDS服务)

## 部署

### clone chart

Cloudpods Helm Chart 位于 https://github.com/yunionio/ocboot 仓库，使用以下命令下载到本地：

```bash
$ git clone https://github.com/yunionio/ocboot
$ cd charts/cloudpods
```

{{% alert title="注意" color="warning" %}}
接下来会使用 helm 安装 cloudpods chart，在使用 `helm install` 的时候必须指定 `--namespace onecloud`，不能使用其他的 namespace。

原因是 operator 服务还不支持把平台的服务部署到其他 namespace ，这个后续会改进。
{{% /alert %}}

### 测试环境安装

测试环境安装方法如下，该方法会在 Kubernetes 集群里部署 mysql ，local-path-provisioner CSI 依赖插件，不需要连接集群之外的 mysql 。

```bash
# 注意这里的 `--namespace onecloud` 不能改成其他的，必须是 onecloud
$ helm install --name-template default --namespace onecloud --debug  . -f values-dev.yaml  --create-namespace
```

### 生产环境安装

之前部署的方法仅限测试使用，因为依赖少，安装快，但如果用于生产环境，请根据需求修改 ./values-prod.yaml 里面的参数，然后使用该文件创建 Helm Release 。

建议需要修改的地方如下：

```diff
--- a/charts/cloudpods/values-prod.yaml
+++ b/charts/cloudpods/values-prod.yaml
 localPathCSI:
+  # 根据 k8s 集群的 CSI 部署情况，选择是否要部署默认的 local-path CSI
+  # 如果 k8s 集群已经有稳定的 CSI ，就可以设置这个值为 false ，不部署该组件
   enabled: true
   helperPod:
     image: registry.cn-beijing.aliyuncs.com/yunionio/busybox:1.35.0
@@ -60,11 +62,16 @@ localPathCSI:

 cluster:
   mysql:
+    # 外部 mysql 地址
     host: 1.2.3.4
+    # 外部 mysql 端口
     port: 3306
+    # 外部 mysql 用户，需要用具备 root 权限的用户，因为 cloudpods operator 会为其他服务创建数据库用户
     user: root
+    # 外部 mysql 密码
     password: your-db-password
     statefulset:
+      # 生产环境部署这里需要设置成 false ，不然会在 k8s 集群里面部署一个 mysql ，然后连接使用这个 statefulset mysql
       enabled: false
       image:
         repository: "registry.cn-beijing.aliyuncs.com/yunionio/mysql"
@@ -91,15 +98,20 @@ cluster:
   # imageRepository defines default image registry
   imageRepository: registry.cn-beijing.aliyuncs.com/yunion
   # publicEndpoint is upstream ingress virtual ip address or DNS domain
+  # 集群外部可访问的域名或者 ip 地址
   publicEndpoint: foo.bar.com
   # edition choose from:
   # - ce: community edition
   # - ee: enterprise edition
+  # 选择部署 ce(开源) 版本
   edition: ce
   # storageClass for stateful component
+  # 有状态服务使用的 storageClass，如果不设置就会使用 local-path CSI
+  # 这个可根据 k8s 集群情况自行调节
   storageClass: ""
   ansibleserver:
     service:
+      # 指定服务暴露的 nodePort，如果和集群已有服务冲突，可以修改
       nodePort: 30890
   apiGateway:
     apiService:
@@ -193,6 +205,7 @@ cluster:
     service:
       nodePort: 30889

+# 设置 ingress
 ingress:
   enabled: true
+  # 设置 ingress 的 className，比如集群里面使用 nginx-ingress-controller
+  # 这里的 className 就写 nginx
+  # className: nginx
   className: ""
```

修改完 values-prod.yaml 文件后，用以下命令部署：

```bash
# 注意这里的 `--namespace onecloud` 不能改成其他的，必须是 onecloud
$ helm install --name-template default --namespace onecloud . -f values-prod.yaml  --create-namespace
```

## 查看部署服务状态

使用 helm install 安装完 cloudpods chart 后，使用以下命令查看部署的 pod 状态。

```bash
# 正常运行情况下，在 onecloud namespace 下会有这些 pod
$ kubectl get pods -n onecloud
NAME                                               READY   STATUS    RESTARTS   AGE
default-cloudpods-ansibleserver-779bcbc875-nzj6k   1/1     Running   0          140m
default-cloudpods-apigateway-7877c64f5c-vljrs      1/1     Running   0          140m
default-cloudpods-climc-6f4bf8c474-nj276           1/1     Running   0          139m
default-cloudpods-cloudevent-79c894bbfc-zdqcs      1/1     Running   0          139m
default-cloudpods-cloudid-67c7894db7-86czj         1/1     Running   0          139m
default-cloudpods-cloudmon-5cd9866bdf-c27fc        1/1     Running   0          68m
default-cloudpods-cloudproxy-6679d94fc7-gm5tx      1/1     Running   0          139m
default-cloudpods-devtool-6db6f4d454-ldw69         1/1     Running   0          139m
default-cloudpods-esxi-agent-7bcc56987b-lgpnf      1/1     Running   0          139m
default-cloudpods-etcd-q8j5c29tm2                  1/1     Running   0          145m
default-cloudpods-glance-7547c455d5-fnzqq          1/1     Running   0          140m
default-cloudpods-influxdb-c9947bdc8-x8xth         1/1     Running   0          139m
default-cloudpods-keystone-6cc64bdcc7-xhh7m        1/1     Running   0          145m
default-cloudpods-kubeserver-5544d59c98-l9d74      1/1     Running   0          140m
default-cloudpods-logger-8f56cd9b5-f9kbp           1/1     Running   0          139m
default-cloudpods-monitor-746985b5cf-l8sqm         1/1     Running   0          139m
default-cloudpods-notify-dd566cfd6-hxzr4           10/10   Running   0          139m
default-cloudpods-operator-7478b6c64b-wbg26        1/1     Running   0          72m
default-cloudpods-region-7dfd9b888-hsvv8           1/1     Running   0          144m
default-cloudpods-scheduledtask-7d69b877f7-4ltm6   1/1     Running   0          139m
default-cloudpods-scheduler-8495f85798-zgvq2       1/1     Running   0          140m
default-cloudpods-web-5bc6fcf78d-4f7lw             1/1     Running   0          140m
default-cloudpods-webconsole-584cfb4796-4mtnj      1/1     Running   0          139m
default-cloudpods-yunionconf-677b4448b6-tz62m      1/1     Running   0          139m
```

## 创建默认管理用户

### 创建账号登录 Web UI

如果是企业版，前端会提示注册，获取 license ，下面的操作适用于开源版本：

### 进入 climc 命令行 pod

如果是部署的 ce(社区开源版本)，需要使用平台的命令行工具创建默认用户，进行相关操作，对应命令如下，首先是进入 climc pod 容器：

```bash
# 进入 climc pod
$ kubectl exec -ti -n onecloud $(kubectl get pods -n onecloud | grep climc | awk '{print $1}') -- bash
Welcome to Cloud Shell :-) You may execute climc and other command tools in this shell.
Please exec 'climc' to get started

bash-5.1#
```

### 创建用户

在 climc pod 里面创建 admin 用户，命令如下：

```bash
# 创建 admin 用户，设置密码为 admin@123 ，根据需求自己调整
[in-climc-pod]$ climc user-create --password 'admin@123' --enabled admin

# 允许 web 登陆
[in-climc-pod]$ climc user-update --allow-web-console admin

# 将 admin 用户加入 system project 赋予管理员权限
[in-climc-pod]$ climc project-add-user system admin admin
```

## 访问前端

根据创建的 ingress 访问平台暴露出来的前端，通过下面的命令查看 ingress ：

```bash
# 我测试的集群 ingress 信息如下，不同的 k8s 集群根据 ingress 插件的实现各有不同
$ kubectl get ingresses -n onecloud
NAME                    HOSTS   ADDRESS                 PORTS     AGE
default-cloudpods-web   *       10.127.100.207          80, 443   7h52m
```

使用浏览器访问 https://10.127.100.207 即可访问平台前端，然后使用之前创建的 admin 用户登陆。

## 升级

升级可以通过修改对应的 values yaml 文件，然后进行升级配置，比如发现 cluster.regionServer.service.nodePort 的 30888 端口出现了占用冲突，要修改成其它端口 30001，就修改 values-prod.yaml 里面对应的值：

```diff
--- a/charts/cloudpods/values-prod.yaml
+++ b/charts/cloudpods/values-prod.yaml
@@ -170,7 +170,7 @@ cluster:
       nodePort: 30885
   regionServer:
     service:
-      nodePort: 30888
+      nodePort: 30001
   report:
     service:
       nodePort: 30967
```

然后使用 helm upgrade 命令升级：

```bash
$ helm upgrade -n onecloud default . -f values-prod.yaml
```

再查看 onecloudcluster 资源，会发现对应的 spec.regionServer.service.nodePort 变成了 30001，对应的 service nodePort 也会发生变化：

```bash
# 查看 regionServer 在 onecloudcluster 里面的属性
$ kubectl get oc -n onecloud default-cloudpods -o yaml | grep -A 15 regionServer
  regionServer:
    affinity: {}
    disable: false
    dnsDomain: cloud.onecloud.io
    dnsServer: 10.127.100.207
    image: registry.cn-beijing.aliyuncs.com/yunion/region:v3.9.2
    imagePullPolicy: IfNotPresent
    limits:
      cpu: "1.333333"
      memory: 2045Mi
    replicas: 1
    requests:
      cpu: 10m
      memory: 10Mi
    service:
      nodePort: 30001

# 查看 default-cloudpods-region service 的 nodePort
$ kubectl get svc -n onecloud | grep region
default-cloudpods-region          NodePort    10.110.105.228   <none>        30001:30001/TCP                   7h30m
```

查看之前变更的 cluster.regionServer.service.nodePort 是否在平台的 endpoint 里面发生了变化：

```bash
# 使用 climc pod 指定 endpoint-list 命令查看
$ kubectl exec -ti -n onecloud $(kubectl get pods -n onecloud | grep climc | awk '{print $1}') -- climc endpoint-list --search compute
+----------------------------------+-----------+----------------------------------+----------------------------------------+-----------+---------+
|                ID                | Region_ID |            Service_ID            |                  URL                   | Interface | Enabled |
+----------------------------------+-----------+----------------------------------+----------------------------------------+-----------+---------+
| c88e03490c2543a987d86d733b918a2d | region0   | a9abfdd204e9487c8c4d6d85defbfaef | https://10.127.100.207:30001           | public    | true    |
| a04e161ee71346ac88ddd04fcebfe5ce | region0   | a9abfdd204e9487c8c4d6d85defbfaef | https://default-cloudpods-region:30001 | internal  | true    |
+----------------------------------+-----------+----------------------------------+----------------------------------------+-----------+---------+
***  Total: 2 Pages: 1 Limit: 20 Offset: 0 Page: 1  ***
```

## 删除

```bash
$ helm delete -n onecloud default
```

## 其它问题

### 1. onecloud namespace 缺少 keystone, glance, region 等 pod

如果执行 `helm install` 后，执行 `kubectl get pods -n onecloud` 发现只有 operator 这个 pod，而没有出现 keystone, glance, region 这些平台相关服务的 pod ，可以使用下面的命令查看 operator pod 的日志排查问题。

出现这种情况的原因一般都是 operator 在创建 keystone, region 这些平台相关服务出现了错误。常见的问题有 operator 无法使用相关的 mysql 用户创建用户和数据库；或者创建了 keystone 服务后，又无法通过 K8s 内部 service 域名访问 keystone pod 等。

```bash
# 将 operator 的所有日志重定向到文件
$ kubectl logs -n onecloud $(kubectl get pods -n onecloud | grep operator | awk '{print $1}') > /tmp/operator.log
# 然后查看 /tmp/operator.log 里面有没有相关错误


# 查看 operator 日志当中有没有 requeuing 关键字，一般错误会反馈到这里
$ kubectl logs -n onecloud $(kubectl get pods -n onecloud | grep operator | awk '{print $1}') | grep requeuing
```
