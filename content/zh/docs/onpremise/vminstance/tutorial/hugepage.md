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

使用透明大页支持比较方便，只需要设置 hugepages_option 为 transparent。但这种方式无法使用1G的大页，并且并不保证虚拟机总是使用大页内存。

## 开启native大页内存

下面介绍启用native大页的方法：

1、设置/etc/yunion/host.conf的hugepages_options 为native

2、预留大页内存

有两种方式: 自动和手动。

2.1 自动预留大页内存

重启宿主机，宿主机重启后，host服务会根据该宿主机的物理内存总量，减去预留内存量（mem_reserved），再减去kubelet Evition需要预留的内存（一般为500MB），剩下的内存预留。

自动预留大页内存只能预留2MB的大页。

2.2 手动预留大页内存

手动方式需修改内核启动参数，在系统启动时刻就把大页内存预留出来。这种方式能够保证大页内存的空间连续性，能够域1GB的大页。但是1GB的大页预留后将无法修改。如果采用手动预留大页内存，建议预留1GB的大页。

注意：使用1GB大页内存的虚拟机的内存必须是1GB的整数倍。

下面是手动预留1GB大页内存的步骤：

设置内核启动参数，让宿主机在启动后自动预留大页内存，需要设置如下两个参数：

* hugepagesz：大页内存的大小。对于x86_64的宿主机，一般支持2MB或1GB的大页。可以通过查看/proc/cpuinfo的flags判断宿主机支持哪种大页。如果flags中包含pse，则支持2MB大页。如果flags中包含pdpe1gb，则支持1GB大页。对于arm的宿主机，支持2MB或1GB的大页。推荐使用1GB大页。

* hugepages：预留大页的数量，总预留内存为 hugepagesz x hugepages。由于大页内存无法给操作系统使用，因此需要留足够的普通内存。一般是给操作系统预留至少10G，或10%的内存。

举例：

修改 /etc/default/grub，在GRUB_CMDLINE_LINUX末尾添加（宿主机有128GB内存，分配给大页110GB，给操作系统预留18GB内存）：

```bash
hugepagesz=1GB hugepages=110
```

然后执行

```bash
grub2-mkconfig -o /boot/grub2/grub.cfg（BIOS引导执行这个）

grub2-mkconfig -o /boot/efi/EFI/centos/grub.cfg（UEFI引导执行这个）
```

修改完成后，重启宿主机

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
