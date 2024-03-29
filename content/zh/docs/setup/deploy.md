---
title: "初始化引导"
edition: ee
weight: 6
description:   >
    当var_oem_name的First Node部署成功后，用户可根据使用场景快速引导配置var_oem_name平台。
---

## 设置管理员用户

1. 当First Node节点部署完成后，用户在浏览器中输入First Node节点的IP地址，如提示“您的连接不是私密连接”，请单击 **_"高级"_** 按钮，并单击“继续前往x.x.x.x（不安全）”，打开云管平台控制台。
    
    ![](../images/warning.png)

2. 在管理员注册页面，设置管理员账号、密码，单击 **_"注册"_** 按钮，创建管理员用户。

    ![](../images/cloudadmin1.png)

3. 选择创建的管理员账号，输入密码，登录云管平台。

    ![](../images/cloudadminlogin1.png)
    ![](../images/login1.png)

## 授权激活

{{<oem_name>}} 安装完成后，用户需要申请试用License激活{{<oem_name>}}。如需要购买正式版License，请联系我们销售人员或通过联系邮箱获取支持。

1. 用户首次登录将会强制弹出{{<oem_name>}}授权激活对话框。未激活的{{<oem_name>}}无法使用。
2. 请复制服务器识别码，按照下方提示在线上免费申请License或联系销售人员获取License文件。
3. 将获取的License文件上传即可成功激活{{<oem_name>}}。

## 功能选择

{{<oem_name>}}产品激活成功后，系统将根据License中包含的功能展示可选择的功能项，未购买功能将置灰不可勾选。此外用户还可以根据使用场景进行功能选择，系统将根据用户选择的功能或平台显示对应的菜单项，其他无关菜单将会隐藏，请根据实际情况进行选择，后续如需调整可单击系统右上角![](../images/more.png)图标，选择 **_"功能选择"_** 菜单项，重新进入功能选择页面。

{{% alert title="说明" %}}
- 裸金属和负载均衡功能必须选择了KVM之后才能勾选；
- Kubernetes容器模块必须勾选{{<oem_name>}}私有云、公有云纳管、私有云&虚拟化平台的任意一项后，才能勾选；
{{% /alert %}}

![](../images/guide.png)

- 当用户在功能选择中只有第一次选择{{<oem_name>}}私有云时才会进入{{<oem_name>}}私有云平台引导流程，具体请参考[私有云场景引导](#私有云场景引导)。
- 当用户选择公有云纳管、私有云&虚拟化平台、对象存储时，将会直接跳转到云账号页面，添加对应平台的云账号等。

### 私有云场景引导

以勾选全部功能为例。

{{% alert title="说明" %}}
- 平台部署完成后默认未开启三级权限。引导过程中创建的资源默认都属于default域。
- 在引导过程中如用户不想配置某页面内容，可直接单击 **_"跳过"_** 按钮跳过该页面配置，进入下一页。
{{% /alert %}}

该引导流程用于帮助用户快速在{{<oem_name>}}上配置内置私有云的计算、存储、网络资源，使用户可以创建{{<oem_name>}}平台的虚拟机。

1. 在区域页面设置区域名称和备注，单击 **_"下一步"_** 按钮。
{{% alert title="说明" %}}
- 区域指数据中心所在的地理位置，一般为城市，比如：北京、青岛等。
- 内置私有云默认有且仅有一个区域。区域名称仅可以在系统引导中修改。
- 区域包含可用区、VPC、二层网络、IP子网、宿主机、存储等资源。
{{% /alert %}}
    ![](../images/onestackregion1.png)

2. 在可用区页面设置可用区名称和备注，支持同时新增多个可用区，单击 **_"下一步"_** 按钮。
{{% alert title="说明" %}}
- 可用区指在同一区域内，电力和网络相互独立的物理区域，一般指一个机房的名称，例如：望京、酒仙桥、兆维等。
- 可用区是区域子资源，可用区默认属于上一步骤创建的区域。OneStack只支持一个区域。
- 可用区包含二层网络、IP资源、宿主机、存储等资源。
- 可通过创建多个可用区或一个可用区下创建多个二层网络做调度隔离。
{{% /alert %}}
    ![](../images/onestackzone1.png)

3. 在二层网络页面选择可用区，并在可用区下设置二层网络的名称、带宽和备注，支持同时创建多个二层网络。单击 **_"下一步"_** 按钮。
{{% alert title="说明" %}}
- 二层网络是指在IP子网之上做的一层逻辑的网络隔离。可通过创建多个二层网络做调度隔离。
- 二层网络是可用区的子资源，可在不同可用区下创建多个二层网络。
- 在二层网络下的虚拟机带宽限制默认都为二层网络的带宽。
{{% /alert %}}
    ![](../images/onestackwire1.png)

4. 在IP子网页面选择二层网络并在二层网络下创建虚拟机的IP子网的名称、起始IP地址、结束IP地址、子网掩码和默认网关地址，单击 **_"下一步"_** 按钮。
{{% alert title="说明" %}}
- 在该步骤创建的IP子网属于经典网络的IP子网，可用来创建虚拟机和裸金属服务器。
- 目前仅支持在一个二层网络下创建多个IP子网。
- 最多支持同时创建5个IP子网。
{{% /alert %}}

    ![](../images/onestacknetwork1.png)

5. 在宿主机页面，启用宿主机，单击 **_"下一步"_** 按钮。
{{% alert title="说明" %}}
- 请确保至少有一个宿主机被启用，否则将不会出现虚拟机菜单，也无法进行下一步。
- 宿主机是可用区的子资源，本次创建默认展示了所有可用区中的宿主机。
{{% /alert %}}

    ![](../images/onestackhost1.png)

6. 在本地存储页面，支持设置本地存储的存储类型，单击 **_"下一步"_** 按钮。
{{% alert title="说明" %}}
- 本地存储为宿主机上的存储，默认展现了所有可用区下宿主机的存储。
{{% /alert %}}
    ![](../images/onestacklocalstorage1.png)

7. 在共享存储页面，支持新建共享存储以及将共享存储挂载宿主机使用。共享存储配置完成后，单击 **_"下一步"_** 按钮。
    - 新建共享存储：单击 **_"新建共享存储"_** 按钮，在弹出的新建对话框中配置以下信息：
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
    - 关联宿主机：单击共享存储右侧操作列 **_关联宿主机_** 按钮，在弹出的关联宿主机对话框中选择宿主机和挂载点，单击 **_"确定"_** 按钮。
{{% alert title="说明" %}}
- 共享存储是可用区的子资源，支持添加多个共享存储。
- 共享存储支持关联多个宿主机。
{{% /alert %}}

    ![](../images/onestacksharestorage1.png)

9. 在镜像页面可根据需要导入或上传{{<oem_name>}}平台的镜像，单击 **_"下一步"_** 按钮。

{{% alert title="说明" %}}
- 在{{<oem_name>}}平台的镜像可适配所有平台使用；
- 平台提供镜像市场功能，用户可以直接使用从镜像市场导入的镜像创建虚拟机，但是要求First Node节点可以访问外网，从镜像市场导入一个镜像大约需要20~30分钟。
- 通过URL上传完镜像后，系统会自动将镜像（除ISO镜像外）转换为多种系统可用格式，适配所有平台。转换过程大约需要10~15分钟。

{{% /alert %}}
    ![](../images/onestackimage1.png)

11.  完成引导并跳转到云账号页面，用户可根据需求添加其他平台的云账号。


