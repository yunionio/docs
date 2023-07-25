
---
title: "控制节点替换流程"
weight: 246
edition: ce
---

## 背景

即使是高可用部署的 3 节点 cloudpods over k8s 集群，在生产环境可能会出现任意 1 个节点挂掉的情况。
一些普通的故障，比如更换内存，CPU 之类可以解决的问题，可以临时关机，恢复后再重启节点解决。

但如果发生硬盘之类的故障，比如数据无法恢复的情况，需要把该节点删除再重新加入新的节点，接下来描述该步骤以及注意事项。

## 测试环境

- k8s_vip: 10.127.100.102
    - 使用 staticpods keepalived 运行在 3 个 master 节点上
    - 由 kubelet 直接启动，路径：/etc/kubernetes/manifests/keepalived.yaml
- primary_master_node 第1个初始化的控制节点: 
    ip: 10.127.100.234
- master_node_1 第2个加入控制节点:
    ip: 10.127.100.229
- master_node_2 第3个加入的控制节点:
    ip: 10.127.100.226
- 数据库: 数据库部署在集群之外，不在 3 个节点之上
- CSI: 使用 local-path 
    - local-path 的 CSI 会强绑定 pod 到指定的 node，这里需要特别注意
    - 如果挂掉的节点有对应 local-path 的 pvc 绑定在上面，使用该 pvc 的 pod 就没办法漂移到其它 Ready 的 node ，这种 pod 叫有状态的 pod，可以通过命令 `kubectl get pvc -A | grep local-path` 就可以看到所有的 local-path pvc

```bash
$ kubectl get nodes -o wide
NAME                   STATUS   ROLES    AGE    VERSION    INTERNAL-IP      EXTERNAL-IP   OS-IMAGE                KERNEL-VERSION                          CONTAINER-RUNTIME
lzx-ocboot-ha-test     Ready    master   100m   v1.15.12   10.127.100.234   <none>        CentOS Linux 7 (Core)   3.10.0-1160.6.1.el7.yn20201125.x86_64   docker://20.10.5
lzx-ocboot-ha-test-2   Ready    master   61m    v1.15.12   10.127.100.229   <none>        CentOS Linux 7 (Core)   3.10.0-1160.6.1.el7.yn20201125.x86_64   docker://20.10.5
lzx-ocboot-ha-test-3   Ready    master   60m    v1.15.12   10.127.100.226   <none>        CentOS Linux 7 (Core)   3.10.0-1160.6.1.el7.yn20201125.x86_64   docker://20.10.5
```

- minio:
    - 高可用部署下使用 minio 作为 glance 的后端存储
    - statefulset
    - 使用 local-path CSI 作为后端存储

```bash
$ kubectl get pods -n onecloud-minio -o wide
kubectl get pods -n onecloud-minio  -o wide
NAME      READY   STATUS    RESTARTS   AGE   IP              NODE                   NOMINATED NODE   READINESS GATES
minio-0   1/1     Running   0          46m   10.40.99.205    lzx-ocboot-ha-test     <none>           <none>
minio-1   1/1     Running   0          46m   10.40.158.215   lzx-ocboot-ha-test-3   <none>           <none>
minio-2   1/1     Running   0          46m   10.40.159.22    lzx-ocboot-ha-test-2   <none>           <none>
minio-3   1/1     Running   0          46m   10.40.99.206    lzx-ocboot-ha-test     <none>           <none>
$ kubectl get pvc -n onecloud-minio
NAME             STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
export-minio-0   Bound    pvc-297ed5e5-66c8-4855-8031-c65a0ccfa4d0   1Ti        RWO            local-path     46m
export-minio-1   Bound    pvc-4e8fe486-5b23-44a0-876c-df36d134957f   1Ti        RWO            local-path     46m
export-minio-2   Bound    pvc-389b3c61-6000-4757-9949-db53e4e53776   1Ti        RWO            local-path     46m
export-minio-3   Bound    pvc-3dd54509-7745-47dd-84ea-fbacfe1e2f5b   1Ti        RWO            local-path     46m
```

## 测试

### 目标

下线 primary_master_node 10.127.100.234 节点，加入新的节点替换该节点

### 步骤

