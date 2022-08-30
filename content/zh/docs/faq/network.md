---
title: "网络"
linktitle: "网络"
weight: 7
description: >
 帮助用户解决网络方面的问题，涵盖VPC、二层网络、IP子网、域名服务、安全组、弹性网卡、EIP、负载均衡内容。
---



## 网络管理包括哪些内容？

主要包括VPC、二层网络、IP子网、预留IP、安全组、EIP、弹性网卡、密钥、域名服务等方面内容。

## 产品支持哪些速率的网络接口？

支持40G、千兆、万兆等速率的网络接口，实际生产环境建议千兆以上。

## 管理网络和数据网络放在一起会影响吗？

建议将管理网络和数据网络分离，提高安全性，合理网络负载分担。如果网络资源不足，可以放在一起。

## 产品提供的DHCP服务和目前机房的DHCP是否会出现冲突？

{{<oem_name>}}的DHCP服务与目前机房已经配置的DHCP服务不冲突，{{<oem_name>}}的DHCP广播报文仅对纳管的计算资源生效。但{{<oem_name>}}里面的虚拟机使用的网络段不可与当前环境内已经使用的IP范围重叠，如果发生重叠，可能发生IP地址冲突。

## 同一个三层网络是否支持设置不同的子网掩码和网关？

支持，管理员可以规划并设置多个IP子网。

## 若Linux服务器网卡接口名称不是eth0，eth1…，如何将网卡名称改为eth0等?

自CentOS 7、Ubuntu 14.04LTS之后为了让网卡名称在硬件变更（例如增加网卡或减少网卡）前后持久化显示，将使用网卡的BIOS地址命名网卡，这样网卡名称将不再为eth0、eth1…，而是显示为ens192、enp1s等名称。下面以CentOS 7为例介绍如何关闭网卡的持久化命名的功能。

1. 修改/etc/default/grub文件，在GRUB_CMDLINE_LINUX增加“net.ifnames = 0 biosdevname = 0”的参数。

    ```bash
    GRUB_TIMEOUT=5
    GRUB_DISTRIBUTOR="$(sed 's, release .*$,,g' /etc/system-release)"
    GRUB_DEFAULT=saved
    GRUB_DISABLE_SUBMENU=true
    GRUB_TERMINAL_OUTPUT="console"
    GRUB_CMDLINE_LINUX="crashkernel=auto rhgb quiet intel_iommu=on iommu=pt vfio_iommu_type1.allow_unsafe_interrupts=1 rdblacklist=nouveau nouveau.modeset=0 net.ifnames=0 biosdevname=0"
    GRUB_DISABLE_RECOVERY="true"
    ```

2. 修改完成后，执行以下命令生成启动文件。

    1. 若服务器是BIOS启动，执行以下命令：

    ```bash
    $ grub2-mkconfig -o /boot/grub2/grub.cfg
    ```

    2. 若服务器是UEFI启动，执行以下命令：

    ```bash
    $ grub2-mkconfig -o /boot/efi/EFI/centos/grub.cfg
    ```

3. 重启系统后，查看MAC对应的网卡名称是否已修改为eth0。
