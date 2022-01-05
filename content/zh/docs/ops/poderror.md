---
title: "排查pod异常"
date: 2021-11-10T16:02:27+08:00
weight: 30
description: >
    根据pod状态排查错误
---

### 确认Pod状态

```
# 设置默认命名空间，后续执行相关命令时可以不带“-n onecloud” 
$ kubectl config set-context --current --namespace=onecloud
# 查看 pod 状态
$ kubectl get pod
```

### 检查pod相关事件

当查看到 pod 状态不是 running 状态时，可以通过 describe 命令查看更多信
息。
```
# 举例为查看 host 服务的 pod 的事件信息
$ kubectl describe pod default-host-z8j5r
```

### 查看日志

可以通过检查日志来查看应用程序是否正常运行。
```
# 查看 host 服务的日志信息
$ kubectl logs default-host-z8j5r -c host -f 
```

### Pod常见错误及处理方法


#### Pod - CrashLoopBackOff状态

CrashLoopBackOff 状态说明容器曾经启动了，但又异常退出。此时可以先查看
一下容器的日志。通过 kubectl logs 命令可以发现一些容器退出的原因:

- 通过查看日志发现是脏数据导致的
```
[root@test ~]#kubectl get pod | grep region
default-region-75bc7d474f-rjpkm 0/1
CrashLoopBackOff 12 2d20h
default-region-dns-88s7z 1/1 Running
0 2d20h
[root@test ~]# kubectl logs default-region-75bc7d474f￾rjpkm | less
[I 200618 16:13:32
appsrv.(*Application).ServeHTTP(appsrv.go:237)]
hlgxXm4i2qF10tkBXu3rAVrCC-w= 200 b5e0b2 GET
/networks?admin=true&delete=all&details=true&filter.0=updated_at.
ge%28%272020-06-
03+07%3A56%3A04%27%29&filter.1=manager_id.isnullorempty%28%29&fil
ter.2=external_id.isnullorempty%28%29&limit=1024&offset=0&order=a
sc&order_by.0=updated_at&pending_delete=all (10.105.232.12:55236)
34.50ms
[F 200618 16:13:32 models.(*SGuest).GetDriver(guests.go:557)]
Unsupported hypervisor Aliyun
```

- pod 中对应的配置文件中格式不对

![](../images/configmaperror.png)

#### Pod - Evicted状态

出现这种情况，多见于系统内存或硬盘资源不足。通过“kubectl describe命令”查看异常pod。

```
[root@test-interface ~]# kubectl describe -n onecloud pod default-ovn-north-7689f47894-tqp2g
Name:           default-ovn-north-7689f47894-tqp2g
Namespace:      onecloud
Priority:       0
Node:           test-interface/
Start Time:     Fri, 20 Mar 2020 18:38:27 +0800
Labels:         app=ovn-north
                app.kubernetes.io/component=ovn-north
                app.kubernetes.io/instance=onecloud-cluster-8p2p
                app.kubernetes.io/managed-by=onecloud-operator
                app.kubernetes.io/name=onecloud-cluster
                pod-template-hash=7689f47894
Annotations:    cni.projectcalico.org/podIP: 10.40.180.212/32
                onecloud.yunion.io/last-applied-configuration:
                  {"volumes":[{"name":"certs","secret":{"secretName":"default-certs","items":[{"key":"ca.crt","path":"ca.crt"},{"key":"service.crt","path":"...
Status:         Failed
Reason:         Evicted
Message:        The node was low on resource: ephemeral-storage. Container ovn-north was using 109956Ki, which exceeds its request of 0.
```
#### Pod - ImagePullBackOff状态

通常是镜像名称配置错误或者私有镜像的密钥配置错误导致。通过“kubectl describe命令”查看异常pod。

```
Events:
  Type     Reason     Age                From                Message
  ----     ------     ----               ----                -------
  Normal   Scheduled  35s                default-scheduler   Successfully assigned onecloud/default-region-85ff9dcd5-mh8cl to yunion320
  Normal   Pulling    34s                kubelet, yunion320  Pulling image "registry.cn-beijing.aliyuncs.com/yunionio/region:v3.2.1"
  Normal   Pulled     33s                kubelet, yunion320  Successfully pulled image "registry.cn-beijing.aliyuncs.com/yunionio/region:v3.2.1"
  Normal   Created    33s                kubelet, yunion320  Created container init
  Normal   Started    33s                kubelet, yunion320  Started container init
  Normal   Pulling    15s (x2 over 28s)  kubelet, yunion320  Pulling image "registry.cn-beijing.aliyuncs.com/yunionio/region:v3.2.2"
  Warning  Failed     15s (x2 over 28s)  kubelet, yunion320  Failed to pull image "registry.cn-beijing.aliyuncs.com/yunionio/region:v3.2.2": rpc error: code = Unknown desc = Error response from daemon: manifest for registry.cn-beijing.aliyuncs.com/yunionio/region:v3.2.2 not found: manifest unknown: manifest unknown
  Warning  Failed     15s (x2 over 28s)  kubelet, yunion320  Error: ErrImagePull
  Normal   BackOff    3s                 kubelet, yunion320  Back-off pulling image "registry.cn-beijing.aliyuncs.com/yunionio/region:v3.2.2"
  Warning  Failed     3s                 kubelet, yunion320  Error: ImagePullBackOff
```

#### Pod - Pending状态

Pending状态，这个状态意味着，Pod的yaml文件已经提交给Kubernetes，API对象已经被创建并保存在Etcd 当中。但是，这个Pod里有些容器因为某种原因而不能被顺利创建。

- 调度不成功（可以通过 kubectl describe pod 命令查看到当前 Pod 的事件，进而判断为什么没有调度）。
- 可能原因： 资源不足（集群内所有的 Node 都不满足该 Pod 请求的 CPU、内存、GPU 等资源）；
- HostPort 已被占用（通常推荐使用 Service 对外开放服务端口）。

#### Pod - Error状态

通常处于 Error 状态说明 Pod 启动过程中发生了错误。常见的原因包括：

- 依赖的 ConfigMap、Secret 或者 PV 等不存在；
- 请求的资源超过了管理员设置的限制，比如超过了 LimitRange 等；
- 违反集群的安全策略，比如违反了 PodSecurityPolicy 等；
- 容器无权操作集群内的资源，比如开启 RBAC 后，需要为 ServiceAccount 配置角色绑定;