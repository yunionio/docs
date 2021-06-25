---
title: "使用 Cgroups 限制 Kubernetes Pod 进程数"
date: 2021-06-25
slug: cgroups-kubernetes-pid-limits
---

**作者:** 李泽玺

Kubernetes 里面的 Pod 资源是最小的计算单元，抽象了一组（一个或多个）容器。容器也是 Linux 系统上的进程，但基于 Namespace 和 Cgroups(Control groups) 等技术实现了不同程度的隔离。
简单来说 Namespace 可以让每个进程有独立的 PID, IPC 和网络空间。Cgroups 可以控制进程的资源占用，比如 CPU ，内存和允许的最大进程数等等。 

今天主要介绍如何通过 Cgroups 里面的 pids 控制器限制 Kubernetes Pod 容器的最大进程数量。

## 场景介绍

之前遇到过这样一个问题，我们的服务会调用执行外部的命令，每调用一次外部命令就会 fork 产生子进程。但是由于代码上的 bug ，没有及时对子进程回收，然后这个容器不断 fork 产生子进程，耗尽了宿主机的进程表空间，最终导致整个系统不响应，影响了其它的服务。

这种问题除了让开发人员修复 bug 外，也需要在系统层面对进程数量进行限制。所以，如果一个容器里面运行的服务会 fork 产生子进程，就很有必要使用 Cgroups 的 pids 控制器限制这个容器能运行的最大进程数量。

## 解决方法

### Kubelet 开启 PodPidsLimit 功能

Kubernetes 里面的每个节点都会运行一个叫做 Kubelet 的服务，负责节点上容器的状态和生命周期，比如创建和删除容器。根据 Kubernetes 的官方文档 [Process ID Limits And Reservations][1] 内容，可以设置 Kubelet 服务的 **--pod-max-pids** 配置选项，之后在该节点上创建的容器，最终都会使用 Cgroups pid 控制器限制容器的进程数量。

我们 Kubernetes 是在 CentOS 7 上使用 kubeadm 部署的 v1.15.9 版本，需要额外设置 **SupportPodPidsLimit** 的 feature-gate，对应操作如下（其它发行版应该也类似）：

```bash
# kubelet 使用 systemd 启动的，可以通过编辑 /etc/sysconfig/kubelet
# 添加额外的启动参数，设置 pod 最大进程数为 1024
$ vim /etc/sysconfig/kubelet
KUBELET_EXTRA_ARGS="--pod-max-pids=1024 --feature-gates=\"SupportPodPidsLimit=true\""

# 重启 kubelet 服务
$ systemctl restart kubelet

# 查看参数是否生效
$ ps faux | grep kubelet | grep pod-max-pids
root     104865 10.5  0.6 1731392 107368 ?      Ssl  11:56   0:30 /usr/bin/kubelet ... --pod-max-pids=10 --feature-gates=SupportPodPidsLimit=true
```

### 验证 PodPidsLimit

通过配置 Kubelet 的 **--pod-max-pids=1024** 选项，限制了一个容器内允许的最大进程数为 1024 个。现在来测试下如果容器内不断 fork 子进程，数目到达 1024 个时会触发什么行为。

参考 [Fork bomb][2] 的内容，可以创建一个 pod，不断 fork 子进程。

```bash
# 创建普通的 nginx pod yaml
$ cat <<EOF > test-nginx.yaml
apiVersion: v1
kind: Pod
metadata:
  name: test-nginx
spec:
  containers:
  - name: nginx
    image: nginx
EOF

# 创建到 Kubernetes 集群
$ kubectl apply -f test-nginx.yaml

# 进入 nginx 容器模拟 fork bomb 
$ kubectl exec -ti test-nginx bash
root@test-nginx:/# bash -c "fork() { fork | fork &  }; fork"
environment: fork: retry: Resource temporarily unavailable
environment: fork: retry: Resource temporarily unavailable
environment: fork: retry: Resource temporarily unavailable
```

通过进入一个 nginx 容器里面使用 bash 运行 fork bomb 命令，我们会发现当 fork 的子进程达到限制的上限数目后，会报 **retry: Resource temporarily unavailable** 的错误，这个时候再看下宿主机的 fork 进程数目。

```bash
# 通过在外部宿主机执行下面的命令，会发现 fork 的进程数目接近 1024 个
$ ps faux | grep fork | wc -l
1019
```