#### 1. 需要确认有哪些有状态的 pod 和 pvc 运行在该节点

```bash
# 根据 IP 找到节点在 k8s 集群中的名称
$ kubectl get nodes -o wide | grep 10.127.100.234
lzx-ocboot-ha-test     Ready    master   4h15m   v1.15.12   10.127.100.234   <none>        CentOS Linux 7 (Core)   3.10.0-1160.6.1.el7.yn20201125.x86_64   docker://20.10.5

# 查看所有为 local-path 的 pvc
$ kubectl get pvc -A | grep local-path
# onecloud-minio namespace 的 export-minio-x 负责存储 glance 的镜像，是关键组件
onecloud-minio        export-minio-0            Bound     pvc-297ed5e5-66c8-4855-8031-c65a0ccfa4d0   1Ti        RWO            local-path     3h11m
onecloud-minio        export-minio-1            Bound     pvc-4e8fe486-5b23-44a0-876c-df36d134957f   1Ti        RWO            local-path     3h11m
onecloud-minio        export-minio-2            Bound     pvc-389b3c61-6000-4757-9949-db53e4e53776   1Ti        RWO            local-path     3h11m
onecloud-minio        export-minio-3            Bound     pvc-3dd54509-7745-47dd-84ea-fbacfe1e2f5b   1Ti        RWO            local-path     3h11m
# onecloud-monitoring namespace 的 export-monitor-minio-x 负责存储服务的日志，不是关键组件
onecloud-monitoring   export-monitor-minio-0    Bound     pvc-b885605f-b5ca-40ff-b968-4d95b03e8bb8   1Ti        RWO            local-path     3h8m
onecloud-monitoring   export-monitor-minio-1    Bound     pvc-520a8262-5dad-48aa-9a0e-0e25f850faad   1Ti        RWO            local-path     3h8m
onecloud-monitoring   export-monitor-minio-2    Bound     pvc-6de1ff0f-3465-4a51-8124-880f1b3c6d7a   1Ti        RWO            local-path     3h8m
onecloud-monitoring   export-monitor-minio-3    Bound     pvc-364652ca-496e-4b29-82ea-ec7e768aa8f5   1Ti        RWO            local-path     3h8m
# onecloud namespace 下面的这些 pvc 都是系统服务依赖的
# default-baremetal-agent 是存储物理机管理的存储，不开启 baremetal-agent 可以不用管，默认也是 Pending 待绑定状态
onecloud              default-baremetal-agent   Pending                                                                        local-path     3h35m
# default-esxi-agent 负责存 esxi-agent 服务相关的本地数据
onecloud              default-esxi-agent        Bound     pvc-b32adfcc-96e7-45e4-b8bd-b5318c954dca   30G        RWO            local-path     3h35m
# default-glance 负责存 glance 服务的镜像，在高可用部署环境下，deployment default-glance 不会挂载这个 pvc ，会使用 onecloud-minio 里面的 minio s3 存储镜像，可以不用管
onecloud              default-glance            Bound     pvc-e6ee398e-2d84-46cf-9401-e94f438d87cd   100G       RWO            local-path     3h36m
# default-influxdb 负责存平台的监控数据，监控数据可以容忍丢失，如果所在节点挂了，可以删掉重建
onecloud              default-influxdb          Bound     pvc-871b9441-c56f-4bb4-8b56-868e1df1a438   20G        RWO            local-path     3h35m


# 查看该节点上有哪些 pod
$ kubectl get pods -A -o wide | grep onecloud | grep 'lzx-ocboot-ha-test '
onecloud-minio        minio-0                                              1/1     Running   0          3h10m   10.40.99.205     lzx-ocboot-ha-test     <none>           <none>
onecloud-minio        minio-3                                              1/1     Running   0          3h10m   10.40.99.206     lzx-ocboot-ha-test     <none>           <none>
onecloud-monitoring   monitor-kube-state-metrics-6c97499758-w69tz          1/1     Running   0          3h6m    10.40.99.214     lzx-ocboot-ha-test     <none>           <none>
onecloud-monitoring   monitor-loki-0                                       1/1     Running   0          3h6m    10.40.99.213     lzx-ocboot-ha-test     <none>           <none>
onecloud-monitoring   monitor-minio-0                                      1/1     Running   0          3h7m    10.40.99.211     lzx-ocboot-ha-test     <none>           <none>
onecloud-monitoring   monitor-minio-3                                      1/1     Running   0          3h7m    10.40.99.212     lzx-ocboot-ha-test     <none>           <none>
onecloud-monitoring   monitor-monitor-stack-operator-54d8c46577-qknws      1/1     Running   0          3h6m    10.40.99.216     lzx-ocboot-ha-test     <none>           <none>
onecloud-monitoring   monitor-promtail-4mx2s                               1/1     Running   0          3h6m    10.40.99.215     lzx-ocboot-ha-test     <none>           <none>
onecloud              default-etcd-7brtldv78z                              1/1     Running   0          3h10m   10.40.99.207     lzx-ocboot-ha-test     <none>           <none>
onecloud              default-glance-6fd697b7b9-nbk9t                      1/1     Running   0          3h7m    10.40.99.208     lzx-ocboot-ha-test     <none>           <none>
onecloud              default-host-5rmg8                                   3/3     Running   7          3h34m   10.127.100.234   lzx-ocboot-ha-test     <none>           <none>
onecloud              default-host-deployer-sf494                          1/1     Running   7          3h34m   10.40.99.202     lzx-ocboot-ha-test     <none>           <none>
onecloud              default-host-image-s6pwq                             1/1     Running   2          3h34m   10.127.100.234   lzx-ocboot-ha-test     <none>           <none>
onecloud              default-region-dns-2hcpv                             1/1     Running   1          3h34m   10.127.100.234   lzx-ocboot-ha-test     <none>           <none>
onecloud              default-telegraf-5jn4x                               2/2     Running   0          3h34m   10.127.100.234   lzx-ocboot-ha-test     <none>           <none>
onecloud              default-influxdb-6bqgq                               1/1     Running   0          3h34m   10.127.99.218    lzx-ocboot-ha-test     <none>           <none>
```

