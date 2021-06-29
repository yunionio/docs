---
title: "使用Linux vfio将Nvidia GPU透传给QEMU虚拟机"
date: 2021-06-07
slug: nvidia-gpu-passthrough-record
---

**作者:** 李泽玺

Linux 上虚拟机 GPU 透传需要使用 vfio 的方式。主要是因为在 vfio 方式下对虚拟设备的权限和 DMA 隔离上做的更好。但是这么做也有个缺点，这个物理设备在主机和其他虚拟机都不能使用了。

qemu 直接使用物理设备本身命令行是很简单的，关键在于事先在主机上对系统、内核和物理设备的一些配置。

单纯从 qemu 的命令行来看，其实和普通虚拟机启动就差了最后那个 `-device` 的选项。这个选项也比较容易理解，就是把主机上的设备 0000:00:01.0 传给了虚拟机使用。

```bash
$ qemu-system-x86_64 -m 4096 -smp 4 --enable-kvm \
  -drive file=~/guest/fedora.img \
  -device vfio-pci,host=0000:00:01.0
```

## 系统及硬件准备

### BIOS中打开IOMMU

设备直通在 x86 平台上需要打开 iommu 功能。这是 Intel 虚拟技术 VT-d(Virtualization Technology for Device IO) 中的一个部分。有时候这部分的功能没有被打开。

打开的方式在 BIOS 设置中 Security->Virtualization->VT-d 这个位置。当然不同的 BIOS 位置可能会略有不同。记得在使用直通设备前要将这个选项打开。

### 内核配置勾选IOMMU

```bash
INTEL_IOMMU
│ Location: │
│ -> Device Drivers │
│ (2) -> IOMMU Hardware Support (IOMMU_SUPPORT [=y])
```

### 内核启动参数enable IOMMU

BIOS 中打开，内核编译选项勾选还不够。还需要在引导程序中添加上内核启动参数

```bash
# 对应编辑 /etc/default/grub, 设置 GRUB_CMDLINE_LINUX=
$ cat /etc/default/grub
...
GRUB_CMDLINE_LINUX="intel_iommu=on iommu=pt vfio_iommu_type1.allow_unsafe_interrupts=1 rdblacklist=nouveau nouveau.modeset=0"
...
 
# 重新生成 grub 引导配置文件
$ grub2-mkconfig -o /boot/grub2/grub.cfg
 
# 将vfio相关 module 设置为开机load
$ cat /etc/modules-load.d/vfio.conf
vfio
vfio_iommu_type1
vfio_pci
vfio_virqfd
```

