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

`ocadm cluster update --use-ee/--use-ce` 命令会更新替换当前的 default-web deployment，执行该命令后等到新的 pod 启动后，重新刷新前端页面，即可进入(开源版/企业版)前端。

## 常见问题

### 访问前端出现错误

**问题原因**: 开源与企业版本的前端分别依赖不同的 default-web configmap，直接切换过去会导致 default-web configmap 没有更新，会造成企业版本使用开源版本 configmap 的问题。

**解决办法**: 在控制节点上删除 web 服务的 nginx configmap 配置文件，并重启 web 服务即可。

```bash
# 删除 default-web 的 configmap 文件
$ kubectl delete configmap -n onecloud default-web

# 重启 default-web 服务
$ kubectl rollout restart deployment -n onecloud default-web
```