通过上面命令的结果，可以筛选出 onecloud-minio/{minio-0,minio-3}，onecloud/default-influxdb，onecloud-monitoring/{monitor-minio-0,monitor-minio-3} 这些有状态的 pod 在 primary_master_node 上。

#### 2. 接下来将 primary_master_node 关机踢出集群

```bash
# 登录其它两个 master_node 节点，比如：10.127.100.229
$ ssh root@10.127.100.229

# 设置 KUBECONFIG 配置
[root@lzx-ocboot-ha-test-2 ~]$ export KUBECONFIG=/etc/kubernetes/admin.conf

# 查看节点状态，发现 primary_master_node 已经变成 NotReady
[root@lzx-ocboot-ha-test-2 ~]$ kubectl get nodes
NAME                   STATUS     ROLES    AGE     VERSION
lzx-ocboot-ha-test     NotReady   master   4h37m   v1.15.12
lzx-ocboot-ha-test-2   Ready      master   3h58m   v1.15.12
lzx-ocboot-ha-test-3   Ready      master   3h57m   v1.15.12

# 删除 primary_master_node 节点：lzx-ocboot-ha-test
[root@lzx-ocboot-ha-test-2 ~]$ kubectl drain --delete-local-data --ignore-daemonsets lzx-ocboot-ha-test
WARNING: ignoring DaemonSet-managed Pods: kube-system/calico-node-fdzql, kube-system/kube-proxy-nfxvd, kube-system/traefik-ingress-controller-jms9v, onecloud-monitoring/monitor-promtail-4mx2s, onecloud/default-host-5rmg8, onecloud/default-host-deployer-sf494, onecloud/default-host-image-s6pwq, onecloud/default-region-dns-2hcpv, onecloud/default-telegraf-5jn4x
evicting pod "minio-0"
evicting pod "monitor-minio-3"
evicting pod "default-etcd-7brtldv78z"
evicting pod "monitor-kube-state-metrics-6c97499758-w69tz"
evicting pod "default-influxdb-85945647d5-6bqgq"
evicting pod "default-glance-6fd697b7b9-nbk9t"
evicting pod "minio-3"
evicting pod "monitor-monitor-stack-operator-54d8c46577-qknws"
evicting pod "monitor-loki-0"
evicting pod "monitor-minio-0"
# 该命令会卡停住，因为 primary_master_node 已经关机了，无法删除 pod ，这个时候 'Ctrl-c' 取消命令
^C

# 使用 kubectl delete node 直接删除 primary_master_node 节点
$ kubectl delete node lzx-ocboot-ha-test

# 然后再查看处于 Pending 状态的 pod 全部都是之前 primary_master_node 上面有状态的 pod
# 因为这些 pod 使用了 local-path 的 pvc ，这些 pvc 是和节点强绑定的，还存在集群中
[root@lzx-ocboot-ha-test-2 ~]$ kubectl get pods -A | grep Pending
onecloud-minio        minio-0                                              0/1     Pending            0          61s
onecloud-minio        minio-3                                              0/1     Pending            0          61s
onecloud-monitoring   monitor-minio-0                                      0/1     Pending            0          61s
onecloud-monitoring   monitor-minio-3                                      0/1     Pending            0          61s
onecloud              default-influxdb-85945647d5-x5sv5                    0/1     Pending            0          10m
```

