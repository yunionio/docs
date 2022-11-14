---
title: "SR-IOV 网卡透传"
weight: 30
description: >
  介绍如何开启 SR-IOV 网卡透传与 climc 命令行使用
---

## SR-IOV 介绍

SR-IOV 技术是一种基于硬件的虚拟化解决方案，可提高性能和可伸缩性。SR-IOV 标准允许在虚拟机之间高效共享 PCIe（Peripheral Component Interconnect Express，快速外设组件互连）设备，并且它是在硬件中实现的，可以获得能够与本机性能媲美的 I/O 性能。SR-IOV 规范定义了新的标准，根据该标准，创建的新设备可允许将虚拟机直接连接到 I/O 设备。

SR-IOV 规范由 PCI-SIG 在 http://www.pcisig.com 上进行定义和维护。

SR-IOV 中的两种新功能类型是：

- 物理功能 (Physical Function, PF)
用于支持 SR-IOV 功能的 PCI 功能，如 SR-IOV 规范中定义。PF 包含 SR-IOV 功能结构，用于管理 SR-IOV 功能。PF 是全功能的 PCIe 功能，可以像其他任何 PCIe 设备一样进行发现、管理和处理。PF 拥有完全配置资源，可以用于配置或控制 PCIe 设备。

- 虚拟功能 (Virtual Function, VF)
与物理功能关联的一种功能。VF 是一种轻量级 PCIe 功能，可以与物理功能以及与同一物理功能关联的其他 VF 共享一个或多个物理资源。VF 仅允许拥有用于其自身行为的配置资源。


## 宿主机开启 SR-IOV

1. BIOS 中打开设备 SR-IOV 功能(根据机型和设备的型号不同，具体操作方式也可能不一样，具体参考实际机型配置)。
2. Intel VT-d 或 AMD IOMMU 已在系统的 BIOS 中启用。具体请参阅机器的 BIOS 配置菜单，或其它相关信息。
3. Intel VT-d 或 AMD IOMMU 已在操作系统中启用：
```bash
# 对应编辑 /etc/default/grub, 设置 GRUB_CMDLINE_LINUX=
$ cat /etc/default/grub
...
GRUB_CMDLINE_LINUX="intel_iommu=on iommu=pt vfio_iommu_type1.allow_unsafe_interrupts=1"
# 重新生成 grub 引导配置文件
$ grub2-mkconfig -o /boot/grub2/grub.cfg

# 将vfio相关 module 设置为开机load
$ cat /etc/modules-load.d/vfio.conf
vfio
vfio_iommu_type1
vfio_pci
vfio_virqfd
```
4. 在宿主机节点上打开 Virtual Functions
```bash
# 对于不同的网卡型号打开的方式也不一样，下面以 Intel I350 网卡为例，设置 7 个 Virtual Function(网卡支持的 virtual function 数量也是不一样的，需要根据具体网卡支持的数量来配置)
# 在 grub cmdline 中加上 igb.max_vfs=7
GRUB_CMDLINE_LINUX="...... igb.max_vfs=7"
# 重新生成 grub 引导配置文件
$ grub2-mkconfig -o /boot/grub2/grub.cfg
```
5. 设置好后重启宿主机，查看 /proc/cmdline 确认配置生效。

## host-agent 启用 SR-IOV
登陆到对应的宿主机节点
```bash
# SR-IOV 默认是不启用的，需要修改 host-agent 配置
$ vi /etc/yunion/host.conf
disable_sriov_nic: false

# 配置 SR-IOV 对应的网络 eg:
$ vi /etc/yunion/host.conf
networks:
- eth1/br0/192.168.100.111
- eth2/br1/bcast0
# 上面包含了两种配置方式，第一个参数是物理网卡名称，第二个参数是网桥名称，
# 第三个参数有两种，一种是 ip 地址，另外一种是 wire，对于不想配置 ip地址的网卡可以使用 wire 属性，wire 代表的是这个网卡所在的二层网络。
```

修改完成后重启 host-agent 服务: `kubectl rollout restart ds default-host`, 重启完成等待 host-agent 服务启动成功后可以在控制节点使用 climc 查看配置的 VF 网卡.

