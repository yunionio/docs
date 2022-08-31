---
title: "USB相关(已废弃)"
date: 2019-07-19T18:32:40+08:00
draft: true
weight: 42
description: >
  介绍如何在虚拟机上透传宿主机的USB设备。
---

{{<oem_name>}} KVM虚拟机并未正式支持USB透传，但是可以通过虚拟机的extra参数，将USB透传的qemu命令参数传递给qemu，从而也能从某种程度上实现将宿主机挂载的指定USB设备透传给在该宿主机上运行的虚拟机的目的，目前，只能通过climc命令行工具来更新虚拟机的extra参数。

第一步，在宿主机上运行 lsusb -t 命令找到USB设备在宿主机的设备ID。

如果是USB 2.0的设备，执行 lsusb -t 有如下输出：

```bash
/:  Bus 03.Port 1: Dev 1, Class=root_hub, Driver=xhci_hcd/14p, 480M
|__ Port 10: Dev 8, If 0, Class=Human Interface Device, Driver=usbhid, 12M
```

则透传USB的qemu参数为：

```bash
-device usb-host,hostbus=3,hostport=10
```

如果是USB 3.0的设备，执行 lsusb -t 有如下输出:

```bash
/:  Bus 03
|__ Port 2: some stuff
    |__ Port 1: some stuff
```

则透传USB的qemu参数为：

```bash
-device usb-host,hostbus=3,hostport=2.1
```

第二步，执行climc命令，更新目标虚拟机的extra参数

```bash
climc server-add-extra-options <sid> 'device' 'usb-host,hostbus=3,hostport=2.1'
```

该命令执行后，将会给qemu虚拟机的命令行参数增加如下额外参数：

```bash
-device usb-host,hostbus=3,hostport=2.1
```

第三步：重启虚拟机

```bash
climc server-restart <sid>
```

如果希望虚拟机不再透传该USB设备，则执行

```bash
climc server-remove-extra-options <sid> 'device'
```

然后，再restart该虚拟机。