#### 3. 删除旧的 primary_master_node 的 etcd endpoint

```bash
# 查看 kube-system 系统下的 etcd pod
[root@lzx-ocboot-ha-test-2 ~]$ kubectl get pods -n kube-system | grep etcd
etcd-lzx-ocboot-ha-test-2                      1/1     Running            1          4h52m
etcd-lzx-ocboot-ha-test-3                      1/1     Running            1          4h51m

# 进入 etcd-lzx-ocboot-ha-test-2 etcd pod
[root@lzx-ocboot-ha-test-2 ~]# kubectl exec -ti -n kube-system  etcd-lzx-ocboot-ha-test-2 sh

# 使用 etcdctl 查看 member list
$ etcdctl --endpoints https://127.0.0.1:2379 --cacert /etc/kubernetes/pki/etcd/ca.crt --cert /etc/kubernetes/pki/etcd/server.crt --key /etc/kubernetes/pki/etcd/server.key member list
# 会发现旧的 primary_master_node member lzx-ocboot-ha-test 还在 etcd 集群
14da7b338b44eee0, started, lzx-ocboot-ha-test, https://10.127.100.234:2380, https://10.127.100.234:2379, false
454ae6f931376261, started, lzx-ocboot-ha-test-2, https://10.127.100.229:2380, https://10.127.100.229:2379, false
5afd19948b9009f6, started, lzx-ocboot-ha-test-3, https://10.127.100.226:2380, https://10.127.100.226:2379, false

# 删除 lzx-ocboot-ha-test member
$ etcdctl --endpoints https://127.0.0.1:2379 --cacert /etc/kubernetes/pki/etcd/ca.crt --cert /etc/kubernetes/pki/etcd/server.crt --key /etc/kubernetes/pki/etcd/server.key member remove 14da7b338b44eee0
```

#### 4. 替换旧的 primary_master_node 节点，加入新的 master_node

旧的 primary_master_node 节点已经被删掉，会发现 keepalived 的 vip 也漂移到了 master_node_1 上：

