---
title: "升级相关"
linkTitle: "升级相关"
weight: 100
description: >
---

本文介绍从 v3.3.x 升级到 v3.4.x 的步骤以及注意事项。

版本升级建议从相邻的版本升级，比如从 v3.0.x 升级到 v3.4.x 需要以下的步骤：

1. v3.0.x => v3.1.x
2. v3.1.x => v3.2.x
3. v3.2.x => v3.3.x
4. v3.3.x => v3.4.x

直接跨多个版本升级可能会出现问题，建议参考以下的内容选择升级步骤:

- [v3.1.x 升级到 v3.2.x](https://opensource.yunion.cn/v3.2/docs/setup/upgrade)
- [v3.2.x 升级到 v3.3.x](https://opensource.yunion.cn/v3.3/docs/setup/upgrade)

总体来说，升级的步骤如下:

1. 更新 rpm 源，升级 ocadm
2. 使用 ocadm 升级 Cloudpods 服务

## 查看当前版本

可以使用 kubectl 查看当前集群的版本

```bash
# 使用 kubectl 获得当前集群的版本为 v3.3.3
$ kubectl -n onecloud get onecloudclusters default -o=jsonpath='{.spec.version}'
v3.3.3
```

## 更新 rpm repo

ocadm 和 climc 这些命令行工具是以 yum rpm 包的方式安装，所以升级之前需要先更新这两个工具，然后再使用 ocadm 升级 Cloudpods 服务。

```bash
# 修改 baseurl，把 3.3 改成 3.4
$ sed -i 's|baseurl.*|baseurl=https://iso.yunion.cn/3.4|g' /etc/yum.repos.d/yunion.repo

# 更新 yunion-ocadm, yunion-climc
$ yum clean all
$ yum install -y yunion-ocadm yunion-climc

# 查看 ocadm 版本
$ ocadm version -o short
tags/v3.4.3(99f04e620101609)
```

## 更新 Cloudpods 服务

```bash
# 使用 ocadm 更新 operator 以及相关服务到 v3.4.3 版本
# 该步骤会因为拉取 docker 镜像等待较长时间，请耐心等待
$ ocadm cluster update --operator-version v3.4.3 --version v3.4.3 --wait

# 另外可以在升级的过程中使用 kubectl 查看对应 pods 的升级情况
$ kubectl get pods -n onecloud --watch
```