[Setting up IOMMU](https://wiki.archlinux.org/index.php/PCI_passthrough_via_OVMF#Setting_up_IOMMU)
[Kernel parameters](https://wiki.archlinux.org/index.php/Kernel_parameters)

### 找到 nvidia GPU BusID

record PCI addresses and hardware IDs of the GPU

```bash
$ lspci -k | grep -i nvidia -A 3                   
41:00.0 VGA compatible controller: NVIDIA Corporation GP107 [GeForce GTX 1050 Ti] (rev a1)
        Subsystem: Device 1b4c:11bf
        Kernel driver in use: vfio-pci
        Kernel modules: nouveau
41:00.1 Audio device: NVIDIA Corporation GP107GL High Definition Audio Controller (rev a1)
        Subsystem: Device 1b4c:11bf
        Kernel driver in use: snd_hda_intel
        Kernel modules: snd_hda_intel
# pci address => 41:00.0,41:00.1
# device id => 1b4c:11bf
 
# 这里找到了两张 nvidia 卡，它们的 device id 都是 1b4c:11bf, 一张是 Audio device
# 这样是不能 passthrough 进去的，因为:
# vfio-pci use your vendor and device id pair to identify which device they need to bind to at boot,
# if you have two GPUs sharing such an ID pair you will not be able to get your passthough driver to bind with just one of them
# 使用下面的脚本解决这种情况：
 
$ cat /usr/bin/vfio-pci-override.sh
#!/bin/sh
 
for i in $(find /sys/devices/pci* -name boot_vga); do
    if [ $(cat "$i") -eq 0 ]; then
        GPU="${i%/boot_vga}"
        AUDIO="$(echo "$GPU" | sed -e "s/0$/1/")"
        echo "vfio-pci" > "$GPU/driver_override"
        if [ -d "$AUDIO" ]; then
            echo "vfio-pci" > "$AUDIO/driver_override"
        fi
    fi
done
 
modprobe -i vfio-pci
 
# 把脚本传入 /etc/modprobe.d/vfio.conf
$ cat /etc/modprobe.d/vfio.conf
install vfio-pci /usr/bin/vfio-pci-override.sh
options vfio-pci ids=10de:1c82 disable_vga=1
```

### 使用 vfio 管理 GPU

```bash
# /etc/modprobe.d/vfio.conf, ids 为 lspci 找到的 hardware id, 多个设备的话用','分割
$ cat /etc/modprobe.d/vfio.conf
options vfio-pci ids=10de:134d disable_vga=1
 
# 禁用NVIDIA nouveau 开源驱动, /etc/modprobe.d/blacklist.conf
$ cat /etc/modprobe.d/blacklist.conf
blacklist nouveau
 
# kvm 模块配置, /etc/modprobe.d/kvm.conf
$ cat /etc/modprobe.d/kvm.conf
options kvm ignore_msrs=1
```

重启系统，启动完成后查看当前的 nvidia GPU 是否被 vfio-pci 模块使用, 确认IOMMU功能确实打开。

```bash
$ dmesg | grep -e DMAR -e IOMMU | grep enabled
 
# 如果能搜索到
DMAR: IOMMU enabled
# 表示上述配置成功。
 
# 查看 GPU 是否被 vfio-pci 使用
# 另外注意检查看看 41:00.1 Audio device 是否也被 vfio-pci 使用
$ lspci -k | grep -i -e nvidia -A 3
41:00.0 VGA compatible controller: NVIDIA Corporation GP107 [GeForce GTX 1050 Ti] (rev a1)
    Subsystem: Device 1b4c:11bf
    Kernel driver in use: vfio-pci # GTX 1050 Ti GPU 被 vfio-pci 使用
    Kernel modules: nouveau
41:00.1 Audio device: NVIDIA Corporation GP107GL High Definition Audio Controller (rev a1)
    Subsystem: Device 1b4c:11bf
    Kernel driver in use: vfio-pci # 发现 Audio device 也被 vfio-pci 使用了
    Kernel modules: snd_hda_intel
...
```

```bash
# list GPU IOMMU group
$ find /sys/kernel/iommu_groups/ -type l | grep 41:00
/sys/kernel/iommu_groups/27/devices/0000:41:00.0
/sys/kernel/iommu_groups/27/devices/0000:41:00.1
 
# 找到IOMMU Group 管理的 PCI 设备
#!/bin/bash
shopt -s nullglob
for d in /sys/kernel/iommu_groups/*/devices/*; do
  n=${d#*/iommu_groups/*}; n=${n%%/*}
  printf 'IOMMU Group %s ' "$n"
  lspci -nns "${d##*/}"
done
```

### 使用 qemu 透传 nvidia GPU

准备好centos7镜像，然后在虚拟机里面安装 nvidia 官方闭源驱动和 cuda SDK

```bash
# 我从服务器上拷贝过来的是 vmdk 的镜像，先把它转换成 qcow2 的格式
$ /usr/local/qemu-2.9.0/bin/qemu-img convert -f vmdk -O qcow2 centos-7.3.1611-20180104.vmdk centos-7.3.1611-20180104.qcow2
 
# 使用 qemu 启动，注意-cpu 需要 kvm=off 参数
# kvm=off will hide the kvm hypervisor signature, this is required for NVIDIA cards
# since its driver will refuse to work on an hypervisor and result in Code 43 on windows
$ cat startvm.sh
#!/bin/sh
/usr/local/qemu-2.9.0/bin/qemu-system-x86_64 -enable-kvm \
-m 4096 -cpu host,kvm=off -smp 4,sockets=1,cores=4,threads=1 \
-drive file=./centos-7.3.1611-20180104.qcow2 \
-device vfio-pci,host=41:00.0,multifunction=on,addr=0x16 \
-device vfio-pci,host=41:00.1 \
-net nic,model=e1000 -net user,hostfwd=tcp::5022-:22 \
-vnc :1
 
# 这台虚拟机开了vnc和ssh 端口转发，可以使用vnc或者ssh访问
 
# 从host进入虚拟机
$ ssh 127.0.0.1 -p 5022
 
# 查看虚拟机透传进来的显卡
$ lspci -k | grep -i nvidia -A 3
00:04.0 Audio device: NVIDIA Corporation Device 0fb9 (rev a1)
    Subsystem: Device 1b4c:11bf
    Kernel driver in use: snd_hda_intel
    Kernel modules: snd_hda_intel
00:16.0 VGA compatible controller: NVIDIA Corporation GP107 (rev a1)
    Subsystem: Device 1b4c:11bf
    Kernel modules: nouveau
```

## 安装nvidia 驱动和 Cuda

nvidia 驱动需要从官方下载，如果先安装 cuda 的话会一同安装 nvidia 驱动。
接下来采用虚拟机先安装驱动再安装 cuda 的步骤。

参考：
[installing-nvidia-drivers-centos-7](http://www.advancedclustering.com/act_kb/installing-nvidia-drivers-rhel-centos-7/)
[NVIDIA CUDA GETTINGS STARTED GUIDE FOR LINUX](https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html)

### 安装 nvidia 驱动

下载地址：http://www.nvidia.com/object/unix.html

```bash
# update 后如果更新内核，需要重启
$ yum -y update
 
# 安装 gcc、make、glibc等工具和库
$ yum -y groupinstall "Development Tools"
$ yum -y install kernel-devel
 
# Download the latest NVIDIA driver for unix.
$ wget http://us.download.nvidia.com/XFree86/Linux-x86_64/390.42/NVIDIA-Linux-x86_64-390.42.run
$ yum -y install epel-release
$ yum -y install dkms
 
# Edit /etc/default/grub. Append the following  to “GRUB_CMDLINE_LINUX”
rd.driver.blacklist=nouveau nouveau.modeset=0
 
# Generate a new grub configuration to include the above changes.
$ grub2-mkconfig -o /boot/grub2/grub.cfg
 
# Edit/create /etc/modprobe.d/blacklist.conf and append:
blacklist nouveau
 
# Backup your old initramfs and then build a new one
$ mv /boot/initramfs-$(uname -r).img /boot/initramfs-$(uname -r)-nouveau.img
$ dracut /boot/initramfs-$(uname -r).img $(uname -r)
 
# 重启again
 
# Run the NVIDIA driver installer and enter yes to all options.
$ sh NVIDIA-Linux-x86_64-*.run
 
# 装好后再一次重启，lspci -k 看下gpu使用的驱动是否是nvidia
$ lspci -k | grep -i nvidia -A 3
00:04.0 Audio device: NVIDIA Corporation GP107GL High Definition Audio Controller (rev a1)
00:16.0 VGA compatible controller: NVIDIA Corporation GP107 [GeForce GTX 1050 Ti] (rev a1)
    Kernel driver in use: nvidia # 发现已经使用nvidia驱动
    Kernel modules: nouveau, nvidia_drm, nvidia
 
# 执行 nvidia-smi 看下输出和温度
$ nvidia-smi
Thu Mar 15 01:31:09 2018      
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 390.42                 Driver Version: 390.42                    |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|===============================+======================+======================|
|   0  GeForce GTX 105...  Off  | 00000000:00:16.0 Off |                  N/A |
| 40%   32C    P0    N/A / 100W |      0MiB /  4040MiB |      0%      Default |
+-------------------------------+----------------------+----------------------+
 
+-----------------------------------------------------------------------------+
| Processes:                                                       GPU Memory |
|  GPU       PID   Type   Process name                             Usage      |
|=============================================================================|
|  No running processes found                                                 |
+-----------------------------------------------------------------------------+
 
$ nvidia-smi -q -d TEMPERATURE
 
==============NVSMI LOG==============
 
Timestamp                           : Thu Mar 15 01:32:42 2018
Driver Version                      : 390.42
 
Attached GPUs                       : 1
GPU 00000000:00:16.0
    Temperature
        GPU Current Temp            : 32 C
        GPU Shutdown Temp           : 102 C
        GPU Slowdown Temp           : 99 C
        GPU Max Operating Temp      : N/A
        Memory Current Temp         : N/A
        Memory Max Operating Temp   : N/A
```

### 安装 cuda

下载地址： https://developer.nvidia.com/cuda-downloads
这里选择 runfile，以后为了方便也可以选择 rpm(network)的方式，会自动帮我们安装 nvidia 驱动

```bash
$ wget https://developer.nvidia.com/compute/cuda/9.1/Prod/local_installers/cuda_9.1.85_387.26_linux
 
# Say no to installing the NVIDIA driver.
# The standalone driver you already installed is typically newer than what is packaged with CUDA.
# Use the default option for all other choices.
$ sh cuda_*.run
 
# 添加 CUDA 相关的环境变量
export PATH=$PATH:/usr/local/cuda/bin
export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH
 
# make samples
$ cd ~/NVIDIA_CUDA-9.1_Samples; make -j 4
$ cd bin/x86_64/linux/release
$ ./deviceQuery # 查询gpu信息
./deviceQuery Starting...
 
 CUDA Device Query (Runtime API) version (CUDART static linking)
 
Detected 1 CUDA Capable device(s)
 
Device 0: "GeForce GTX 1050 Ti"
  CUDA Driver Version / Runtime Version          9.1 / 9.1
  CUDA Capability Major/Minor version number:    6.1
  Total amount of global memory:                 4040 MBytes (4236312576 bytes)
  ( 6) Multiprocessors, (128) CUDA Cores/MP:     768 CUDA Cores
  GPU Max Clock rate:                            1481 MHz (1.48 GHz)
  Memory Clock rate:                             3504 Mhz
  Memory Bus Width:                              128-bit
  L2 Cache Size:                                 1048576 bytes
...
 
$ ./bandwidtTest # 使用 cuda 测试gpu bandwidth
Running on...
 
 Device 0: GeForce GTX 1050 Ti
 Quick Mode
 
 Host to Device Bandwidth, 1 Device(s)
 PINNED Memory Transfers
   Transfer Size (Bytes)    Bandwidth(MB/s)
   33554432            9719.0
 
 Device to Host Bandwidth, 1 Device(s)
 PINNED Memory Transfers
   Transfer Size (Bytes)    Bandwidth(MB/s)
   33554432            9215.8
 
 Device to Device Bandwidth, 1 Device(s)
 PINNED Memory Transfers
   Transfer Size (Bytes)    Bandwidth(MB/s)
   33554432            95525.1
 
Result = PASS
 
NOTE: The CUDA Samples are not meant for performance measurements. Results may vary when GPU Boost is enabled.
```
