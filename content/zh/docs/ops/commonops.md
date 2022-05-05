---
title: "组件pod常用运维命令"
date: 2021-11-10T18:54:59+08:00
weight: 20
description: >
    介绍如何重启组件服务、查看组件日志等
---

### 查看组件pod运行情况

系统组件都以 k8s pod的形式运行，通过以下命令查看平台的系统组件以及运行情况等。
```bash
# -n表示namespace的意思，目前我们的服务都部署在onecloud namespace下，查看所有组件的pod的运行情况
$ kubectl get pods -n onecloud 
```
```bash
# -o wide查看pod的更多详细信息，比如运行在哪个节点上
$ kubectl get pods -n onecloud -o wide
```
```bash
# 查看指定pod资源的详细信息，如查看region组件的pod的详细信息
$ kubectl describe pods -n onecloud default-region-759b4bff4c-hpmdd
```
```bash
# 查看指定主机上运行的所有pod信息
$ kubectl get pods -n onecloud -o wide --field-selector=spec.nodeName=<host-name>
```
### 重启组件服务

```bash
# 重启host服务，如删除所有host pod
$ kubectl rollout restart deployment -n onecloud default-host

# 重启web服务
$ kubectl rollout restart deployment -n onecloud default-web

# 重启onecloud命名空间下的所有pod
$ kubectl get pods -n onecloud | awk '{print $1}' | xargs kubectl delete pods -n onecloud

# 重启所有服务，平台服务都以default开头
$ kubectl get deployment -n onecloud |grep default | awk '{print $1}' | xargs kubectl rollout restart deployment -n onecloud

# 重启onecloud命名空间下的所有pod
$ kubectl get deployment -n onecloud | awk '{print $1}' | xargs kubectl rollout restart deployment -n onecloud

```

### 更新服务配置并重启服务

平台所有组件服务都有对应的Configmaps文件保存服务配置，当配置信息需要更改时，可通过以下步骤更新服务配置并使其生效。

```bash
# 以region服务为例更新其configmaps配置信息
$ kubectl edit configmaps default-region -n onecloud
```
```bash
# 修改完成后，重启服务
$ kubectl -n onecloud rollout restart deployment default-region

```
### 查看服务日志

查看持久化服务日志，请参考[持久化后端日志]({{< relref "backendlogs" >}})

以region组件为例介绍如何查看region组件的日志信息。
```bash
# 首先需要找到region服务所在pod
$ kubectl get pods -n onecloud |grep region
```
```bash
# 查看region服务容器的日志，其中-f表示follow，即持续输出日志，类似于journalctl的 -f；--since 5m 表示查看近5分钟的日志信息。按CTRL+C退出日志输出
$ kubectl logs -n onecloud $region_pod_name -f --since 5m
```
```bash
# 查看region容器日志，将最近5分钟的所有日志到region.log
$ kubectl logs -n onecloud $region_pod_name --since 5m > region.log
```
```bash
# 若有些服务有两个容器，如host服务有名称为host和host-image的容器，此时查看容器命令时需要加'-c' 指定查看哪个容器的日志
$ kubectl logs -n onecloud $host_pod_name -c host-image -f
```


### 查看平台版本信息
```bash
# 其中onecloudcluster 可以简写成oc；default为OneCloudCluster的名称；-o yaml即以yaml形式输出onecloudcluster类型资源的API对象。
$ kubectl get onecloudcluster -n onecloud default -o yaml | grep version
```
### 查看MySQL账户密码信息

采用默认部署数据库的方式，在平台部署完成后需要通过以下命令获取连接MySql的用户名和密码。

```bash
# 查看MySQL的配置连接信息，其中oc为onecloudcluster；default为oc的名称；grep -A 4即属于匹配后4行数据。
$ kubectl get oc -n onecloud default -o yaml | grep -A 4 mysql
```
### 查看OC的的API对象信息

```bash
# 查看OC的运行情况
$ kubectl get onecloudcluster -n onecloud
```
```bash
# 以yaml文件的形式查看OC的API对象信息，该信息中包含集群的所有配置信息。
$ kubeclt get oc -n onecloud -o yaml

```

### 其它常用管理命令

kubectl更多命令请参考kubectl官方文档。
https://kubernetes.io/zh/docs/reference/kubectl/