通过以上的实验，发现能够通过设置 Kubelet 的 **--pod-max-pids** 选项，限制容器类的进程数，避免容器进程数不断上升最终耗尽宿主机资源，拖垮整个宿主机系统。

## 原理实现

通过之前描述的解决方法，已经能够限制容器的进程数了。

现在从代码的层面看下 Kubelet 如何设置 Cgroups pids 控制器。

### Kubelet 代码调用

首先来看下 Kubelet 代码里面 **--pod-max-pids** 是怎么生效的，Kubernetes 的版本为 v1.15.9。

**--pid-max-pids** 选项是在 `cmd/kubelet/app/options/options.go` 里面的 `AddKubeletConfigFlags` 函数设置的，对应代码如下。

```golang
// cmd/kubelet/app/options/options.go
func AddKubeletConfigFlags(mainfs *pflag.FlagSet, c *kubeletconfig.KubeletConfiguration) {
...
    // 这里定义了 '--pod-max-pids' 的选项
    // 对应参数的值通过命令行解析到 kubeletconfig.KubeletConfiguration.PodPidsLimit 里面
    fs.Int64Var(&c.PodPidsLimit, "pod-max-pids", c.PodPidsLimit, "Set the maximum number of processes per pod.  If -1, the kubelet defaults to the node allocatable pid capacity.")
...
}
```

`PodPidsLimit` 配置参数解析完成后，kubelet 会在启动的时候把值设置到 ContainerManager 里面，对应代码在 `cmd/kubelet/app/server.go` 里面的 `run` 函数，注释如下。

```golang
// cmd/kubelet/app/server.go
func run(s *options.KubeletServer, kubeDeps *kubelet.Dependencies, stopCh <-chan struct{}) (err error) {
...
        kubeDeps.ContainerManager, err = cm.NewContainerManager(
            ...
            cm.NodeConfig{
                ...
                // 容器 runtime，默认使用 docker
                ContainerRuntime:      s.ContainerRuntime,
                // 使用 Cgroups 控制 pod 的服务质量
                CgroupsPerQOS:         s.CgroupsPerQOS,
                // 操作 Cgroups 的驱动，有 cgroupfs 和 systemd 两种
                // 我们默认配置使用 systemd 来控制 Cgroups
                CgroupDriver:          s.CgroupDriver,
                ...
                // 这里就是 PodPidsLimit 的设置了，通过刚才 options 的解析
                // 赋值到了 ContainerManager.ExperimentalPodPidsLimit 属性
                ExperimentalPodPidsLimit:              s.PodPidsLimit,
                // 限制容器 CPU 使用率的参数
                EnforceCPULimits:                      s.CPUCFSQuota,
                CPUCFSQuotaPeriod:                     s.CPUCFSQuotaPeriod.Duration,
            },
            ...
            ...)
...
}
```

初始化 ContainerManager 后，会在 `pkg/kubelet/cm/container_manager_linux.go` 里面调用 `NewPodContainerManager` 创建 PodContainerManager，代码如下。

```golang
// pkg/kubelet/cm/container_manager_linux.go
...
func (cm *containerManagerImpl) NewPodContainerManager() PodContainerManager {
    // 默认情况下已经打开了 CgroupsPerQOS 的选项
    if cm.NodeConfig.CgroupsPerQOS {
        // 这里返回 PodContainerManager 接口的实现
        return &podContainerManagerImpl{
            qosContainersInfo: cm.GetQOSContainersInfo(),
            subsystems:        cm.subsystems,
            cgroupManager:     cm.cgroupManager,
            // 这里设置 podPidsLimit
            podPidsLimit:      cm.ExperimentalPodPidsLimit,
            enforceCPULimits:  cm.EnforceCPULimits,
            cpuCFSQuotaPeriod: uint64(cm.CPUCFSQuotaPeriod / time.Microsecond),
        }
    }
    return &podContainerManagerNoop{
        cgroupRoot: cm.cgroupRoot,
    }
}
...
```

从之前的代码能发现 PodContainerManager 是一个接口，对应的实现在 `pkg/kubelet/cm/pod_container_manager_linux.go` 里面，与 Cgroup 相关的函数则是 `podContainerManagerImpl.EnsureExists` 函数。

