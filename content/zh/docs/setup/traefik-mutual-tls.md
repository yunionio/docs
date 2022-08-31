---
title: "前端双向认证配置"
weight: 142
oem_ignore: true
description: >
    介绍如何配置前端的双向认证
---

平台部署后默认打开了 TLS 服务端(单向)认证，本文介绍如何在已有服务端认证的情况下，开启客户端验证(双向)认证。

整个云平台运行在 Kubernetes 之上，前端服务通过 ingress 暴露出来，我们使用了开源的 [traefik](https://doc.traefik.io/traefik/v1.7) 组件来负责 ingress 的实现，所以在 traefik 上设置客户端认证。

## 生成证书

下面使用生成自签名证书的方式来配置，如果已经有证书机构签发的服务端和客户端证书，可以忽略这个步骤。

### 生成 CA

```bash
$ openssl req -x509 -sha256 -newkey rsa:4096 -keyout ca.key -out ca.crt -days 356 -nodes -subj '/CN=My Cert Authority'
```

### 生成 Server 服务端证书

基于上面生成的 CA 签发 server 证书：

```bash
$ openssl req -new -newkey rsa:4096 -keyout server.key -out server.csr -nodes -subj '/CN=mydomain.com'
$ openssl x509 -req -sha256 -days 365 -in server.csr -CA ca.crt -CAkey ca.key -set_serial 01 -out server.crt
```

### 生成 Client 客户端证书

基于上面生成的 CA 签发 client 证书：

```bash
$ openssl req -new -newkey rsa:4096 -keyout client.key -out client.csr -nodes -subj '/CN=My Client'
$ openssl x509 -req -sha256 -days 365 -in client.csr -CA ca.crt -CAkey ca.key -set_serial 02 -out client.crt
```

## 上传证书到 Kubernetes

```bash
# 上传 ca 到 kube-system 命令空间
$ kubectl -n kube-system create secret generic ca-secret --from-file=ca.crt=ca.crt

# 上传 server 证书到 onecloud 命名空间
$ kubectl -n onecloud create secret generic tls-secret --from-file=tls.crt=server.crt --from-file=tls.key=server.key
```

## 修改前端 default-web ingress

前端是通过 onecloud 命令空间里面的 default-web ingress 访问的，把前端使用的 tls 证书换成 tls-secret 。

```bash
$ kubectl edit ingress -n onecloud default-web
...
  tls:
  # 修改这个 secretName 为 tls-secret
  - secretName: tls-secret
...
```

## 修改 traefik 配置

### 修改 traefik configmap

traefik 的配置在 kube-system 命名空间的 traefik-ingress-lb config 里面，开启客户端验证主要是配置 **entryPoints.https.tls.ClientCA** 。

```bash
$ kubectl edit configmaps -n kube-system traefik-ingress-lb
...
     [entryPoints.https]
        address = ":443"
        # 添加如下的 ClientCA 配置
        [entryPoints.https.tls]
          [entryPoints.https.tls.ClientCA]
          files = ["/tests/ca.crt"]
          optional = false
...
```

### 修改 traefik daemonset

然后修改 kube-system 命令空间里面的 traefik-ingress-controller daemonset ，主要是把刚才创建的 ca-secret 挂载到配置的 **/tests/ca.crt** 目录。

```bash
$ kubectl edit daemonsets -n kube-system traefik-ingress-controller
...
        volumeMounts:
        - mountPath: /config
          name: config
        # 添加这个 volume mount，名称为 ca
        - mountPath: /tests
          name: ca
...
      volumes:
      - configMap:
          defaultMode: 420
          name: traefik-ingress-lb
        name: config
      - name: ca
        secret:
          defaultMode: 420
          # 这里引用之前创建的 ca-secret
          secretName: ca-secret
...
```

### 重启 traefik 服务

```bash
$ kubectl get pods -n kube-system | grep traefik | awk '{print $1}' | xargs kubectl delete pods -n kube-system
```

等待 traefik 容器变成 Running。

```bash
$ kubectl get pods -n kube-system | grep traefik
traefik-ingress-controller-fk54h           1/1     Running       0          9s
```

## 使用 curl 进行测试

假设部署的前端访问地址是 https://192.168.121.21 ，下面验证客户端认证是否开启：

```bash
# 不使用 client 证书访问失败，符合预期
$ curl -k https://192.168.121.21
curl: (58) NSS: client certificate not found (nickname not specified)

# 使用 client 证书访问成功
$ curl -k --cert ./client.crt --key ./client.key https://192.168.121.21
<!DOCTYPE html><html lang=en translate=no><head><meta charset=utf-8><meta http-equiv=X-UA-Compatible content="IE=edge"><meta name=viewport content="width=device-width,initial-scale=1"><meta name=google content=notranslate><link rel=icon href=/favicon.ico><title>云联壹云</title><link href=/js/chunk-2d216214.5f7b7e0c.js rel=prefetch><link href=/js/chunk-39bb5eb4.8512e62d.js rel=prefetch><link href=/css/app.fb52a32e.css rel=preload as=style><link href=/css/chunk-vendors.09e9c25d.css rel=preload as=style><link href=/js/app.74cda7af.js rel=preload as=script><link href=/js/chunk-vendors.a7b5c015.js rel=preload as=script><link href=/css/chunk-vendors.09e9c25d.css rel=stylesheet><link href=/css/app.fb52a32e.css rel=stylesheet></head><body><noscript><strong>We're sorry but OneCloud doesn't work properly without JavaScript enabled. Please enable it to continue.</strong></noscript><div id=app></div><script src=/vendor.b82688a471b737ceddd1.js></script><script src=/js/chunk-vendors.a7b5c015.js></script><script src=/js/app.74cda7af.js></script></body></html>
```

## 浏览器配置

通过以上的配置，发现客户端配置已经成功，但通过浏览器访问，还需要把客户端的证书放到浏览器里面，否则访问就会出现下面的界面：

![](../images/chrome-bad-ssl-client.png)

下面以 Chrome 浏览器为例， 需要把之前生成的 client.crt 和 client.key 装换成 pfx/pkcs12 格式，就能导入浏览器，命令如下：

```bash
# 把 client.crt 和 client.key 组合到一起
$ cat client.crt client.key > pkcs12.pem 

# 转换成 pkcs12 格式
$ openssl pkcs12 -in pkcs12.pem -export -out pkcs12.p12
```

把 pkcs12.p12 导入到浏览器：

![](../images/chrome-certs.png)

选择刚才生成的 pkcs12.p12 证书：

![](../images/chrome-import-pkcs12.png)

导入后再刷新访问前端，就可以成功访问界面。

![](../images/chrome-web.png)
