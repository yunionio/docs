---
title: "其他操作"
date: 2019-07-19T17:29:09+08:00
weight: 100
---

## 导入镜像

### 界面操作

该功能用于上传系统镜像文件，用户上传的镜像文件默认为自定义镜像。

1. 在系统镜像页面，单击 **_"上传"_** 按钮，进入上传镜像页面。
2. 设置以下参数：
   - 指定项目：选择系统镜像的所属项目。
   - 镜像名称：设置镜像的名称，建议名称与镜像的发行版本相关。
   - 发行版、版本号：镜像的发行版本。
   - CPU架构：支持x86和ARM架构。
   - 系统位数：支持32bit和64bit。请根据实际情况选择CPU架构和系统位数。
   - 上传方式：支持上传镜像文件和输入镜像URL两种方式。虚拟机镜像列表支持上传后缀为QCOW2、VMDK、RAW、VHD格式的镜像。ISO镜像列表仅支持上传ISO后缀的镜像。
     - 上传镜像文件：表示选择当前浏览器可访问的镜像直接上传。
     - 输入镜像URL：通过URL路径来添加镜像。目前仅支持以http、https开头的url链接。格式为 [http://path/file](http://path/file) 或 [https://path/file](https://path/file)。

### climc

云平台的 glance 镜像服务支持从外部 url 导入镜像，对应 climc 的子命令为 `image-import`　。

```bash
# 导入 https://iso.yunion.cn/yumrepo-3.2/images/cirros-0.4.0-x86_64-disk.qcow2 镜像
$ climc image-import --format qcow2 --os-type Linux cirros-test.qcow2 https://iso.yunion.cn/yumrepo-3.2/images/cirros-0.4.0-x86_64-disk.qcow2
```

使用 `image-list` 或 `image-show` 查询导入镜像的状态，变为 active 时表明可以使用。

## 下载镜像

如果需要将云平台的镜像导出到本地，就需要用 `climc image-download` 把 glance 存的镜像下载下来。

参考 [查询镜像](../query/) 查询你想要下载的镜像，获取镜像 id 或 name。

下载镜像:

```bash
# OUTPUT 指定镜像的保存路径和文件名称，如/root/test.qcow2
$ climc image-download [--output OUTPUT] <image_id>
```

## 删除镜像

### 界面操作

该功能用于删除系统镜像，当系统镜像名称项右侧有![](../../../images/computing/delprotect1.png)图标，表示系统镜像启用了删除保护，无法删除系统镜像，如需删除系统镜像，需要先禁用删除保护。从镜像市场导入的系统镜像删除后将重新回到未导入页面。

{{% alert title="说明" %}}
- 管理员可以删除所有系统镜像。
- 域管理员只可以删除本域的系统镜像。
- 项目用户只可以删除本项目的系统镜像。
{{% /alert %}}

**单个删除**

1. 在系统镜像页面，单击系统镜像名称右侧带有![](../../../images/computing/delprotect1.png)图标时，单击系统镜像右侧操作列 **_"更多"_** 按钮，选择下拉菜单 **_"设置删除保护"_** 菜单项，弹出设置删除保护对话框。
2. 选择“禁用”删除保护，单击 **_"确定"_** 按钮。
3. 单击镜像右侧操作列的 **_"更多"_** 按钮，选择下拉菜单 **_"删除"_** 菜单项，弹出操作确认对话框。
4. 单击 **_"确定"_** 按钮，完成操作。

**批量删除**

1. 在系统镜像列表中勾选一个或多个系统镜像，单击列表上方 **_"批量操作"_** 按钮，选择下拉菜单 **_"设置删除保护"_** 菜单项，弹出设置删除保护对话框。
2. 选择“禁用”删除保护，单击 **_"确定"_** 按钮，批量为系统镜像禁用删除保护。
3. 在系统镜像列表中选择一个或多个镜像，单击列表上方 **_"批量操作"_** 按钮，选择下拉菜单 **_"删除"_** 菜单项，弹出操作确认对话框。
4. 单击 **_"确定"_** 按钮，完成操作。

### Climc

镜像默认启用了删除保护，当镜像确定不用了，需要先通过`climc image-update`禁用删除保护，再通过 `climc image-delete` 删除镜像。

```bash

# 禁用镜像删除保护
$ climc image-update --unprotected <image_id>
# 删除镜像
$ climc image-delete <image_id>
```