```bash
# 查看 vip 为 10.127.100.102
# 如果该节点运行了云平台 host 服务，ip 会绑定到 br0 上
[root@lzx-ocboot-ha-test-2 ~]$ ip addr show br0
32: br0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNOWN group default qlen 1000
    link/ether 00:22:96:6f:6e:f1 brd ff:ff:ff:ff:ff:ff
    inet 10.127.100.229/24 brd 10.127.100.255 scope global br0
       valid_lft forever preferred_lft forever
    inet 10.127.100.102/32 scope global br0
       valid_lft forever preferred_lft forever
    inet6 fe80::222:96ff:fe6f:6ef1/64 scope link 
       valid_lft forever preferred_lft forever

# 查看 /etc/kubernetes/manifests/keepalived.yaml env 配置
[root@lzx-ocboot-ha-test-2 ~]$ cat /etc/kubernetes/manifests/keepalived.yaml | | grep -A 15 env
    env:
    # 对应 keepalived 的权重，除了 primary_master_node 的 keepalived 会设置 100，其余 master_node 上面的都是 90
    - name: KEEPALIVED_PRIORITY
      value: "90"
    # 设置的 VIP
    - name: KEEPALIVED_VIRTUAL_IPS
      value: '#PYTHON2BASH:[''10.127.100.102'']'
    # 是 BACKUP 角色
    - name: KEEPALIVED_STATE
      value: BACKUP
    # 密码
    - name: KEEPALIVED_PASSWORD
      value: de17f785
    # router id
    - name: KEEPALIVED_ROUTER_ID
      value: "12"
    # 改节点网卡实际 ip
    - name: KEEPALIVED_NODE_IP
      value: 10.127.100.229
    # keepalived 绑定的网卡
    - name: KEEPALIVED_INTERFACE
      value: eth0
    image: registry.cn-beijing.aliyuncs.com/yunionio/keepalived:v2.0.25

# 查看集群当前只有 2 个节点
[root@lzx-ocboot-ha-test-2 ocboot]$ kubectl get nodes -o wide
NAME                   STATUS   ROLES    AGE     VERSION    INTERNAL-IP      EXTERNAL-IP   OS-IMAGE                KERNEL-VERSION                          CONTAINER-RUNTIME
lzx-ocboot-ha-test-2   Ready    master   4h29m   v1.15.12   10.127.100.229   <none>        CentOS Linux 7 (Core)   3.10.0-1160.6.1.el7.yn20201125.x86_64   docker://20.10.5
lzx-ocboot-ha-test-3   Ready    master   4h28m   v1.15.12   10.127.100.226   <none>        CentOS Linux 7 (Core)   3.10.0-1160.6.1.el7.yn20201125.x86_64   docker://20.10.5
```

现在使用 ocboot 加入新的节点，编辑 ocboot yaml 配置：

- 把当前的 lzx-ocboot-ha-test-2 这个节点当做 primary_master_node
- 需要新加入 master_node 节点信息：
  - IP: 10.127.100.224
  - Name: lzx-ocboot-ha-test-4

因为旧的 primary_master_node 已经被删除了，又把当前的 master_node_1 当做新集群的 primary_master_node，现在的配置变成下面这样:

```yaml
$ cat config-new-k8s-ha.yaml
primary_master_node:
  # 这里把之前的 master_node_1 10.127.100.229 当做 primary_master_node
  hostname: 10.127.100.229
  use_local: false
  user: root
  onecloud_version: "v3.8.8"
  # 数据库连接信息，根据自己的环境填写
  db_host: 10.127.100.101
  db_user: "root"
  db_password: "0neC1oudDB#"
  db_port: "3306"
  image_repository: registry.cn-beijing.aliyuncs.com/yunionio
  ha_using_local_registry: false
  node_ip: "10.127.100.229"
  # keepalived 暴露出去的 vip
  controlplane_host: 10.127.100.102
  controlplane_port: "6443"
  as_host: true
  # 启用 ha ，默认部署 keepavlied
  high_availability: true
  use_ee: false
  # 高可用使用 minio
  enable_minio: true
  host_networks: "eth0/br0/10.127.100.229"

master_nodes:
  # 加入到 10.127.100.102 vip 的 k8s 集群
  controlplane_host: 10.127.100.102
  controlplane_port: "6443"
  # 运行云平台控制相关组件
  as_controller: true
  # 作为云平台私有云宿主机计算节点
  as_host: true
  # 启用 keepavlied
  high_availability: true
  hosts:
  - user: root
    hostname: "10.127.100.224"
    host_networks: "eth0/br0/10.127.100.224"
```

写好配置后，使用 ocboot 加入新节点：

```bash
# 下载 ocboot 部署工具代码
$ git clone -b {{<release_branch>}} https://github.com/yunionio/ocboot && cd ocboot

# 开始加入节点
$ ./run.py config-new-k8s-ha.yaml
```

等到 ocboot 的 ./run.py 运行完成后，再查看 node 信息，发现新的节点 lzx-ocboot-ha-test-4(10.127.100.224) 已经加入进来：

