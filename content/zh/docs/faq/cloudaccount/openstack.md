---
title: "OpenStack"
linktitle: "OpenStack"
weight: 11
description: >
 介绍如何在OpenStack平台常见的一些问题。
---

## 虚拟机VNC
默认OpenStack平台强制使用noVnc进行远程连接,若OpenStack平台配置了websockify进行远程连接, 可以通过以下命令开启使用
```shell
$ climc service-config --config force_use_origin_vnc=false region2
```