eg:
```
# 例如 I350 Ethernet Controller Virtual Function 就是我们本次配置的 VF 网卡。
$ climc isolated-device-list
+--------------------------------------+----------+-------------------------------------------+---------+------------------+--------------------------------------+--------------------------------------+
|                  ID                  | Dev_type |                   Model                   |  Addr   | Vendor_device_id |               Host_id                |               Guest_id               |
+--------------------------------------+----------+-------------------------------------------+---------+------------------+--------------------------------------+--------------------------------------+
| 37b2fe7b-f202-428e-8c34-35ccdac82852 | NIC      | ConnectX-5 Virtual Function               | 0a:01.1 | 15b3:1018        | c48b1b8b-28a3-453a-863f-ddf7c62bcfe2 |                                      |
| 9a0f2b3a-b372-4e37-840f-60427d026479 | NIC      | ConnectX-5 Virtual Function               | 0a:01.0 | 15b3:1018        | c48b1b8b-28a3-453a-863f-ddf7c62bcfe2 |                                      |
| 37b54017-4da3-44a6-8ffe-056ffc9e853b | NIC      | ConnectX-5 Virtual Function               | 0a:00.7 | 15b3:1018        | c48b1b8b-28a3-453a-863f-ddf7c62bcfe2 |                                      |
| 74558948-f5e9-453b-86d6-89c6bc00c710 | NIC      | ConnectX-5 Virtual Function               | 0a:00.6 | 15b3:1018        | c48b1b8b-28a3-453a-863f-ddf7c62bcfe2 |                                      |
| 75df24b3-c27a-49bb-8cf7-385c9f0d2385 | NIC      | ConnectX-5 Virtual Function               | 0a:00.5 | 15b3:1018        | c48b1b8b-28a3-453a-863f-ddf7c62bcfe2 |                                      |
| 17841618-c3e7-43f6-805a-23d2adbcd70c | NIC      | ConnectX-5 Virtual Function               | 0a:00.4 | 15b3:1018        | c48b1b8b-28a3-453a-863f-ddf7c62bcfe2 |                                      |
| 51627e5a-22af-40ee-8af5-dc1971bf89c9 | NIC      | ConnectX-5 Virtual Function               | 0a:00.3 | 15b3:1018        | c48b1b8b-28a3-453a-863f-ddf7c62bcfe2 |                                      |
| f794eba5-fbe7-4bcd-880a-4082523f5c94 | NIC      | ConnectX-5 Virtual Function               | 0a:00.2 | 15b3:1018        | c48b1b8b-28a3-453a-863f-ddf7c62bcfe2 |                                      |
| 10266e05-8d34-4594-81ca-64afbd365ee7 | NIC      | I350 Ethernet Controller Virtual Function | 03:13.0 | 8086:1520        | c48b1b8b-28a3-453a-863f-ddf7c62bcfe2 |                                      |
| a837b5ca-d3ee-4cd8-8de5-447b3ab274d0 | NIC      | I350 Ethernet Controller Virtual Function | 03:12.4 | 8086:1520        | c48b1b8b-28a3-453a-863f-ddf7c62bcfe2 |                                      |
| fab303c9-5dbb-4b85-8df9-fada299622f4 | NIC      | I350 Ethernet Controller Virtual Function | 03:12.0 | 8086:1520        | c48b1b8b-28a3-453a-863f-ddf7c62bcfe2 |                                      |
| f2cb8fd5-aa26-46a7-8dc2-2eca2b77a887 | NIC      | I350 Ethernet Controller Virtual Function | 03:11.4 | 8086:1520        | c48b1b8b-28a3-453a-863f-ddf7c62bcfe2 |                                      |
| b2933d5c-9a3a-45ff-8c80-15ac3291f5c9 | NIC      | I350 Ethernet Controller Virtual Function | 03:11.0 | 8086:1520        | c48b1b8b-28a3-453a-863f-ddf7c62bcfe2 |                                      |
| b22e6511-c70b-440c-8c05-6d1041ae7661 | NIC      | I350 Ethernet Controller Virtual Function | 03:10.4 | 8086:1520        | c48b1b8b-28a3-453a-863f-ddf7c62bcfe2 |                                      |
| f523f12a-82bf-45a3-80cf-94d5a9649665 | NIC      | I350 Ethernet Controller Virtual Function | 03:10.0 | 8086:1520        | c48b1b8b-28a3-453a-863f-ddf7c62bcfe2 |                                      |
+--------------------------------------+----------+-------------------------------------------+---------+------------------+--------------------------------------+--------------------------------------+
***  Total: 24 Pages: 2 Limit: 15 Offset: 0 Page: 1  ***

# 使用 VF 网卡创建虚机，netdesc中可以指定 sriov-nic-model 或者指定 sriov-nic-id
$ climc server-create --disk ae0de3e9-dd45-458e-83b2-4dbc48d70234 \
                      --net 'sriov-nic-model=I350 Ethernet Controller Virtual Function' \
                      --ncpu 2 --mem-spec 4G wyq-test-sriov-nic --auto-start

# 挂载 VF 网卡
$ climc server-attach-network c15a5a99-75ea-4b8c-8c7a-521e5f980db4 \
                              'sriov-nic-model=I350 Ethernet Controller Virtual Function:8056e77e-dc14-44b5-8ef9-e43aff344c0d'

```