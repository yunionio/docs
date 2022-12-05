---
title: "调整Kubernetes节点驱逐的阈值"
date: 2022-12-05T10:34:27+08:00
weight: 32
---

Kubernetes 有一个节点驱逐的机制，比如当节点的根分区使用空间大于 85% 就会把节点变成 NotReady 状态，然后驱逐上面的 Pod 。下面介绍如何调整节点的相关配置的阈值，可根据自己的环境适当调整。

## 调整 kubelet 阈值配置

kubelet 所有的配置参数写在了文件 `/var/lib/kubelet/config.yaml`，阈值相关的参数如下：

```diff
@@ -34,10 +34,10 @@ enforceNodeAllocatable:
 eventBurst: 10
 eventRecordQPS: 5
 # 驱逐相关参数
 evictionHard:
-  imagefs.available: 15%
-  memory.available: 1024Mi
-  nodefs.available: 15%
-  nodefs.inodesFree: 15%
+  imagefs.available: 5%  # 当容器镜像所在目录的空闲容量小于 5% 的时候触发，imagefs 为 docker 所在目录，配置为 `/opt/docker`
+  memory.available: 100Mi # 当内存不够 100Mi 的时候触发
+  nodefs.available: 5% # 当根分区可用容量不够 5% 的时候触发
+  nodefs.inodesFree: 5% # 当根分区 inodes 不够 5% 的时候触发
 evictionPressureTransitionPeriod: 5m0s
 failSwapOn: true
 fileCheckFrequency: 20s
@@ -45,8 +45,8 @@ hairpinMode: promiscuous-bridge
 healthzBindAddress: 127.0.0.1
 healthzPort: 10248
 httpCheckFrequency: 20s
-imageGCHighThresholdPercent: 85
-imageGCLowThresholdPercent: 80
+imageGCHighThresholdPercent: 95 # 当硬盘存储使用率超过imageGCHighThresholdPercent时，会触发Image GC，直到硬盘存储使用率低于imageGCLowThresholdPercent
+imageGCLowThresholdPercent: 90
 imageMinimumGCAge: 2m0s
 iptablesDropBit: 15
 iptablesMasqueradeBit: 14
```

调整完 `/var/lib/kubelet/config.yaml` 后，重启 kubelet:

```bash
$ systemctl restart kubelet
```