```bash
[root@lzx-ocboot-ha-test-2 ~]$ kubectl get nodes -o wide
NAME                   STATUS   ROLES    AGE     VERSION    INTERNAL-IP      EXTERNAL-IP   OS-IMAGE                KERNEL-VERSION                          CONTAINER-RUNTIME
lzx-ocboot-ha-test-2   Ready    master   5h13m   v1.15.12   10.127.100.229   <none>        CentOS Linux 7 (Core)   3.10.0-1160.6.1.el7.yn20201125.x86_64   docker://20.10.5
lzx-ocboot-ha-test-3   Ready    master   5h12m   v1.15.12   10.127.100.226   <none>        CentOS Linux 7 (Core)   3.10.0-1160.6.1.el7.yn20201125.x86_64   docker://20.10.5
lzx-ocboot-ha-test-4   Ready    master   10m     v1.15.12   10.127.100.224   <none>        CentOS Linux 7 (Core)   3.10.0-1160.6.1.el7.yn20201125.x86_64   docker://20.10.5
```

修改新的 primary_master_node keepalived 的权重和角色

```bash
[root@lzx-ocboot-ha-test-2 ~]$ vim /etc/kubernetes/manifests/keepalived.yaml
...
    # 把权重改成 100
    - name: KEEPALIVED_PRIORITY
      value: "100"
...
    # 把角色改成 MASTER
    - name: KEEPALIVED_STATE
      value: MASTER
```

#### 5. 恢复有状态的 pod

新的 master 节点加入后，会发现原来的有状态 pod 还是 Pending，接下来就需要删除旧的 pvc ，把它们启动到新的 master 节点上。

```bash
# 查看 Pending 状态的 pod
[root@lzx-ocboot-ha-test-2 ~]$ kubectl get pods -A | grep Pending
onecloud-minio        minio-0                                              0/1     Pending   0          74m
onecloud-minio        minio-3                                              0/1     Pending   0          74m
onecloud-monitoring   monitor-minio-0                                      0/1     Pending   0          74m
onecloud-monitoring   monitor-minio-3                                      0/1     Pending   0          74m
onecloud              default-influxdb-85945647d5-x5sv5                    0/1     Pending   0          84m

# 把现在的 primary_master_node 和旧的 master_node 先禁止调度，这样可以保证后面的有状态 pod 创建到新的 master 节点上
# 保证 minio 多副本打散到不同的 master 节点
[root@lzx-ocboot-ha-test-2 ~]$ kubectl cordon lzx-ocboot-ha-test-2 lzx-ocboot-ha-test-3
```

首先恢复 onecloud-minio 里面的 minio statefulset 组件，因为里面存储了 glance 依赖的镜像，通过之前的命令发现 onecloud-minio namespace 里面的 minio-0 和 minio-3 是 Pending 状态，接下来删除它们依赖的 pvc ，然后 pod 就会重启到新的 master_node 节点上，操作如下：

