---
title: "libvirt管理虚机导入"
date: 2019-11-26T16:57:43+08:00
weight: 40
---

支持将libvirt管理的虚拟机导入到Cloudpods平台。

## 注意事项

- 首先需要在libvirt管理的宿主机上安装我们的计算节点

- 安装好计算节点后需要添加的虚拟机的网络到控制节点

- 确保libvirt服务关闭

## 相关操作

- 准备好需要导入虚拟机的信息文件`servers.yaml`， 格式如下:

```
hosts:
  - host_ip: 10.168.222.137
    xml_file_path: /etc/libvirt/qemu
    monitor_path: /var/lib/libvirt/qemu
    servers:
      - mac: 52:54:00:4A:19:AF
        ip: 10.168.222.53
      - mac: 52:54:00:4A:19:CC
        ip: 10.168.222.54
  - host_ip: 10.168.222.130
    xml_file_path: /etc/libvirt/qemu
    monitor_path: /var/lib/libvirt/qemu
    servers:
      - mac: 53:54:00:4A:19:EC
        ip: 11.168.222.50
      - mac: 53:54:00:4A:19:EE
        ip: 11.168.222.51
```

    - `host_ip` 是要导入的宿主机的ip
    - `xml_file_path`是libvirt存储虚拟机xml文件的路径，
    - `monitor_path`是libvirt存储虚拟机monitor socket文件的路径，
    - `servers`是需要导入的虚拟机，里面描述了虚拟机的ip和mac对应关系

---
- 执行 climc servers-import-from-libvirt 开始导入

```sh
# 导入前确认libvirt服务关闭
$ climc servers-import-from-libvirt servers.yaml
```
