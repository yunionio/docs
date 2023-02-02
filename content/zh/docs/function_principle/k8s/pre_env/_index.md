---
title: "环境准备"
description: 介绍各个平台部署 kubernetes 集群对应的环境准备
weight: 1
---

## {{% oem_name %}}私有云

如果是在{{<oem_name>}}私有云上部署 kubernetes 集群，需要先导入 CentOS 7 或者 Kylin 的镜像，下面已 CentOS 镜像导入为例子，操作如下：

1. 进入主机菜单，选择系统镜像的上传按钮
2. 输入镜像名称 'CentOS-7.6.1810-20190430.qcow2'
3. 上传方式选择 '输入镜像URL'，镜像 URL 为: https://iso.yunion.cn/vm-images/CentOS-7.6.1810-20190430.qcow2

<img src="./images/k8s_cluster_import_onecloud_image.png">

等待镜像导入完毕后，就可以使用该镜像创建虚拟机部署 kubernetes 集群。

## 离线部署

如果作为 K8s 的虚拟机节点无法连接公网，可以使用下面的方式配置离线部署。

{{% alert title="注意" color="warning" %}}
离线部署仅支持 {{<oem_name>}}私有云创建的 K8s 集群。
{{% /alert %}}

### 部署 kubeserver offline 离线服务

首先是把 kubeserver-offline 离线服务部署到系统的 K8s 集群，kubeserver-offline 的 yaml 资源描述文件如下，可根据自己环境进行调整：

```yaml
---
apiVersion: apps/v1
kind: Deployment
metadata:
  annotations:
  labels:
    app: kubeserver-offline-server
    app.kubernetes.io/component: kubeserver-offline-server
  name: kubeserver-offline-server
  namespace: onecloud
spec:
  progressDeadlineSeconds: 600
  replicas: 1
  revisionHistoryLimit: 10
  selector:
    matchLabels:
      app: kubeserver-offline-server
      app.kubernetes.io/component: kubeserver-offline-server
  strategy:
    rollingUpdate:
      maxSurge: 25%
      maxUnavailable: 25%
    type: RollingUpdate
  template:
    metadata:
      labels:
        app: kubeserver-offline-server
        app.kubernetes.io/component: kubeserver-offline-server
    spec:
      affinity:
        nodeAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
            - matchExpressions:
              - key: onecloud.yunion.io/controller
                operator: In
                values:
                - enable
      containers:
      - command:
        - nginx
        - -g
        - daemon off;
        # kubeserver-offline-nginx 镜像，里面包含了依赖的二进制，以及 rpm 包
        image: registry.cn-beijing.aliyuncs.com/zexi/kubeserver-offline-nginx:v0.0.2
        imagePullPolicy: IfNotPresent
        name: nginx
        ports:
        - containerPort: 80
          name: nginx
          protocol: TCP

      - name: registry
        # kubeserver-offline-registry 镜像，里面包含容器所需要的镜像
        image: registry.cn-beijing.aliyuncs.com/zexi/kubeserver-offline-registry:v0.0.2
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: 5000
          name: registry
          protocol: TCP
      dnsPolicy: ClusterFirst
      restartPolicy: Always
      schedulerName: default-scheduler
      securityContext: {}
      terminationGracePeriodSeconds: 30
      tolerations:
      - effect: NoSchedule
        key: node-role.kubernetes.io/master
      - effect: NoSchedule
        key: node-role.kubernetes.io/controlplane
---
apiVersion: v1
kind: Service
metadata:
  labels:
    app: kubeserver-offline-server
    app.kubernetes.io/component: kubeserver-offline-server
  name: kubeserver-offline-server
  namespace: onecloud
spec:
  ports:
  - name: http
    port: 80
    protocol: TCP
    targetPort: 80
    nodePort: 31080
  - name: registry
    port: 5000
    protocol: TCP
    targetPort: 5000
    nodePort: 31500
  selector:
    app: kubeserver-offline-server
    app.kubernetes.io/component: kubeserver-offline-server
  sessionAffinity: None
  type: NodePort
```

把以上的内容写到 kubeserver-offline.yaml 文件保存到控制节点，然后 apply 到系统集群。

```bash
$ kubectl apply -f kubeserver-offline.yaml

# 查看 pod 状态，等待变为 Running
# 因为 kubeserver-offline-nginx 和 kubeserver-offline-registry 镜像较大，总共有 2.9G 左右，请耐心等待镜像下载
$ kubectl get pods -n onecloud  | grep kubeserver-offline
kubeserver-offline-server-775f99fcbd-qq2mc          2/2     Running   0          7h18m

# kubeserver-offline  已 NodePort 的方式暴露服务
# 默认情况下 31080 端口为 nginx 服务，31500 为 registry 镜像服务
$ kubectl get service -n onecloud | grep kubeserver-offline
kubeserver-offline-server           NodePort    10.106.28.148    <none>        80:31080/TCP,5000:31500/TCP       18h
```

### 配置 kubeserver 使用离线服务

配置 kubeserver 的离线配置，命令如下：

```bash
climc service-config-edit k8s
```

在配置中添加 offline_nginx_service_url 和 offline_registry_service_url 地址。

offline_nginx_service_url 的值为：`http://$控制节点IP:31080`
offline_registry_service_url 的值为：`$控制节点IP:31500`

下面假设控制节点IP为 192.168.222.171，则相关配置参数如下：

```yaml
default:
  ...
  offline_nginx_service_url: "http://192.168.222.171:31080"
  offline_registry_service_url: "192.168.222.171:31500"
```

配置完成后，之后创建的集群就会从 kubeserver-offline 离线服务里面下载二进制、rpm包以及容器镜像。
