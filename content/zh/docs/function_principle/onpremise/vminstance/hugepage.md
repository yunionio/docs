---
title: "内存大页(Hugepage)"
weight: 50
description: >
  介绍如何在宿主机启用内存大页给虚拟机使用。
---

内置私有云支持虚拟机使用内存大页（Hugepage）。使用内存大页有助于减少内存碎片，提高虚拟机访问内存效率，从而提高虚拟机性能。

通过设置每台宿主机的配置(/etc/yunion/host.conf) hugepages_option 来关闭或开启大页，该选项的值有三个：

* disable: 不开启大页支持

* transparent：开启透明大页支持，该选项为默认选项。启用透明大页支持后，操作系统会尽力而为地为虚拟机使用大页内存，并且自动地将虚拟机的普通内存合并为大页内存。

* native：开启原生大页内存支持，这种模式需要显式地分配大页内存池，并且虚拟机使用的内存需要预先从大页内存池中预留分配，并作为参数传递给虚拟机使用。这种方式能够保证内存的连续性，可以分配1G的大页内存，提供最佳的性能。

使用透明大页支持比较方便，只需要设置 hugepages_option 为 transparent。但这种方式无法使用1G的大页，且并不保证虚拟机总是使用大页内存。

## 开启native大页内存

通过 ocboot 部署的环境默认会安装 `oc-hugetlb-gigantic-pages.service` 服务，可使用 `systemctl status oc-hugetlb-gigantic-pages.service` 查看

### 部署时开启大页

宿主机为 x86_64 架构非控制节点默认开启，且内存超过 30G时生效，预留内存为总内存的10%，最大预留20G内存。可修改 config.yaml 中 enable_hugepage 控制开启或者关闭大页内存
```
  as_host: true
  # 虚拟机强行作为 OneCloud 私有云计算节点（默认为 false）。开启此项时，请确保as_host: true
  as_host_on_vm: true
  # 是否宿主机开启大页内存(宿主机为 x86_64 架构非控制节点默认开启，且内存超过 30G 时生效，预留内存为总内存的20%，最大预留32G内存)
  enable_hugepage: true
```

### 部署完成后想开启大页
环境部署完成后想启用native大页：

1、设置/etc/yunion/host.conf的hugepages_options 为 native

2、重启宿主机

重启后，查看如下参数，确认1GB大页内存是否预留成功

```bash
$ cat /sys/kernel/mm/hugepages/hugepages-1048576kB/nr_hugepages
110
$ cat /sys/kernel/mm/hugepages/hugepages-1048576kB/free_hugepages
110
$ free -h
              total        used        free      shared  buff/cache   available
Mem:           125G        113G        7.6G        4.5M        4.5G         11G
Swap:            0B          0B          0B
```

### 配置预留内存

默认情况下预留内存是宿主机当前内存的 %10，最大不超过 20G，如果想要手动配置宿主机的预留内存，则可以通过设置 RESERVED_MEM 来配置。

```
[Unit]
Description=OC HugeTLB Gigantic Pages Reservation
DefaultDependencies=no
Before=dev-hugepages.mount
ConditionPathExists=/sys/kernel/mm/hugepages
ConditionKernelCommandLine=hugepagesz=1G

[Service]
Type=oneshot
RemainAfterExit=yes
# Environment="RESERVED_MEM=24" # 可配置的 RESERVED_MEM
ExecStart=/usr/lib/systemd/oc-hugetlb-reserve-pages.sh

[Install]
WantedBy=sysinit.targe
```


