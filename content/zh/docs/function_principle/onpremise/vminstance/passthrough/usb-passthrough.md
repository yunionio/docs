---
title: "USB 透传"
weight: 200
description: >
  介绍如何把宿主机的 USB 设备透传给虚拟机使用。
---

支持版本：>=3.8

目前只有内置私有云平台的虚拟机可以使用宿主机上的 USB 设备。前提条件是宿主机需要有 `lsusb` 这个工具，如果没有请安装 `usbutils` 这个包。

## 配置宿主机

查看宿主机上的 USB 设备，命令如下：

```bash
$ lsusb
Bus 002 Device 002: ID 0951:1666 Kingston Technology DataTraveler 100 G3/G4/SE9 G2/50
Bus 002 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
Bus 001 Device 002: ID 0627:0001 Adomax Technology Co., Ltd
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
```

默认情况下宿主机透传 USB 设备功能是禁用的，需要在 `/etc/yunion/host.conf` 配置文件里面设置 `disable_usb: false` 。

```bash
$ vim /etc/yunion/host.conf
...
disable_usb: false
...
```

假设宿主机 hostname 为 `oc-node-1`，然后重启宿主机服务，登录到控制节点，执行下面的命令：

```bash
# 先找到对应的宿主机服务
$ kubectl get pods -n onecloud -o wide | grep host | grep oc-node-1 | egrep -v 'deployer|image'
default-host-59k76                                  3/3     Running   7          3d22h   192.168.121.21   oc-node-1   <none>           <none>

# 删除宿主机上的 pod ，等待重建
$ kubectl delete pods -n onecloud default-host-59k76
pod "default-host-59k76" deleted

# 查看新创建的 host 服务
$ kubectl get pods -n onecloud -o wide | grep host | grep oc-node-1 | egrep -v 'deployer|image'
default-host-6cl8w                                  3/3     Running   0          17s     192.168.121.21   oc-node-1   <none>           <none>
# 确保该服务变成 Running ，然后到云平台查看透传 USB 设备
```

如果宿主机很多，也可以使用 `kubectl -n rollout restart daemonset default-host` 命令来重启所有宿主机上的 host 服务。

## 查看 USB 透传设备

### climc 命令行查看透传设备

使用命令行 `climc isolated-device-list --details` 查看设备：

```bash
$ climc isolated-device-list --details
+--------------------------------------+----------+------------------------------------------------------+---------+------------------+--------------------------------------+--------------------------+----------+-------+--------------+
|                  ID                  | Dev_type |                        Model                         |  Addr   | Vendor_device_id |               Host_id                |           Host           | Guest_id | Guest | Guest_status |
+--------------------------------------+----------+------------------------------------------------------+---------+------------------+--------------------------------------+--------------------------+----------+-------+--------------+
| 1541047f-0203-488a-8226-2de740da061f | USB      | Adomax Technology Co., Ltd                           | 001:002 | 0627:0001        | 7a11731f-dcc0-41e5-8d64-68eb36defcbe | oc-node-1-192-168-121-21 |          |       |              |
| a3fa9bd4-236c-4c5b-8056-f7afa807138d | USB      | Kingston Technology DataTraveler 100 G3/G4/SE9 G2/50 | 002:002 | 0951:1666        | 7a11731f-dcc0-41e5-8d64-68eb36defcbe | oc-node-1-192-168-121-21 |          |       |              |
+--------------------------------------+----------+------------------------------------------------------+---------+------------------+--------------------------------------+--------------------------+----------+-------+--------------+
***  Total: 2 Pages: 1 Limit: 20 Offset: 0 Page: 1  ***
```

### web界面查看透传设备

1. 在透传设备页面，可以查看到宿主机上的USB透传设备。

现在云平台就有了宿主机 oc-node-1 上的 USB 透传设备，接下来就可以把这些设备给虚拟机使用。

## 虚拟机挂载 USB

USB 可以在虚拟机运行状态下挂载进去，可以在前端的透传设备列表那里把 USB 挂载到虚拟机里面，一个虚拟机可关联多个USB透传设备。但是一个USB透传设备仅可被一个虚拟机使用。

### web界面挂载USB

**在虚拟机页面挂载USB透传设备**

1. 在左侧导航栏，选择 **_"主机/主机/虚拟机"_** 菜单项，进入虚拟机页面。
2. 单击虚拟机右侧操作列 **_"更多"_** 按钮，选择下拉菜单 **_"实例设置-设置USB透传"_** 菜单项，弹出设置USB透传对话框。
2. 配置以下参数：
    - 是否绑定：选择绑定USB透传设备。
    - USB设备：当启用绑定USB透传设备后，显示该项，并选择具体的透传设备。
    - 自动启动：挂载USB设备成功后虚拟机是否自动启动，仅虚拟机关机状态下生效。
3. 单击 **_"确定"_** 按钮，挂载或取消挂载USB透传设备。


**在透传设备页面关联虚拟机**

1. 在透传设备页面，单击USB类型透传设备右侧操作列 **_"关联虚拟机"_** 按钮，弹出关联虚拟机对话框。
2. 配置以下参数：
    - 选择虚拟机：选择需要关联透传设备的虚拟机。
    - 自动启动：挂载USB设备成功后虚拟机是否自动启动，仅虚拟机关机状态下生效。
3. 单击 **_"确定"_** 按钮，为USB透传设备关联虚拟机。

### Climc命令行挂载USB设备

对应命令行操作如下 `climc server-attach-isolated-device $server_id $device_id`：