```golang
// pkg/kubelet/cm/pod_container_manager_linux.go
...
// podContainerManagerImpl 就是实现 PodContainerManager 接口的结构体
// EnsureExists 会根据 api 里面 Pod 的定义，在当前系统创建对应容器的 cgroup 配置
func (m *podContainerManagerImpl) EnsureExists(pod *v1.Pod) error {
    // podContainerName 也会作为 cgroup name，根据 pod 的 QOS 级别和 UUID 生成
    // 查看容器是否存在
    alreadyExists := m.Exists(pod)                                                                                  
    if !alreadyExists {
        // 创建 pod 对应容器的 cgroup
        containerConfig := &CgroupConfig{
            Name:               podContainerName,
            ResourceParameters: ResourceConfigForPod(pod, m.enforceCPULimits, m.cpuCFSQuotaPeriod),
        }
        // 如果启用了 SupportPodPidsLimit feature-gate ，并且 podPidsLimit 大于 0
        if utilfeature.DefaultFeatureGate.Enabled(kubefeatures.SupportPodPidsLimit) && m.podPidsLimit > 0 {
            // 这里就会配置 PidsLimit
            containerConfig.ResourceParameters.PidsLimit = &m.podPidsLimit
        }
        // 调用 cgroupManager 根据 containerConfig 创建对应的 cgroup
        if err := m.cgroupManager.Create(containerConfig); err != nil {
            return fmt.Errorf("failed to create container for %v : %v", podContainerName, err)
        }
    }
    ...
    return nil
}
...
```

接下来看 cgroupManager.Create 函数的实现，对应代码实现在 `pkg/kubelet/cm/cgroup_manager_linux.go` 里面的 `cgroupManagerImpl.Create`。

```golang
...
func (m *cgroupManagerImpl) Create(cgroupConfig *CgroupConfig) error {
...
    resources := m.toResources(cgroupConfig.ResourceParameters)
    libcontainerCgroupConfig := &libcontainerconfigs.Cgroup{
        Resources: resources,
    }
    // libcontainer consumes a different field and expects a different syntax
    // depending on the cgroup driver in use, so we need this conditional here.
    if m.adapter.cgroupManagerType == libcontainerSystemd {
        // 我们使用 systemd 管理 cgroup ，所以这里会更新下 systemd 对应 cgroup 的配置
        updateSystemdCgroupInfo(libcontainerCgroupConfig, cgroupConfig.Name)
    } else {
        libcontainerCgroupConfig.Path = cgroupConfig.Name.ToCgroupfs()
    }

    if utilfeature.DefaultFeatureGate.Enabled(kubefeatures.SupportPodPidsLimit) && cgroupConfig.ResourceParameters != nil && cgroupConfig.ResourceParameters.PidsLimit != nil {
        // 设置 libcontainerCgroupConfig 里面的 PidsLimit
        // 这里 PidsLimit 就是一开始参数指定的 --pod-max-pids 的值
        libcontainerCgroupConfig.PidsLimit = *cgroupConfig.ResourceParameters.PidsLimit
    }

    // 这里根据 cgroup 的配置返回 libcontainercgroups.Manager 接口的实现
    // 这里的实现是 systemd 的实现
    manager, err := m.adapter.newManager(libcontainerCgroupConfig, nil)
    if err != nil {
        return err
    }

    // 调用 libcontainer 里面的 cgroups manager Apply 接口把 pod 的 cgroup 配置应用到系统
    // 在我们的环境中，这个 Apply 函数会由 libcontainer/cgroupfs/systemd.Manager 实现
    if err := manager.Apply(-1); err != nil {
        return err
    }
    ...

    return nil
}
...
```

在看下最后的 `Apply` 函数，该函数会调用到 `vendor/github.com/opencontainers/runc/libcontainer/cgroups/systemd/apply_systemd.go` 里面的 systemd 实现。

