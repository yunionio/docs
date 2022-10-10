---
title: "虚拟机时钟"
date: 2022-10-10
weight: 600
description: >
    介绍虚拟机时钟原理
---

虚拟机时钟由虚拟设备`-rtc base=utc,clock=host,driftfix=none`，虚拟机硬件基准时钟基于宿主机的UTC时间。

因此，虚拟机需要配置其硬件时钟为UTC时间，如果没有正确配置，则容易出现虚拟机时间不准的情况。

下面介绍虚拟机配置硬件时钟为UTC时间的方法。

### Linux系统

修改/etc/adjtime，将第三行设置为UTC

### Windows系统

运行regedit，打开注册表，在HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\TimeZoneInformation下，右键新建New > DWORD (32-bit) Value，命名为RealTimeIsUniversal，键值为1。
