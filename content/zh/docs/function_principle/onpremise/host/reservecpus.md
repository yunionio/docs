---
title: "宿主机 CPU 预留"
weight: 5
oem_ignore: true
description: > 
  预留宿主机上的 CPU 给非虚拟机进程使用
---

## 功能介绍

  宿主机 CPU 预留功能支持将部分 CPU 预留给其他进程使用，不再分配给虚拟机使用。

## 使用介绍

  确保这台宿主机上没有运行中的虚机，然后选择合适的 CPU 作为预留 CPU。宿主机 hostagent 初始化时会创建 cloudpods.hostagent.reserved 的 cgroup。

```bash
$ climc host-reserve-cpus --help
Usage: climc host-reserve-cpus [--mems MEMS] [--disable-sched-load-balance] [--help] [--cpus CPUS] <ID> ...

# 三个参数
# --cpus 对应的是 cpuset.cpus: 限制进程组使用的 CPU。
# --mems 对应的是 cpuset.mems, 限制可以使用的memory节点。
# --disable-sched-load-balance 对应 cpuset.sched_load_balance flag，关闭预留 cpuset 内的 cpu balance。
$ climc host-reserve-cpus  --mems 0-1 --disable-sched-load-balance --cpus "1-2,38-39" 3bce9607-2597-469f-8d9b-977345456739

# 宿主机上查看
$ cat /sys/fs/cgroup/cpuset/cloudpods.hostagent.reserved/cpuset.cpus
1-2,38-39
$ cat /sys/fs/cgroup/cpuset/cloudpods.hostagent.reserved/cpuset.mems
0-1
$ cat /sys/fs/cgroup/cpuset/cloudpods.hostagent.reserved/cpuset.sched_load_balance
0
```
