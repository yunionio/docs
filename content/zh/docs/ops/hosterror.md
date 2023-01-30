---
title: "Host服务问题排查"
date: 2021-11-11T15:59:40+08:00
weight: 100
description: >
    介绍一些常见Host服务错误问题排查方法
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
### 宿主机MAC改变会导致Host服务离线，需要更改宿主机在平台注册的MAC地址，具体步骤如下

- 例如，宿主机IP地址为100.91.1.22，其MAC从18:9b:a5:81:4f:17变为18:9b:a5:81:4f:16

    ```bash
    # 092231af-eebc-456f-8a21-3ab7c944f20c为宿主机id，97e29a73-6615-4d5b-8b67-96bb13b80b90为宿主机所在二层网络的id
    $ climc host-remove-netif 092231af-eebc-456f-8a21-3ab7c944f20c 18:9b:a5:81:4f:17
    $ climc host-add-netif --ip 100.91.1.22 092231af-eebc-456f-8a21-3ab7c944f20c 97e29a73-6615-4d5b-8b67-96bb13b80b90 18:9b:a5:81:4f:16 0
    ```
