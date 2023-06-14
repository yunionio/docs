---
title: "自定义PCI设备类型"
weight: 50
description: >
  如何设置自定义PCI设备类型。
---

cloudpods 平台已经支持透传 GPU, USB, SR-IOV NIC 等类型的设备，对于这些类型之外的设备通过自定义 PCI 设备类型的方式来支持。

## 获取 PCI 设备 vendor_id 与 device_id

添加自定义PCI设备类型之前需要获取设备的 vendor_id 和 device_id

```
登陆到有该设备的宿主机执行 lspci找到对应的 pci 设备的地址：
eg:
$ lspci
00:00.0 Host bridge: Intel Corporation Xeon E7 v2/Xeon E5 v2/Core i7 DMI2 (rev 04)
00:01.0 PCI bridge: Intel Corporation Xeon E7 v2/Xeon E5 v2/Core i7 PCI Express Root Port 1a (rev 04)
00:02.0 PCI bridge: Intel Corporation Xeon E7 v2/Xeon E5 v2/Core i7 PCI Express Root Port 2a (rev 04)
00:03.0 PCI bridge: Intel Corporation Xeon E7 v2/Xeon E5 v2/Core i7 PCI Express Root Port 3a (rev 04)
00:05.0 System peripheral: Intel Corporation Xeon E7 v2/Xeon E5 v2/Core i7 VTd/Memory Map/Misc (rev 04)
00:05.2 System peripheral: Intel Corporation Xeon E7 v2/Xeon E5 v2/Core i7 IIO RAS (rev 04)
00:05.4 PIC: Intel Corporation Xeon E7 v2/Xeon E5 v2/Core i7 IOAPIC (rev 04)
00:11.0 PCI bridge: Intel Corporation C600/X79 series chipset PCI Express Virtual Root Port (rev 06)
00:16.0 Communication controller: Intel Corporation C600/X79 series chipset MEI Controller #1 (rev 05)
00:19.0 Ethernet controller: Intel Corporation 82579LM Gigabit Network Connection (Lewisville) (rev 06)
00:1a.0 USB controller: Intel Corporation C600/X79 series chipset USB2 Enhanced Host Controller #2 (rev 06)
00:1b.0 Audio device: Intel Corporation C600/X79 series chipset High Definition Audio Controller (rev 06)
00:1c.0 PCI bridge: Intel Corporation C600/X79 series chipset PCI Express Root Port 3 (rev b6)
00:1c.4 PCI bridge: Intel Corporation C600/X79 series chipset PCI Express Root Port 5 (rev b6)
00:1d.0 USB controller: Intel Corporation C600/X79 series chipset USB2 Enhanced Host Controller #1 (rev 06)
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev a6)
00:1f.0 ISA bridge: Intel Corporation C600/X79 series chipset LPC Controller (rev 06)
00:1f.2 RAID bus controller: Intel Corporation C600/X79 series chipset SATA RAID Controller (rev 06)
00:1f.3 SMBus: Intel Corporation C600/X79 series chipset SMBus Host Controller (rev 06)
02:00.0 VGA compatible controller: NVIDIA Corporation GK107GL [Quadro K420] (rev a1)

根据 pci 地址获取 vendor_id 与 device_id:
lspci -n -s <PCI_ADDR>
eg:
lspci -n -s 02:00.0
02:00.0 0300: 10de:0ff3 (rev a1)
10de 为 vendor_id, 0ff3 为 device_id
```

## 添加自定义 PCI 设备类型

在云平台创建自定义pci设备类型
```bash
climc isolated-device-model-create
Usage: climc isolated-device-model-create [--help] [--hosts HOSTS] <MODEL> <DEV_TYPE> <VENDOR_ID> <DEVICE_ID>

# --hosts 为需要探测扫描 PCI 设备的宿主机，如果未填可重启 host-agent 生效。如果宿主机数量较多建议直接重启 host-agent
# <MODEL> 为 PCI 设备型号
# <DEV_TYPE> 为设备类型，如 NPU。对于已经支持的设备类型 USB, GPU-HPC, GPU-VGA, NIC 等不能再次创建。
# <VENDOR_ID> <DEVICE_ID> 为厂商ID和设备ID


eg:
climc isolated-device-model-create --hosts host1 Atlas-800 NPU 1a03 2000
```

添加自定义 PCI 设备类型完成后，可以在创建虚机选择自定义设备类型。
```
climc server-create --isolated-device 'Atlas-800' ......
```

查看自定义 PCI 设备类型列表
```
climc isolated-device-model-list
```

## 宿主机禁用 custom pci devices

在 /etc/yunion/host.conf 中添加
- disable_custom_device: true

