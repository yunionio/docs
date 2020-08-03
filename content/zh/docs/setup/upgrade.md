---
title: "升级相关"
linkTitle: "升级相关"
weight: 100
description: >
---

本文介绍从 v3.1.x 升级到 v3.2.x 的步骤以及注意事项。

版本升级建议从相邻的版本升级，比如从 v3.0.x 升级到 v3.2.x 需要以下的步骤：

1. v3.0.x => v3.1.x
2. v3.1.x => v3.2.x

总体来说，升级的步骤如下:

1. 更新 rpm 源，升级 ocadm
2. 使用 ocadm 升级 OneCloud 服务

## 查看当前版本

可以使用 kubectl 查看当前集群的版本

```bash
# 使用 kubectl 获得当前集群的版本为 v3.1.3
$ kubectl -n onecloud get onecloudclusters default -o=jsonpath='{.spec.version}'
v3.1.3
```

## 更新 rpm repo

ocadm 和 climc 这些命令行工具是以 yum rpm 包的方式安装，所以升级之前需要先更新这两个工具，然后再使用 ocadm 升级 OneCloud 服务。

```bash
# 修改 baseurl，把 3.1 改成 3.2
$ sed -i 's|baseurl.*|baseurl=https://iso.yunion.cn/3.2|g' /etc/yum.repos.d/yunion.repo

# 更新 yunion-ocadm, yunion-climc
$ yum install -y yunion-ocadm yunion-climc

# 查看 ocadm 版本
$ ocadm version -o short
tags/v3.2.3(90b9c0ccc)
```

## 更新 OneCloud 服务

```bash
# 使用 ocadm 更新 onecloud operator 以及相关服务到 v3.2.3 版本
# 该步骤会因为拉取 docker 镜像等待较长时间，请耐心等待
$ ocadm cluster update --operator-version v3.2.3 --version v3.2.3 --wait

# 另外可以在升级的过程中使用 kubectl 查看对应 pods 的升级情况
$ kubectl get pods -n onecloud --watch
```

## 已知问题

### 升级到 v3.2 后，出现 Web 前端无法访问

**问题原因**: 该问题是由于 v3.2 之前版本进行UI迁移工作，导致前端访问 URL 中多了 v1 和 v2 版本的字段，而 v2.2 版本 Web 前端已全部迁移到 v2 版本，前端访问的 URL 中去掉了版本字段。而从 v3.1 升级到 v3.2 的 nginx 配置中默认带着版本字段，导致无法访问 Web 前端。

**解决办法**: 在控制节点上删除 web 服务的 nginx configmap 配置文件，并重启 web 服务即可。

```bash
# 删除 default-web 的 configmap 文件
$ kubectl delete configmap -n onecloud default-web

# 重启 default-web 服务
$ kubectl rollout restart deployment -n onecloud default-web
```

### 升级到 v3.2 后，notify pod 运行状态不正常

**问题原因**: 该问题时由于升级到 v3.2 版本后，notify 服务的 configmap 相对于之前版本有变动，而升级过程中不会删除旧的 configmap 导致。

**解决办法**: 在控制节点上手动删除 notify 服务的 configmap 文件，并重启 notify 服务即可。

```bash
# 删除 default-notify 的 configmap 文件
$ kubectl delete configmap -n onecloud default-notify

# 重启 default-notify deployment
$ kubectl rollout restart deployment -n onecloud default-notify
```
