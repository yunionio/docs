---
title: "串口COM透传"
weight: 290
description: >
  介绍如何把宿主机的串口COM透传给虚拟机使用。
---

本文介绍如何将宿主机的串口（COM）透传到虚拟机内使用。

## 配置宿主机

查看宿主机上的 COM 设备，采用命令 setserial 查看：

```bash
# 查看板载串口设备
$ sudo setserial -g /dev/ttyS[0123]
/dev/ttyS0, UART: 16550A, Port: 0x03f8, IRQ: 4
/dev/ttyS1, UART: 16550A, Port: 0x1020, IRQ: 18
/dev/ttyS2, UART: unknown, Port: 0x03e8, IRQ: 4
/dev/ttyS3, UART: unknown, Port: 0x02e8, IRQ: 3
# 查看USB串口
$ sudo setserial -g /dev/ttyUSB[01]
/dev/ttyUSB0, UART: unknown, Port: 0x0000, IRQ: 0
```

找到宿主机上待透传的串口设备路径，例如 /dev/ttyUSB0

在QEMU增加如下命令行参数将该串口设备传入虚拟机：

```bash
-chardev tty,path=/dev/ttyUSB0,id=hostusbserial
-device pci-serial,chardev=hostusbserial
```

通过如下climc命令为指定宿主机设置以上命令行参数：

```
climc server-add-extra-options <sid> chardev tty,path=/dev/ttyUSB0,id=hostusbserial
climc server-add-extra-options <sid> device pci-serial,chardev=hostusbserial
```

重启该虚拟机，在虚拟机详情页面查看命令行参数中是否增加了以上参数。