```golang
// vendor/github.com/opencontainers/runc/libcontainer/cgroups/systemd/apply_systemd.go
...
func (m *Manager) Apply(pid int) error {
    // 初始化 systemd cgroup 需要的一些变量
    var (
        c          = m.Cgroups
        // systemd unit name
        unitName   = getUnitName(c)
        slice      = "system.slice"
        // systemd unit 里面的配置属性
        properties []systemdDbus.Property
    )
...
    // Always enable accounting, this gets us the same behaviour as the fs implementation,
    // plus the kernel has some problems with joining the memory cgroup at a later time.
    properties = append(properties,
        newProp("MemoryAccounting", true),
        newProp("CPUAccounting", true),
        newProp("BlockIOAccounting", true))
    ...
    if c.Resources.Memory != 0 {
        // 设置 cgroup memory limit
        properties = append(properties,
            newProp("MemoryLimit", uint64(c.Resources.Memory)))
    }

    if c.Resources.CpuShares != 0 {
        // 设置 cgroup cpu shares
        properties = append(properties,
            newProp("CPUShares", c.Resources.CpuShares))
    }
...
    if c.Resources.BlkioWeight != 0 {
        // 设置 cgroup block io weight
        properties = append(properties,
            newProp("BlockIOWeight", uint64(c.Resources.BlkioWeight)))
    }

    if c.Resources.PidsLimit > 0 {
        // 这里设置了本文关注的 PidsLimit 参数
        // 发现会对应 systemd 里面的 TasksAccounting 和 TasksMax 属性
        properties = append(properties,
            newProp("TasksAccounting", true),
            newProp("TasksMax", uint64(c.Resources.PidsLimit)))
    }
...
    // 通过 systemdDbus 根据之前的 cgroup 设置创建对应的 unit
    if _, err := theConn.StartTransientUnit(unitName, "replace", properties, statusChan); err == nil {
        ...
    }

    // 最后加入 Cgroups
    if err := joinCgroups(c, pid); err != nil {
        return err
    }
...
}
...
```

### Systemd Cgroup slice

通过对 Kubelet 调用 libcontainer，最后由 systemd 创建 pod 容器对应 cgroup unit 的代码调用分析，在这里看下对应 pod 的 systemd unit 配置。

从之前代码看，最终生成的 systemd unit 和 cgroup 和 pod 的 `uid` 和 `qosClass` 有关系，所以先通过以下的命令拿到 pod 的 `uid` 和 `qosClass`。

```bash
$ kubectl get pods test-nginx -o yaml | grep -E 'uid|qos'
  uid: 2ac1e32c-d8d6-4533-8eab-d04d60465065
  qosClass: BestEffort
```

然后找到对应的 systemd unit .slice 文件。

```bash
# uid 取前 8 位，qosClass 小写
# 找到对应的 kubepods-besteffort-pod2ac1e32c_d8d6_4533_8eab_d04d60465065.slice
$ systemctl | grep 2ac1e32c | grep besteffort
kubepods-besteffort-pod2ac1e32c_d8d6_4533_8eab_d04d60465065.slice      loaded active active    libcontainer container kubepods-besteffort-pod2ac1e32c_d8d6_4533_8eab_d04d60465065.slice

# 查看对应 slice 的配置
$ systemctl status kubepods-besteffort-pod2ac1e32c_d8d6_4533_8eab_d04d60465065.slice
● kubepods-besteffort-pod2ac1e32c_d8d6_4533_8eab_d04d60465065.slice - libcontainer container kubepods-besteffort-pod2ac1e32c_d8d6_4533_8eab_d04d60465065.slice
   Loaded: loaded (/run/systemd/system/kubepods-besteffort-pod2ac1e32c_d8d6_4533_8eab_d04d60465065.slice; static; vendor preset: disabled)
  Drop-In: /run/systemd/system/kubepods-besteffort-pod2ac1e32c_d8d6_4533_8eab_d04d60465065.slice.d
           └─50-BlockIOAccounting.conf, 50-CPUAccounting.conf, 50-CPUShares.conf, 50-DefaultDependencies.conf, 50-Delegate.conf, 50-Description.conf, 50-MemoryAccounting.conf, 50-TasksAccounting.conf, 50-TasksMax.conf, 50-Wants-kubepods-besteffort\x2eslice.conf
   Active: active since Fri 2021-06-25 16:21:25 CST; 7min ago
    Tasks: 6 (limit: 1024)
   Memory: 6.8M
   CGroup: /kubepods.slice/kubepods-besteffort.slice/kubepods-besteffort-pod2ac1e32c_d8d6_4533_8eab_d04d60465065.slice
           ├─docker-2d151786c9985db74632c09412207fa99755473fde93d09920604e097f25a2b7.scope
           │ ├─32662 nginx: master process nginx -g daemon off;
           │ ├─32703 nginx: worker process
           │ ├─32704 nginx: worker process
           │ ├─32705 nginx: worker process
           │ └─32706 nginx: worker process
           └─docker-966047566d9e90d9ef64126b605101c174d750ec0cde3d3a83c5b313c7af9a21.scope
             └─32544 /pause

Jun 25 16:21:25 centos7-oc-dev systemd[1]: Created slice libcontainer container kubepods-besteffort-pod2ac1e32c_d8d6_4533_8eab_d04d60465065.slice.

# 通过 systemctl status 能发现 50-TasksMax.conf 的文件
# 从之前的代码分析，发现 PodPidsLimit 会对应到 systemd 的 TasksMax 属性
# 现在在看下这个文件的内容
$ cat /run/systemd/system/kubepods-besteffort-pod2ac1e32c_d8d6_4533_8eab_d04d60465065.slice.d/50-TasksMax.conf
[Slice]
TasksMax=1024
# TasksMax 设置为了 1024 ，限制了这个进程最大子进程（Task）数量
```

