---
title: "切换到企业版/开源版"
date: 2020-02-12T12:55:46+08:00
weight: 12
draft: true
edition: ce
description: >
  介绍从开源版本切换为企业版本或从企业版本切换到开源版本
---

默认情况下部署好的版本是 **开源版本(CE: Community Edition)**，可以到ocboot所在路径（通常建议安装路径为`/opt/ocboot`），执行 `python3 ocboot.py ee <IP>` 命令切换成 **企业版本(EE: Enterprise Edition)**。其中，`<IP>`为管理节点的IPv4地址。

## 切换操作

```bash
# 切换到企业版
$ python3 ocboot.py ee <IP>

# 切换到开源版的 web 前端
$ python3 ocboot.py ce <IP>
```

上述切换命令会更新替换当前的 `default-web deployment`，并删除对应的`configmap`，重启`web`服务。

如果web服务不正常，您也可以自行手工执行下面的操作，来确保web服务的彻底更新，或直接联系管理员：

```bash
# 删除 default-web 的 configmap 文件
$ kubectl delete configmap -n onecloud default-web

# 重启 default-web 服务
$ kubectl rollout restart deployment -n onecloud default-web
```