```bash
# 找到对应的 pvc
[root@lzx-ocboot-ha-test-2 ~]$ kubectl get pvc -n onecloud-minio  | egrep 'minio-0|minio-3'
export-minio-0   Bound    pvc-297ed5e5-66c8-4855-8031-c65a0ccfa4d0   1Ti        RWO            local-path     4h55m
export-minio-3   Bound    pvc-3dd54509-7745-47dd-84ea-fbacfe1e2f5b   1Ti        RWO            local-path     4h55m

# 删除 pvc
[root@lzx-ocboot-ha-test-2 ~]$ kubectl delete pvc -n onecloud-minio export-minio-0 export-minio-3

# 删除 pod
[root@lzx-ocboot-ha-test-2 ~]$ kubectl delete pods -n onecloud-minio minio-0 minio-3

# 查看新创建启动 minio-0 和 minio-3 ，已经启动到新的 node lzx-ocboot-ha-test-4 上
[root@lzx-ocboot-ha-test-2 ~]$ kubectl get pods -n onecloud-minio  -o wide
NAME      READY   STATUS    RESTARTS   AGE    IP              NODE                   NOMINATED NODE   READINESS GATES
minio-0   1/1     Running   0          7s     10.40.103.200   lzx-ocboot-ha-test-4   <none>           <none>
minio-1   1/1     Running   0          5h1m   10.40.158.215   lzx-ocboot-ha-test-3   <none>           <none>
minio-2   1/1     Running   0          5h1m   10.40.159.22    lzx-ocboot-ha-test-2   <none>           <none>
minio-3   1/1     Running   0          14s    10.40.103.199   lzx-ocboot-ha-test-4   <none>           <none>

# 查看 minio-3 的日志，发现已经自愈完毕
[root@lzx-ocboot-ha-test-2 ~]$ kubectl logs  -n onecloud-minio minio-3
....
Healing disk '/export' on 1st pool
Healing disk '/export' on 1st pool complete
Summary:
{
  "ID": "0e5c1947-44f0-4f8a-b7f0-e3a55f441d6f",
  "PoolIndex": 0,
  "SetIndex": 0,
  "DiskIndex": 3,
  "Path": "/export",
  "Endpoint": "http://minio-3.minio-svc.onecloud-minio.svc.cluster.local:9000/export",
  "Started": "2022-04-13T06:49:29.882069559Z",
  "LastUpdate": "2022-04-13T06:49:59.564158167Z",
  "ObjectsHealed": 10,
  "ObjectsFailed": 0,
  "BytesDone": 1756978429,
  "BytesFailed": 0,
  "QueuedBuckets": [],
  "HealedBuckets": [
    ".minio.sys/config",
    ".minio.sys/buckets",
    "onecloud-images"
  ]
}
...

# 也可以登录到 lzx-ocboot-ha-test-4 上，查看 local-path csi 里面的 minio onecloud-images bucket 里面有没有对应的镜像 parts
$ ssh root@10.127.100.224

# 进入对应的 pvc 目录，目录名可以使用 kubectl get pvc -n onecloud-minio | grep minio-3 获得
[root@lzx-ocboot-ha-test-4 ~]$ cd /opt/local-path-provisioner/pvc-352277cb-e69d-41bf-b58a-d65cb1e4e6f8/
[root@lzx-ocboot-ha-test-4 pvc-352277cb-e69d-41bf-b58a-d65cb1e4e6f8]$ du -smh onecloud-images/
838M    onecloud-images/
```

然后使用恢复 onecloud-minio 相同的方法，恢复 monitor-minio 就可以，参考命令如下：

```bash
[root@lzx-ocboot-ha-test-2 ~]$ kubectl  delete pvc -n onecloud-monitoring export-monitor-minio-0 export-monitor-minio-3
persistentvolumeclaim "export-monitor-minio-0" deleted
persistentvolumeclaim "export-monitor-minio-3" deleted

[root@lzx-ocboot-ha-test-2 ~]$ kubectl  delete pods -n onecloud-monitoring monitor-minio-0 monitor-minio-3
pod "monitor-minio-0" deleted
pod "monitor-minio-3" deleted

[root@lzx-ocboot-ha-test-2 ~]$ kubectl get pods -n onecloud-monitoring  | grep minio
monitor-minio-0                                   1/1     Running   0          24s
monitor-minio-1                                   1/1     Running   0          5h17m
monitor-minio-2                                   1/1     Running   0          5h17m
monitor-minio-3                                   1/1     Running   0          24s
```

恢复 influxdb deployment，influxdb 和 minio 不太一样，minio 使用的 statefulset 管理，删掉 pod 和 pvc 后，k8s 会自动创建对应序号的 pod 和 pvc ，但是 deployment 不会，所以恢复 influxdb 的步骤是删掉 pvc，然后同时删掉 default-influxdb 这个 deployment ，我们的 onecloud-operator 组件就会新建对应的资源，步骤如下：

```bash
# 恢复 influxdb
[root@lzx-ocboot-ha-test-2 ~]# kubectl delete  pvc -n onecloud default-influxdb
[root@lzx-ocboot-ha-test-2 ~]# kubectl delete  deployment -n onecloud default-influxdb
[root@lzx-ocboot-ha-test-2 ~]# kubectl get pods -n onecloud | grep influxdb
default-influxdb-85945647d5-mdd2z                    1/1     Running            0          7m44s
```

现在所有在旧的 primary_master_node 上的组件都恢复，接下来把禁止调度的节点启用调度：

```bash
[root@lzx-ocboot-ha-test-2 ~]$ kubectl uncordon lzx-ocboot-ha-test-2 lzx-ocboot-ha-test-3
```
