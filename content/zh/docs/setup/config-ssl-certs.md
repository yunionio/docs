---
title: "更换前端证书"
weight: 102
description: >
  介绍如何使用自定义证书替换系统前端默认的证书
---

默认部署完成后，访问前端界面，浏览器会提示不安全的 SSL 连接，原因是前端默认使用的是自签发的证书。本文介绍如何使用自定义证书替换掉前端默认的证书。

## 操作步骤

假设已经准备好的证书文件为：`cert.pem` 和 `cert.key`，域名为 `foo.bar.com` 。

### 1. 将证书导入 kubernetes 集群

kubernetes 使用 secret 这种资源保存证书内容，然后前端服务使用 ingress 引用对应的证书，提供 HTTPS 连接。为了使用自定证书，需要先把证书保存到集群。

```bash
# 创建证书
$ kubectl create secret tls yunion-io-web-secret --key cert.key --cert cert.pem -n onecloud
```

### 2. 编辑 ingress 规则

编辑 `default-web` ingress 规则，引用刚才创建的 yunion-io-web-secret 证书。

```bash
$ kubectl edit ingress -n onecloud default-web
...
  tls:
  # 修改这个 secretName 为 yunion-io-web-secret
  - secretName: yunion-io-web-secret
...
```

### 3. 重启 ingress controller

设置完 default-web ingress 规则后，可以重启下 ingress controller 服务，让证书生效。

```bash
$ kubectl get pods -n kube-system | grep traefik | awk '{print $1}' | xargs kubectl delete pods -n kube-system
```

### 4. 修改服务 api_server 入口配置

因为使用域名 `foo.bar.com` 访问，需要修改云平台的默认 api_server 配置，这个配置会影响前端 VNC 连接的地址。将旧的 https://<ip> 访问地址改为 `https://foo.bar.com`，操作如下：

```bash
$ climc service-config-edit common
default:
  api_server: https://foo.bar.com
  ...
```

配置完成后就可以通过 `https://foo.bar.com` 访问前端了。
