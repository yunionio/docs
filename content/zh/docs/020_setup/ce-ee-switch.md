---
title: "切换到企业版"
date: 2020-02-12T12:55:46+08:00
weight: 12
description: >
  介绍从开源版本切换为企业版本
---

默认情况下部署好的版本是 **开源版本(CE: Community Edition)**，可以使用 `ocadm cluster update` 命令切换成 **企业版本(EE: Enterprise Edition)**。

## 切换操作

```bash
# 切换到企业版
$ ocadm cluster update --use-ee --wait

# 切换到开源版的 web 前端
$ ocadm cluster update --use-ce --wait
```

`ocadm cluster update --use-ee/--use-ce` 命令会更新替换当前的 default-web deployment

待所有pod启动后，由于开源版和企业版的前端分别依赖不同的 default-web configmap，直接切换过去会导致 default-web configmap 没有更新，web前端无法访问，因为需要删除web服务的nginx configmap，并重启 web 服务。

```bash
# 删除 default-web 的 configmap 文件
$ kubectl delete configmap -n onecloud default-web

# 重启 default-web 服务
$ kubectl rollout restart deployment -n onecloud default-web
```
