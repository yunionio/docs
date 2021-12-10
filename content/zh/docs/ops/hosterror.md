---
title: "Host服务问题排查"
date: 2021-11-11T15:59:40+08:00
weight: 100
---

### 宿主机安装Host服务完成后，默认处于禁用状态，需要启用后使用。宿主机启用方法如下：

- 在云管平台的宿主机列表中启用该宿主机；

- 在控制节点使用climc命令启用该宿主机；

    ```bash
    $ climc host-enable id
    ```
### Host服务为什么会变成离线？

region的HostPingDetectionTask将超过3分钟未收到ping的host服务置为offline，并将宿主机上的虚拟机状态设置为unknown。

### 宿主机的Host服务启动失败，且报错“Fail to get network info：no networks”，该怎么解决？

该问题一般是没有为宿主机注册网络，需要在云管平台为宿主机创建一个IP子网或使用Climc命令在控制节点创建一个网络。

```bash
$ climc network-create bcast0 host02  10.168.222.226  10.168.222.226 24 --gateway 10.168.222.1
```