```bash
# 比如虚拟机名称为 testvm，透传设备 id 为 a3fa9bd4-236c-4c5b-8056-f7afa807138d
$ climc server-attach-isolated-device testvm a3fa9bd4-236c-4c5b-8056-f7afa807138d

# 然后登录到 testvm 虚拟机里面，执行 lsusb 就能看到宿主机的 USB 设备
[root@testvm ~]# lsusb
Bus 002 Device 002: ID 0951:1666 Kingston Technology DataTraveler 100 G3/G4/SE9 G2/50
```

## 虚拟机卸载 USB

USB 可以在虚拟机运行状态下卸载 USB ，可以在前端的透传设备列表那里卸载 USB 对应的虚拟机。

### web界面卸载USB

**在虚拟机页面卸载USB透传设备**

1. 在左侧导航栏，选择 **_"主机/主机/虚拟机"_** 菜单项，进入虚拟机页面。
2. 单击虚拟机右侧操作列 **_"更多"_** 按钮，选择下拉菜单 **_"实例设置-设置USB透传"_** 菜单项，弹出设置USB透传对话框。
2. 配置以下参数：
    - 是否绑定：关闭绑定USB透传设备。
    - 自动启动：挂载USB设备成功后虚拟机是否自动启动，仅虚拟机关机状态下生效。
3. 单击 **_"确定"_** 按钮，挂载或取消挂载USB透传设备。


**在透传设备页面取消关联虚拟机**

1. 在透传设备页面，单击USB类型透传设备右侧操作列 **_"取消关联虚拟机"_** 按钮，弹出关联虚拟机对话框。
2. 配置以下参数：
    - 自动启动：卸载USB设备成功后虚拟机是否自动启动，仅虚拟机关机状态下生效。
3. 单击 **_"确定"_** 按钮，USB透传设备取消关联虚拟机。


### Climc命令卸载USB

对应命令行操作如下 `climc server-detach-isolated-device $server_id $device_id`：

```bash
# 比如虚拟机名称为 testvm，透传设备 id 为 a3fa9bd4-236c-4c5b-8056-f7afa807138d
$ climc server-detach-isolated-device testvm a3fa9bd4-236c-4c5b-8056-f7afa807138d
```

## 宿主机刷新设备

有些情况会频繁在宿主机上插拔 USB 设备，这样会导致云平台记录的 USB 设备信息和宿主机上的实际设备信息不一致，可以使用下面的命令 `climc host-probe-isolated-devices $host_id` 进行设备信息同步：

```bash
# 假设宿主机名称为 oc-node-1-192-168-121-21，看下目前的设备列表
$ lsusb
Bus 002 Device 002: ID 0951:1666 Kingston Technology DataTraveler 100 G3/G4/SE9 G2/50
Bus 001 Device 002: ID 0627:0001 Adomax Technology Co., Ltd

# 对应云平台的设备列表是一致的
$ climc isolated-device-list  --host oc-node-1-192-168-121-21
+--------------------------------------+----------+------------------------------------------------------+---------+------------------+--------------------------------------+
|                  ID                  | Dev_type |                        Model                         |  Addr   | Vendor_device_id |               Host_id                |
+--------------------------------------+----------+------------------------------------------------------+---------+------------------+--------------------------------------+
| 1541047f-0203-488a-8226-2de740da061f | USB      | Adomax Technology Co., Ltd                           | 001:002 | 0627:0001        | 7a11731f-dcc0-41e5-8d64-68eb36defcbe |
| a3fa9bd4-236c-4c5b-8056-f7afa807138d | USB      | Kingston Technology DataTraveler 100 G3/G4/SE9 G2/50 | 002:002 | 0951:1666        | 7a11731f-dcc0-41e5-8d64-68eb36defcbe |
+--------------------------------------+----------+------------------------------------------------------+---------+------------------+--------------------------------------+
***  Total: 2 Pages: 1 Limit: 20 Offset: 0 Page: 1  ***

# 从上面看到有两个 USB 设备列表，然后我把 Kingston U 盘拔掉
$ lsusb
Bus 001 Device 002: ID 0627:0001 Adomax Technology Co., Ltd

# 执行命令同步当前宿主机设备信息
$ climc host-probe-isolated-devices oc-node-1-192-168-121-21

# 再查看设备列表就只有一个了，Kingston U 盘记录已经被删掉
$ climc isolated-device-list  --host oc-node-1-192-168-121-21
+--------------------------------------+----------+----------------------------+---------+------------------+--------------------------------------+
|                  ID                  | Dev_type |           Model            |  Addr   | Vendor_device_id |               Host_id                |
+--------------------------------------+----------+----------------------------+---------+------------------+--------------------------------------+
| fa3cdbbd-7c54-4d2a-87cd-9362aa590a7d | USB      | Adomax Technology Co., Ltd | 001:002 | 0627:0001        | 7a11731f-dcc0-41e5-8d64-68eb36defcbe |
+--------------------------------------+----------+----------------------------+---------+------------------+--------------------------------------+
***  Total: 1 Pages: 1 Limit: 20 Offset: 0 Page: 1  ***
```

## 指定USB控制器

默认采用qemu-xhci的USB控制器，该控制器支持版本为USB 3.0，向下兼容2.0。对于老版本的操作系统，例如 Windows Server 2008 R2，不识别USB 3.0的控制器，此时需要改为USB 2.0的控制器 usb-ehci。可以通过一下climc命令行更改虚拟机使用的USB控制器：

```bash
climc server-set-qemu-params <sid> --usb-controller-type <usb-ehci|qemu-xhci>
```

更改后，请请重启虚拟机。
