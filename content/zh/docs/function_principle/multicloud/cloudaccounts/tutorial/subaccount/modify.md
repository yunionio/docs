---
title: "修改本地用户"
weight: 30
description: >
    修改云用户关联的本地用户
---

该功能用于修改云用户关联的本地用户。修改本地用户操作将会重置云用户的密码。

{{% alert title="注意" color="warning" %}}
谷歌云平台的云用户关联本地用户时不会重置密码。
{{% /alert %}}

1. 在左侧导航栏，选择 **_"多云管理/云账号/云账号"_** 菜单项，进入云账号页面。
2. 单击公有云平台云账号名称项，进入云账号详情页面。
2. 单击“云用户”页签，进入云用户页面。
3. 单击云用户右侧操作列 **_"更多"_** 按钮，选择下拉菜单 **_"修改本地用户"_** 菜单项，弹出修改本地用户对话框。
4. 选择本地用户，单击 **_"确定"_** 按钮。

{{% alert title="说明" %}}
**管理后台**

- 当云账号共享范围是私有或共享云订阅时，仅可以选择加入云账号所在域下项目的用户。
- 当云账号共享范围是全局共享时，可以选择加入加入任意域下的项目的用户。

**域管理后台**

- 无论云账号共享范围如何，仅可以选择加入本域下项目的用户。
{{% /alert %}}