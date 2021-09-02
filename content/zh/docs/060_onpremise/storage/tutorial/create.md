---
title: "添加共享存储"
weight: 1
---

## Web界面操作

该功能用于连接Ceph分布式存储、NFS网络文件系统以及GPFS共享存储，存储创建完成后还需要关联宿主机操作才能被用户使用。

1. 单击列表上方 **_"新建"_** 按钮，弹出新建存储对话框。
2. 配置以下参数：
   - 指定域：选择存储的所属域。
   - 区域 ：设置区域和可用区。
   - 名称：存储的名称。
   - 介质类型：存储设备的介质类型，包括机械盘、固态盘和混合盘。性能固态盘>混合盘>机械盘。
   - 存储类型：包括Ceph、NFS、GPFS三种。
      - 当选择存储类型为"Ceph“时，配置以下参数。Ceph类型存储要求本地数据中心存在Ceph存储集群。
          - Ceph Mon Host：Ceph存储的监控节点的IP地址。
          - Ceph Key：Ceph存储集群默认启用密钥认证，Ceph Key即用户的密钥，格式为为“AQDsBh5b1CtoHxAA9atFhYn1cPBJvPCpoRVo/g==”形式的字符串。可通过以下命令获取Ceph存储的用户密钥。

            ```bash
            $ cat ceph.client.admin.keyring | grep key
            ```

          - Ceph Pool：Ceph存储的存储池。
      - 当选择存储类型为"NFS“时，配置以下参数。NFS类型存储要求本地数据中心存储NFS网络存储服务器。
          - NFS Host：NFS服务器的IP地址。
          - NFS Shared Dir：NFS服务器设置的共享目录。
      - 当选择存储类型为”GPFS“时，无需配置任何参数。GPFS类型存储要求本地数据中心存在共享存储，并且需挂载存储的宿主机已关联该存储。
3. 单击 **_"确定"_** 按钮，完成操作。
