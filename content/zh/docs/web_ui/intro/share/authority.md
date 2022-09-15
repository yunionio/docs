---
title: "三级权限说明"
weight: 1
edition: ee
description: >
     介绍 var_oem_name 平台的三级权限使用说明。
---

- 当系统未开启三级权限时，系统中仅存在default域，用户可以在default域中创建项目。
- 当系统开启三级权限后，系统中除default域外，还可以创建其他域，并在任意域中创建项目等。

如下图所示：

![](../../../images/intro/permission.png)

系统安装完成后默认关闭三级权限，可通过以下命令或在全局设置中开启三级权限。

三级权限开启方法如下：

{{% alert title="注意" color="warning" %}}
三级权限开启后不支持关闭，请谨慎操作。
{{% /alert %}}

- 推荐在{{<oem_name>}}平台上的系统配置-全局设置中启用三级权限。

    ![](../../../images/intro/sjqx1.png)
- 通过climc命令在First Node节点上配置启用三级权限。
    
    ```bash
    # 开启三级权限
    $ climc service-config --config non_default_domain_projects=true common
    ```