### Cgroup FS

查看之前的 `vendor/github.com/opencontainers/runc/libcontainer/cgroups/systemd/apply_systemd.go` 代码，发现在创建完 pod 容器对应的 systemd cgroup slice 后，还会调用一次 `joinCgroups` 这个函数。这个函数会使用 Cgroup FS 原生的方法，在 `/sys/fs/cgroup` 里面创建对应 pod 容器的 group 。

所以再看下 Cgroup FS 里面 pod 设置 pid limit 的配置。

```bash
# 找到 Cgroup FS pids 控制器的挂载点
$ cgroup on /sys/fs/cgroup/pids type cgroup (rw,nosuid,nodev,noexec,relatime,pids)

# 看下 /sys/fs/cgroup/pids 目录下的文件
$ ls -alh /sys/fs/cgroup/pids
...
# 发现有一个由 Kubelet 创建的 kubepods.slice
drwxr-xr-x   4 root root   0 Jun 25 04:49 kubepods.slice
...

# 再通过查看 /sys/fs/cgroup/pids/kubepods.slice 目录
# 会发现 kubepods-besteffort.slice 和 kubepods-burstable.slice 两个目录
# 分别对应 pod 容器的 QOS 级别
$ ls -alh /sys/fs/cgroup/pids/kubepods.slice
...
drwxr-xr-x 42 root root 0 Jun 25 16:21 kubepods-besteffort.slice
drwxr-xr-x  8 root root 0 Jun 25 04:49 kubepods-burstable.slice
...

# 结合刚才的代码片段，也可以想到原生 Cgroup FS 的目录和 systemd 的应该是差不多的层级
# 现在直接用 find 命令查看 pids 控制器下面的 cgroup 设置
$ find /sys/fs/cgroup/pids/kubepods.slice -type f | grep pod2ac1e32c
...
# 能发现 pids.current 和 pids.max 两个 cgroup 的配置
# pids.current 表示当前 pod 里面的进程（Task）数量
/sys/fs/cgroup/pids/kubepods.slice/kubepods-besteffort.slice/kubepods-besteffort-pod2ac1e32c_d8d6_4533_8eab_d04d60465065.slice/pids.current
# pids.max 则表示 pod 里面能运行的进程（Task）上限
/sys/fs/cgroup/pids/kubepods.slice/kubepods-besteffort.slice/kubepods-besteffort-pod2ac1e32c_d8d6_4533_8eab_d04d60465065.slice/pids.max
...

# 查看 pod pids.max 设置，结果为 1024
$ cat /sys/fs/cgroup/pids/kubepods.slice/kubepods-besteffort.slice/kubepods-besteffort-pod2ac1e32c_d8d6_4533_8eab_d04d60465065.slice/pids.max
1024 
```

另外这篇内核文档 [Process Number Controller][3] 对 cgroup pids 控制器的使用进行了介绍，可以了解下。


[1]: https://kubernetes.io/docs/concepts/policy/pid-limiting/
[2]: https://en.wikipedia.org/wiki/Fork_bomb
[3]: https://www.kernel.org/doc/Documentation/cgroup-v1/pids.txt
