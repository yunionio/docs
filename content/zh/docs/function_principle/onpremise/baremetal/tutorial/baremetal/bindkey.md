---
title: "绑定/解绑密钥"
date: 2022-02-08T11:14:15+08:00
weight: 80
description: >
    为裸金属服务器绑定或解绑密钥
---
###  前提条件

在绑定密钥之前请[创建密钥](../../../../keypair/tutorial/create)

### 绑定密钥

该功能用于为裸金属服务器绑定密钥，密钥绑定后用户需要使用私钥登录裸金属服务器，或通过私钥在云管平台上获取裸金属服务器的密码。在绑定密钥之前请创建密钥。一个裸金属服务器只支持绑定一个密钥，当绑定密钥后，用户在裸金属列表的密码列无法直接看到密码信息，需要输入私钥内容获取密码。

{{% alert title="注意" color="warning" %}}
- 仅在裸金属服务器关机状态下支持绑定密钥操作。
- 通过ISO启动方式创建的裸金属不支持绑定密钥操作。
{{% /alert %}}

1. 在左侧导航栏，选择 **_"主机/主机/裸金属"_** 菜单项，进入裸金属页面。
2. 单击裸金属服务器右侧操作列 **_"更多"_** 按钮，选择下拉菜单 **_"绑定密钥"_** 菜单项，弹出绑定密钥对话框。
3. 选择密钥对，默认勾选“绑定密钥后自动启动”，可根据需要取消勾选，单击 **_"确定"_** 按钮，绑定密钥的裸金属需要使用SSH密钥对登录。

### 解绑密钥

该功能用于将裸金属服务器与密钥解除绑定。

{{% alert title="注意" color="warning" %}}
- 仅在裸金属服务器关机状态下支持解绑密钥操作。
- 通过ISO启动方式创建的裸金属不支持解绑密钥操作。
{{% /alert %}}

1. 在左侧导航栏，选择 **_"主机/主机/裸金属"_** 菜单项，进入裸金属页面。
2. 在左侧导航栏，选择 **_"主机/主机/裸金属"_** 菜单项，进入裸金属页面。
2. 单击裸金属服务器右侧操作列 **_"更多"_** 按钮，选择下拉菜单 **_"解绑密钥"_** 菜单项，弹出绑定密钥对话框。
3. 默认勾选“绑定密钥后自动启动”，可根据需要取消勾选，单击 **_"确定"_** 按钮，完成操作。