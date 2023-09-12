---
title: "vGPU"
weight: 3
description: vGPU是一种GPU虚拟化技术,它可以将单个物理GPU虚拟化为多个虚拟GPU实例,以供多个虚拟机同时使用。
---

NVIDIA 和 AMD 都提供了虚拟 GPU（vgpu）的解决方案，但它们在实现方式上有一些不同之处。

NVIDIA vGPU 实现方式：
- NVIDIA vGPU 是基于 NVIDIA 的 GRID 技术实现的，它使用 NVIDIA 的物理 GPU 并将其划分为多个虚拟 GPU，每个虚拟 GPU 都可以被分配给一个独立的虚拟机实例。
- NVIDIA vGPU 使用专有的虚拟 GPU 管理软件（如NVIDIA Virtual GPU Manager），该软件在物理 GPU 上创建和管理虚拟 GPU，并分配给虚拟机使用。

AMD vGPU 实现方式：
- AMD vGPU 是基于 AMD 的 SR-IOV（Single Root I/O Virtualization）技术实现的，它通过硬件辅助虚拟化技术将物理 GPU 分割为多个虚拟 GPU。

## AMD vGPU 配置

```bash
# 查看 AMD GPU 设备PCI配置空间，确认打开 SR-IOV
$ lspci -k -s 04:00.0 -v
04:00.0 VGA compatible controller: Advanced Micro Devices, Inc. [AMD/ATI] Tonga XT GL [FirePro S7150] (prog-if 00 [VGA controller])
        Subsystem: Advanced Micro Devices, Inc. [AMD/ATI] Device 030c
        Flags: bus master, fast devsel, latency 0, IRQ 209, NUMA node 0
        Memory at 3bfe0000000 (64-bit, prefetchable) [size=256M]
        Memory at 3bff4000000 (64-bit, prefetchable) [size=2M]
        I/O ports at 2000 [size=256]
        Memory at 95c00000 (32-bit, non-prefetchable) [size=256K]
        Expansion ROM at 95c40000 [disabled] [size=128K]
        Capabilities: [48] Vendor Specific Information: Len=08 <?>
        Capabilities: [50] Power Management version 3
        Capabilities: [58] Express Legacy Endpoint, MSI 00
        Capabilities: [a0] MSI: Enable+ Count=1/4 Maskable+ 64bit+
        Capabilities: [100] Vendor Specific Information: ID=0001 Rev=1 Len=010 <?>
        Capabilities: [150] Advanced Error Reporting
        Capabilities: [200] #15
        Capabilities: [270] #19
        Capabilities: [2b0] Address Translation Service (ATS)
        Capabilities: [2c0] Page Request Interface (PRI)
        Capabilities: [2d0] Process Address Space ID (PASID)
        Capabilities: [328] Alternative Routing-ID Interpretation (ARI)
        Capabilities: [330] Single Root I/O Virtualization (SR-IOV) ### 打开了 SR-IOV
        Capabilities: [400] Vendor Specific Information: ID=0002 Rev=1 Len=070 <?>
        Kernel modules: amdgpu
```

宿主机上AMD vGPU需要安装 GIM 驱动，参考：
https://github.com/GPUOpen-LibrariesAndSDKs/MxGPU-Virtualization#how-to-load
```bash
$ git clone https://github.com/GPUOpen-LibrariesAndSDKs/MxGPU-Virtualization.git && cd MxGPU-Virtualization/drv
$ make && make install

# 修改驱动禁用 amdgpu 驱动
$ vi /etc/modprobe.d/blacklist.conf
blacklist amdgpu
blacklist amdkfd

# 配置 VF 数量
$ cat /etc/gim_config
fb_option=0
sched_option=0
vf_num=2 # vf 数量
pf_fb=0
vf_fb=0
sched_interval=0
sched_interval_us=0
fb_clear=0
$ modprobe gim
```

修改 /etc/yunion/host.conf 配置 AMD vGPU
```bash
$ vi /etc/yunion/host.conf
AMDVgpuPFs:
- 04:00.0 # AMD GPU PCI 地址
```

重启 host-agent 服务
```bash
$ kubectl -n onecloud rollout restart ds default-host
```

## NVIDIA vGPU 配置

