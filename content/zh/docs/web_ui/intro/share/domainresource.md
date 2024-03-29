---
title: "域资源共享原则"
weight: 2
description: >
   
---

### 域资源共享原则

当{{<oem_name>}}开启三级权限后，以下域资源支持共享。当{{<oem_name>}}关闭三级权限后，域资源不支持共享。

- 宿主机、物理机、块存储、云账号、代理、二层网络、VPC、NAT网关、DNS解析等。

#### 共享原则

1. 如果域资源是通过云账号同步下来的，则域资源的共享与云账号有关。
    - 当云账号不共享时，通过云账号同步下来的资源也不能共享。
    - 当云账号启用共享时，通过云账号同步下来的资源也将随着云账号启用共享。
    - 当云账号启用共享时，通过云账号同步下来的资源可以更改共享范围，请确保共享范围在云账号的共享范围内。
    - 当云账号修改共享范围时，通过云账号同步下来的资源的共享范围要始终保持在云账号的共享范围内。如云账号共享A、B、C、D域，域资源共享A、C域，云账号修改共享范围为A、B域，则域资源只能共享到A域。
    - 云账号共享云订阅时，通过云账号同步下来的域资源不能共享。
2. 本地存储的共享范围要始终要与宿主机的共享范围保持一致。

#### 设置共享

以宿主机为例，介绍如何设置宿主机的共享范围。

域资源的共享范围有三种：

- 不共享（私有）：即域资源只能本域的用户可以使用。
- 域共享-部分（多域共享）：即域资源可以共享到指定域（一个或多个），只有域资源所在域和共享域下的用户可以使用域资源。
- 域共享-全部（全局共享）：即域资源可以共享给全部域使用，即系统中所有用户都可以使用域资源。

{{% alert title="说明" %}}
设置共享的条件：需同时满足

- 当前用户在管理后台。
- 在{{<oem_name>}}已开启三级权限。
{{% /alert %}}

**单个宿主机设置共享**

1. 在左侧导航栏，选择 **_"主机/基础资源/宿主机"_** 菜单项，进入宿主机页面。
2. 单击宿主机右侧操作列 **_"更多"_** 按钮，选择下拉菜单 **_"设置共享"_** 菜单项，弹出设置共享对话框。
3. 配置以下参数：
   - 当共享范围选择为“不共享”时，即域资源的共享范围为私有，仅本域的用户可以使用。
   - 当共享范围选择为“域共享”时，需要选择共享的域。
       - 当域选择其中的一个或多个域时，即域资源的共享范围为域共享-部分，只有域资源所在域和共享域下的用户可以使用域资源。
       - 当域选择全部时，即域资源的共享范围为域共享-全部，系统中的所有用户都可以使用域资源。
4. 单击 **_"确定"_** 按钮，完成操作。

**批量设置共享**

1. 在左侧导航栏，选择 **_"主机/基础资源/宿主机"_** 菜单项，进入宿主机页面。
2. 在宿主机列表中选择一个或多个宿主机，单击列表上方 **_"批量操作"_** 按钮，选择下拉菜单 **_"设置共享"_** 菜单项，弹出设置共享对话框。
3. 配置以下参数：
   - 当共享范围选择为“不共享”时，即域资源的共享范围为私有，仅本域的用户可以使用。
   - 当共享范围选择为“域共享”时，需要选择共享的域。
       - 当域选择其中的一个或多个域时，即域资源的共享范围为域共享-部分，只有域资源所在域和共享域下的用户可以使用域资源。
       - 当域选择全部时，即域资源的共享范围为域共享-全部，系统中的所有用户都可以使用域资源。
4. 单击 **_"确定"_** 按钮，完成操作。

