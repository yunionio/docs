---
title: "前端使用 HTTP"
weight: 143
edition: ce
oem_ignore: true
description: >
    介绍如何配置前端访问协议为 HTTP
---

平台部署后默认打开了 TLS 服务端(单向)认证，使用 HTTPS 协议进行浏览器访问前端界面。本文介绍如何配置使用 HTTP 协议访问前端。

## 编辑 onecloudcluster spec

首先需要编辑 oc.spec.web.useHTTP 属性，该属性默认为 false ，需要设置为 true ，操作如下：

```bash
$ kubectl edit oc -n onecloud
```

搜 useHTTP 关键字，进行如下编辑：

```diff
   spec:
     web:
@@ -1122,7 +1122,7 @@
         key: node-role.kubernetes.io/master
       - effect: NoSchedule
         key: node-role.kubernetes.io/controlplane
-      useHTTP: false
+      useHTTP: true
     webconsole:
       affinity:
         nodeAffinity:
```

## 删除旧的 web configmap

web 组件的 configmap 其实是一个 nginx 配置，该配置不会重新生成，需要删除后由 operator 新建，操作如下：

```bash
# 删除 web 组件的 configmap
$ kubectl delete configmap -n onecloud $(kubectl get configmap -n onecloud | grep web | grep -v console | awk '{print $1}')
configmap "default-web" deleted

# 等待 15s 后，该 configmap 会新建，查看生成的内容
$ kubectl get configmap -n onecloud $(kubectl get configmap -n onecloud | grep web | grep -v console | awk '{print $1}')
NAME          DATA   AGE
default-web   1      28s

# 查看其中是否有 80 端口配置，有的话就没有问题了
$ kubectl get configmap -n onecloud $(kubectl get configmap -n onecloud | grep web | grep -v console | awk '{print $1}') -o yaml | grep 'listen 80'
        listen 80 default_server;
```

## 重启 web 组件

更新完 web 组件的 configmap 后，需要重启 web 组件的 deployment ，命令为：

```bash
# 重启 web deployment
$ kubectl rollout restart deployment -n onecloud $(kubectl get deployment -n onecloud | grep web | grep -v console | awk '{print $1}')
deployment.extensions/default-web restarted

# 等待 pod 变为 Running
$ kubectl get pods -n onecloud | grep web | grep -v console
default-web-5bfb6c578b-mdh9w                        3/3     Running                 0          58s
```

## 更新 ingress

web 组件的 service 是使用 ingress 暴露出去的，ingress 默认也不会刷新，需要删除再次创建，操作如下：

```bash
$ kubectl delete ingress -n onecloud $(kubectl get ingress -n onecloud | grep web | awk '{print $1}')
ingress.extensions "default-web" deleted
```

查看重建的 ingress 规则，已经路由到 80 端口即可：

```bash
$ kubectl get ingress -n onecloud $(kubectl get ingress -n onecloud | grep web | awk '{print $1}') -o yaml | grep -i port
    onecloud.yunion.io/last-applied-configuration: '{"rules":[{"http":{"paths":[{"backend":{"serviceName":"default-web","servicePort":80},"path":"/"}]}}],"tls":[{"secretName":"default-certs"}]}'
          servicePort: 80
```

## 配置 traefik ingress controller

如果是使用 helm 部署的集群，就不用执行该步骤了，ingress controller 的实现和具体的 k8s 部署平台有关，现在 web 服务已经是使用 HTTP 协议了。

下面的步骤仅适用于使用 ocboot 部署的平台，需要设置 traefik ingress controller ，把 http 重定向到 https 这个配置关掉，操作如下：

```bash
$ kubectl edit configmaps -n kube-system traefik-ingress-lb
```

注释掉 entryPoints.http.redirect 配置：

```diff
@@ -14,8 +14,8 @@
     [entryPoints]
       [entryPoints.http]
         address = ":80"
-        [entryPoints.http.redirect]
-        entryPoint = "https"
+        #[entryPoints.http.redirect]
+        #entryPoint = "https"
```

重启 traefik ingress controller：

```bash
$ kubectl delete pods -n kube-system $(kubectl get pods -n kube-system | grep traefik-ingress-controller | awk '{print $1}')
pod "traefik-ingress-controller-xkmct" deleted
```

至此 HTTP 所有配置完成。
