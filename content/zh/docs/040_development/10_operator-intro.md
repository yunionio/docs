---
title: "Operator 相关"
weight: 10
description: >
  服务都运行在 K8S 集群中，其中有一个叫做 cloudpods-operator 的 deployment，用于部署和控制其它服务的所需要的 K8S 资源，这里介绍下这个叫做 operator 组件的操作
---

[cloudpods-operator](https://github.com/yunionio/cloudpods-operator) 是单独编写的一个组件，作为一个长期运行的服务运行在 Kubernetes 集群内部，作用是自动搭建和维护 Cloudpods 所有服务。详细的介绍可以参考 [cloudpods-operator 工作原理](https://github.com/yunionio/cloudpods-operator/blob/master/docs/intro.md)。

## 简介

operator 在 K8S 里面创建一个叫做 OnecloudCluster 的资源，该资源里面定义了各个服务组件要使用的 docker 镜像仓库和版本，通过修改 OnecloudCluster 这个资源，可以实现对各个服务多方面的镜像版本控制。

```bash
# 查看 OnecloudCluster 资源
$ kubectl get onecloudclusters.onecloud.yunion.io -n onecloud
NAME      KEYSTONE
default   registry.cn-beijing.aliyuncs.com/yunionio/keystone:archdev-v36

# 查看 default OnecloudCluster 资源的 YAML 详情
$ kubectl get onecloudclusters.onecloud.yunion.io -n onecloud default -o yaml

# 进入 edit 编辑界面
$ kubectl edit onecloudclusters -n onecloud default
```


## 镜像控制

OnecloudCluster 资源的镜像版本控制的关键属性简介如下：

| 属性                       | 作用                       | 默认值                                               |
|----------------------------|----------------------------|------------------------------------------------------|
| .spec.imageRepository      | 控制所有服务的镜像仓库地址 | registry.cn-beijing.aliyuncs.com/yunionio            |
| .spec.version              | 控制所有服务镜像的 tag     | 由部署时指定，比如 'v3.6.9'                          |
| .spec.$(组件名).repository | 控制该组件镜像的仓库地址   | 默认没有设置，可以通过设置该值单独控制组件的镜像仓库 |
| .spec.$(组件名).tag        | 控制该组件镜像的 tag       | 默认没有设置，可以通过设置该值单独控制组件的 tag     |


### 统一修改版本

通过修改 default onecloudcluster `spec.imageRepository` 和 `spec.version` 属性，就会把所有服务的镜像统一更改，以下是使用场景举例:

1. 把所有的服务镜像通一修改到 archdev-v36，修改 `spec.version`

```bash
# 这里的 oc 是 onecloudcluster 的简写，也可以识别
$ kubectl edit oc -n onecloud default
...
    tolerations:
    - effect: NoSchedule
      key: node-role.kubernetes.io/master
    - effect: NoSchedule
      key: node-role.kubernetes.io/controlplane
  # 修改这里的 version ，然后所有服务对应 pod 里面的 image tag 都会变成 archdev-v36
  version: archdev-v36
  vpcAgent:
    disable: false
    image: registry.cn-beijing.aliyuncs.com/yunionio/vpcagent:archdev-v36
...
```

2. 修改所有服务镜像仓库到 registry.cn-beijing.aliyuncs.com/zexi 拉取镜像，修改 `spec.imageRepository`

```bash
$ kubectl edit oc -n onecloud default
spec:
...
    tolerations:
    - effect: NoSchedule
      key: node-role.kubernetes.io/master
    - effect: NoSchedule
      key: node-role.kubernetes.io/controlplane
  # 这里修改 imageRepository 的值，所有的服务对应的 pod 里面的 image 都会从 `registry.cn-beijing.aliyuncs.com/zexi` 这个仓库拉取
  imageRepository: registry.cn-beijing.aliyuncs.com/zexi
  influxdb:
...
```

3. `spec.imageRepository` 和 `spec.version` 可以同时组合使用，这样就可以统一配置各个服务的镜像地址。

修改完这些属性后，可以查看 pods 的状态，会发现所有的 pods 都在重新拉取镜像启动。

### 单独修改组件版本

通过修改各个组件里面的 `spec.$(component).repository` 和 `spec.$(component).tag` 属性，就会把这个服务对应的 deployment 或者 daemonset 的 image 修改。

这两个属性设置 image 的优先级要高于外层的 `spec.imageRepository` 和 `spec.version`。也就是说通过修改组件的 `repository` 和 `tag` 属性，可以做到其它组件镜像不变的情况下，修改单个组件的 image ，这种机制在开发的时候有用。

下面以 region 为例：

1. 指定 `spec.regionServer.repository` 为 `192.168.0.1:5000/yunionio` 和 `spec.regionServer.tag` 为 `lzx-dev`，将会把 default-region deployment 里面的 image 改为: `192.168.0.1:5000/yunionio/region:lzx-dev`。

```bash
$ kubectl edit oc -n onecloud default
spec:
...
  regionServer:
    disable: false
    dnsDomain: cloud.onecloud.io
    # 这里设置 repository
    repository: 192.168.0.1:5000/yunionio
    # 这里设置 tag
    tag: lzx-dev
    dnsServer: 10.127.40.252
    image: registry.cn-beijing.aliyuncs.com/yunionio/region:archdev-v36
    imagePullPolicy: IfNotPresent
    replicas: 1
...

# 现在查看 default-region 这个 deployment
# 会发现里面的 image 已经被 operator 按照 $(spec.regionServer.repository)/region:$(spec.regionServer.tag) 的格式修改了
$ kubectl get deployment -n onecloud default-region -o yaml | grep image:
        image: 192.168.0.1:5000/yunionio/region:lzx-dev
        image: 192.168.0.1:5000/yunionio/region:lzx-dev
```
