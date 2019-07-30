---
title: "GPU相关"
date: 2019-07-19T18:32:40+08:00
weight: 40
---

目前仅支持 OneCloud kvm 虚拟机使用 GPU，使用的 PCI Passthrough 的方式将宿主机上的 Nvidia/AMD GPU 透传给虚拟机使用。

## 相关操作

### 创建 GPU 云主机

- 查询 gpu 列表

```bash
$ climc isolated-device-list --gpu
+--------------------------------------+----------+---------------------+---------+------------------+--------------------------------------+
|                  ID                  | Dev_type |        Model        |  Addr   | Vendor_device_id |               Host_id                |
+--------------------------------------+----------+---------------------+---------+------------------+--------------------------------------+
| 273f4f72-06b6-49aa-8456-4beceec44997 | GPU-HPC  | GeForce GTX 1050 Ti | 41:00.0 | 10de:1c82        | 3bce9607-2597-469f-8d9b-977345456739 |
| a77333e9-08d9-45c6-87eb-a7d8d902c5f5 | GPU-HPC  | Quadro FX 580       | 05:00.0 | 10de:0659        | 3bce9607-2597-469f-8d9b-977345456739 |
+--------------------------------------+----------+---------------------+---------+------------------+--------------------------------------+
```

- 创建 server

server-create 中的 `--isolated-device` 参数指定透传的设备到云主机，可以重复使用多次，透传多个 gpu 到云主机，但要求透传到同一云主机的 gpu 必须在同一宿主机。其余创建参数和创建普通云主机是一样的。

```bash
$ climc server-create --hypervisor kvm --isolated-device 273f4f72-06b6-49aa-8456-4beceec44997 ...
```

### 查询 GPU 云主机

```bash
$ climc server-list --gpu
```

### 关联 GPU

如果云主机所在的宿主机有可用的 gpu，在主机关机的情况下，可以通过 `server-attach-isolated-device` 命令将 gpu 和云主机关联起来，下次主机启动后就可以使用该 gpu 。

```bash
$ climc server-attach-isolated-device <server_id> <device_id>
```

### 卸载 GPU

如果云主机关联了 gpu，可以通过 `server-detach-isolated-device` 卸载主机的某一 gpu。

```bash
$ climc server-detach-isolated-device <server_id> <device_id>
```
