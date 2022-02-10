---
title: "启用多租户"
date: 2022-02-10T10:59:57+08:00
oem_ignore: true
weight: 30
description: >
    介绍如何配置启用多租户
---

{{<oem_name>}}平台部署完成后默认为单租户模式，即资源只能归属于Default域。如需启用多租户功能，实现将资源归属于任意域，需要开启三级权限。

![](../images/permission.png)

- 当系统未开启三级权限时，系统中仅存在default域，用户可以在default域中创建项目。
- 当系统开启三级权限后，系统中除default域外，还可以创建其他域，并在任意域中创建项目等。

### 开启三级权限

{{% alert title="注意" color="warning" %}}
三级权限开启后不支持关闭，请谨慎操作。
{{% /alert %}}

以下命令或在全局设置中开启三级权限。

<big>**界面操作**</big>

在{{<oem_name>}}平台上的系统配置-全局设置中启用三级权限

![](../images/sjqx1.png)

<big>**climc操作**</big>

```bash
# 开启三级权限
$ climc service-config --config non_default_domain_projects=true common
```