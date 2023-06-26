---
title: "设备透传"
date: 2023-06-21T10:26:40+08:00
weight: 1000
description: >
  本章介绍虚拟机设备透传相关的原理和操作。
---

我们可以将宿主机上的设备透传到虚拟机内，允许虚拟机直接访问宿主机的硬件设备，主要有以下几种使用场景：

## PCI/PCIe 设备透传

将宿主机的PCI/PCIe设备透传到虚拟机，需要预先对宿主机进行如下的配置：

1. Intel VT-d 或 AMD IOMMU 已在系统的 BIOS 中启用。具体请参阅机器的 BIOS 配置菜单，或其它相关信息。

2. 修改grub的内核启动参数，使得Intel VT-d 或 AMD IOMMU 已在操作系统中启用：

如果是Intel CPU，则需要在 /etc/default/grub 的 GRUB_CMDLINE_LINUX 添加如下grub参数：
```bash
GRUB_CMDLINE_LINUX="intel_iommu=on iommu=pt vfio_iommu_type1.allow_unsafe_interrupts=1"
```

如果是AMD CPU，amd_iommu=on已经默认设置，因此对应 grub 命令行参数为:

```bash
GRUB_CMDLINE_LINUX="iommu=pt vfio_iommu_type1.allow_unsafe_interrupts=1"
```

3. 更新生成 grub 引导配置文件

在/etc/default/grub设置 GRUB_CMDLINE_LINUX 之后，需要运行 grub2-mkconfig 更新grub的配置文件。

如果系统是BIOS启动，使用如下命令：

```bash
$ grub2-mkconfig -o /boot/grub2/grub.cfg
```

如果是UEFI启动，使用如下命令（假设是CentOS）：

```bash
grub2-mkconfig -o /boot/efi/EFI/centos/grub.cfg
```

4. 将vfio内核模块设置为自动加载

宿主机PCI/PCIe设备透传原理为：该设备被vfio-pci驱动接管，从而允许设备被用户态应用程序（即QEMU）直接访问使用。

因此，为了启用PCI/PCIe设备透传，需要启用内核的vfio相关内核模块，并且需要透传的设备需要被 vfio-pci 内核模块接管。

启用vfio内核模块的方法为：修改 /etc/modules-load.d/vfio.conf，加入如下内核模块，将vfio相关内核模块设置为开机自动加载。

```bash
$ cat /etc/modules-load.d/vfio.conf
vfio
vfio_iommu_type1
vfio_pci
vfio_virqfd
```

备注：内核6.2及以后版本，vfio_virqfd 合并入 vfio 模块，不再有 vfio_virqfd。

host服务会负责设置待透传设备的 vfio-pci 接管。

5. 启用大页内存(可选)

建议启用宿主机大页内存（hugepage），具体参见[内存大页(Hugepage)](../hugepage)。

注：从3.10开始，新部署的x86计算节点会自动开启大页。

6. 重启宿主机生效

如果做了2-4步骤的修改，需要重启宿主机使得配置生效。

重启后，查看 /proc/cmdline 确认内核命令行参数配置生效。

执行 lsmod 确认 相关内核模块 被正确加载。

以上为任意PCI/PCIe设备通常的设置，针对不同类型的PCI/PCIe设备和不同的设备透传场景，还有各自不同的设置和使用方法，具体介绍如下：

### GPU透传

参见：[GPU透传](./gpu)

### SR-IOV网卡透传

参见: [网卡SR-IOV卸载](./sriov)

### NVME透传

TODO (NVME透传以及设置基于NVME的存储防范)

### 其他通用PCI/PCIe设备透传

参见：[自定义PCI设备透传](./custom-pci-devices)

## 其他低速设备透传

除了可以透传宿主机的PCI/PCIe设备，还可以透传宿主机的USB，串口等低速设备到虚拟机使用。具体介绍如下。

### USB设备透传

参见: [USB 透传](./usb-passthrough)

### 串口设备透传

参见：[串口COM透传](./com-passthrough)

## 常见问题(FAQ)

### 如何验证Intel VT-d 或 AMD IOMMU 已在系统的 BIOS 中启用？

在Linux下如何验证vt-d是否开启的方法参照：https://stackoverflow.com/questions/51261999/check-if-vt-d-iommu-has-been-enabled-in-the-bios-uefi

查看dmesg中包含的DMAR日志，执行：

```bash
dmesg | grep DMAR

```

如果执行结果不符合预期，则说明BIOS里没有开启，需要在BIOS里找到vt-d或X2APIC，然后开启。

### 如何验证 grub 设置的内核参数已经生效？

查看 /proc/cmdline 是否包含了设置在 /etc/default/grub GRUB_CMDLINE_LINUX 的参数。

```bash
# cat /proc/cmdline
BOOT_IMAGE=/vmlinuz-5.4.130-1.yn20221208.el7.x86_64 root=UUID=6f96c2be-434d-405e-9b46-ba8877f2a0a9 ro rhgb crashkernel=auto rdblacklist=nouveau hugepagesz=1G vfio_iommu_type1.allow_unsafe_interrupts=1 intel_iommu=on quiet iommu=pt nouveau.modeset=0 net.ifnames=0 default_hugepagesz=1G biosdevnames=0
```

### 如何验证 vfio 内核模块正确加载？

查看demsg包含的vfio日志，执行

```bash
# dmesg | grep -i vfio
[    0.329224] VFIO - User Level meta-driver version: 0.3
[    0.341372] vfio_pci: add [10de:13c2[ffff:ffff]] class 0x000000/00000000
[    0.354704] vfio_pci: add [10de:0fbb[ffff:ffff]] class 0x000000/00000000
[    2.061326] vfio-pci 0000:06:00.0: enabling device (0100 -> 0103)
```

### 如何验证宿主机上待透传的PCI/PCIe设备被vfio-pci接管？

执行如下命令，确认设备的 Kernel driver in use 是 vfio-pci

```bash
# lspci -nnk | grep AMD -A 3
03:00.0 VGA compatible controller [0300]: Advanced Micro Devices, Inc. [AMD/ATI] Tonga XT GL [FirePro S7150] [1002:6929]
	Subsystem: Advanced Micro Devices, Inc. [AMD/ATI] Device [1002:030c]
	Kernel driver in use: vfio-pci
	Kernel modules: amdgpu
```

```bash
# lspci -nnk | grep NVIDIA -A 3
42:00.0 VGA compatible controller [0300]: NVIDIA Corporation GP102 [GeForce GTX 1080 Ti] [10de:1b06] (rev a1)
	Subsystem: NVIDIA Corporation Device [10de:120f]
	Kernel driver in use: vfio-pci
	Kernel modules: nouveau
42:00.1 Audio device [0403]: NVIDIA Corporation GP102 HDMI Audio Controller [10de:10ef] (rev a1)
	Subsystem: NVIDIA Corporation Device [10de:120f]
	Kernel driver in use: vfio-pci
	Kernel modules: snd_hda_intel
```

