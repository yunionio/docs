---
title: "删除"
date: 2022-03-15T15:22:06+08:00
weight: 80
description: >
    删除未关联宿主机的块存储
---


该功能用于删除块存储。当块存储未关联宿主机、且存储下没有硬盘文件和缓存文件时可删除。

{{% alert title="说明" %}}
- 本地存储不支持删除。
- 若块存储未关联宿主机、且存储下没有硬盘文件和缓存文件，仍删除不了存储，可能是硬盘文件未彻底删除存放在回收站中，请在回收站中清除硬盘。
{{% /alert %}}

1. 在左侧导航栏，选择 **_"存储/块存储/块存储"_** 菜单项，进入块存储页面。
2. 根据需要删除块存储的数量，选择删除方式。
    - 删除单个块存储：单击指定块存储右侧操作列 **_更多_** 按钮，选择下拉菜单 **_"删除"_** 菜单项，在弹出操作确认对话框中单击 **_"确定"_** 按钮。
    - 删除多个块存储：在存储列表中勾选一个或多个存储，单击列表上方 **_删除_** 按钮，在弹出操作确认对话框中单击 **_"确定"_** 按钮。