NVIDIA 需要安装 GRID 驱动(驱动在NVIDIA官网需要企业注册才能下载):
```bash
$ ./NVIDIA-Linux-x86_64-510.85.03-vgpu-kvm.run
# 安装好后重启服务器
# 查看是否加载 nvidia vgpu 驱动
# 内核需要支持 vfio 与 vfio-mdev
$ lsmod | grep nvidia
nvidia_vgpu_vfio       53248  19
nvidia              39120896  273
mdev                   24576  2 vfio_mdev,nvidia_vgpu_vfio
drm                   491520  4 drm_kms_helper,drm_vram_helper,nvidia,ttm
vfio                   32768  7 vfio_mdev,nvidia_vgpu_vfio,vfio_iommu_type1,vfio_pci
# 查看 nvidia vgpu 管理服务状态
$ systemctl status nvidia-vgpu-mgr.service
# 配置 vGPU
# cd /sys/class/mdev_bus/domain\:bus\:slot.function/mdev_supported_types, eg:
$ cd /sys/class/mdev_bus/0000:82:00.0/mdev_supported_types && ls
nvidia-156  nvidia-241  nvidia-284  nvidia-286  nvidia-46  nvidia-48  nvidia-50  nvidia-52  nvidia-54  nvidia-56  nvidia-58  nvidia-60  nvidia-62
nvidia-215  nvidia-283  nvidia-285  nvidia-287  nvidia-47  nvidia-49  nvidia-51  nvidia-53  nvidia-55  nvidia-57  nvidia-59  nvidia-61
# 这些目录代表不同的 vGPU 类型，查看 nvidia-46 详细描述
$ ls nvidia-46
available_instances  create               description          device_api           devices/             name
$ cat nvidia-46/description
num_heads=4, frl_config=60, framebuffer=1024M, max_resolution=5120x2880, max_instance=24
$ cat nvidia-46/name
GRID P40-1Q
$ cat nvidia-46/available_instances
22
```

NVIDIA官网描述如下：
- available_instances
This file contains the number of instances of this vGPU type that can still be created. This file is updated any time a vGPU of this type is created on or removed from the physical GPU.
- create
This file is used for creating a vGPU instance. A vGPU instance is created by writing the UUID of the vGPU to this file. The file is write only.
- description
This file contains the following details of the vGPU type:
The maximum number of virtual display heads that the vGPU type supports
The frame rate limiter (FRL) configuration in frames per second
The frame buffer size in Mbytes
The maximum resolution per display head
The maximum number of vGPU instances per physical GPU
For example:
$ cat description
num_heads=4, frl_config=60, framebuffer=2048M, max_resolution=4096x2160, max_instance=4
- device_api
This file contains the string vfio_pci to indicate that a vGPU is a PCI device.
- devices
This directory contains all the mdev devices that are created for the vGPU type. For example:
$ ll devices
total 0
lrwxrwxrwx 1 root root 0 Dec  6 01:52 aa618089-8b16-4d01-a136-25a0f3c73123 -> ../../../aa618089-8b16-4d01-a136-25a0f3c73123
- name
This file contains the name of the vGPU type. For example:
$ cat name
GRID M10-2Q

可以根据自己的需求配置 vGPU，eg:
```bash
# 生成 uuid 格式的字符串用于配置 vGPU id
$ uuidgen
070bcb42-18fc-4971-9aa9-67f5ee1281c3
$ echo 070bcb42-18fc-4971-9aa9-67f5ee1281c3 > nvidia-46/create
# 如果需要持久化的话需要配置到 /etc/rc.local 中：
echo "echo 070bcb42-18fc-4971-9aa9-67f5ee1281c3 > /sys/class/mdev_bus/0000:82:00.0/mdev_supported_types/nvidia-46/create" >> /etc/rc.local
```

配置 /etc/yunion/host.conf 
```bash
nvidia_vgpu_pfs:
- 82:00.0
```

重启 host-agent 服务
```bash
$ kubectl -n onecloud rollout restart ds default-host
```

### NVIDIA vGPU 虚机配置

虚机内安装 GIRD 驱动
```
禁用 nouveau 驱动
$ cat /etc/modprobe.d/blacklist-nouveau.conf
blacklist nouveau
options nouveau modeset=0
$ ./NVIDIA-Linux-x86_64-510.85.02-grid.run
# 查看 nvidia-gridd 服务状态
$ systemctl status nvidia-gridd 
# 配置 license server 地址
$ cp /etc/nvidia/gridd.conf.template /etc/nvidia/gridd.conf
$ vi /etc/nvidia/gridd.conf # 按需配置
# Description: Set License Server Address
# Data type: string
# Format:  "<address>"
ServerAddress= example.com # license server 地址

# Description: Set License Server port number
# Data type: integer
# Format:  <port>, default is 7070
ServerPort=7070 # license server 端口

# Description: Set Feature to be enabled
# Data type: integer
# Possible values:
#    0 => for unlicensed state
#    1 => for NVIDIA vGPU (Optional, autodetected as per vGPU type)
#    2 => for NVIDIA RTX Virtual Workstation
#    4 => for NVIDIA Virtual Compute Server
# All other values reserved
FeatureType=1 # 

$ systemctl restart nvidia-gridd
$ nvidia-smi -q
    vGPU Software Licensed Product
        Product Name                      : NVIDIA RTX Virtual Workstation
        License Status                    : Licensed (Expiry: 2023-8-14 13:47:59 GMT) # license 状态为 licensed
```

参考：
https://github.com/GPUOpen-LibrariesAndSDKs/MxGPU-Virtualization#how-to-load
https://docs.nvidia.com/grid/latest/grid-vgpu-user-guide/index.html#creating-vgpu-device-red-hat-el-kvm
https://cloud-atlas.readthedocs.io/zh_CN/latest/kvm/vgpu/vgpu_quickstart.html