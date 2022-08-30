---
title: "从3.7升级到3.8"
weight: 4
description: 介绍var_oem_name产品如何进行升级操作。
---

## 升级介绍

本文档介绍{{<oem_name>}} 从v3.7.x升级到v3.8.x，以及v3.8.x升级到v3.8.y（y大于x）的步骤以及升级方法。

跨版本升级建议从相邻的版本升级，如从3.4.x升级到3.8.x，需要以下步骤

1. 从3.4.x升级到3.6.x
2. 从3.6.x升级到3.7.x
3. 从3.7.x升级到3.8.x

{{% alert title="注意" color="warning" %}}
- 3.5版本不对外发布，即3.4版本的下一个版本为3.6版本。
- 升级过程中将会同时升级控制节点和计算节点，请在空余时间执行升级操作。
{{% /alert %}}

## 从3.7.x升级到3.8.x

跨版本升级目前仅支持命令行升级。该方式对用户环境无网络要求，通过挂载安装包，执行升级命令的方式进行升级操作。

### 命令行升级步骤

1. 管理员通过ssh工具以root用户远程登录到First Node节点。

2. 自3.7版本后，只允许使用root用户进行升级操作。

3. 将高版本的DVD安装包上传到First Node节点，挂载后执行升级命令。

    ```bash
    # 将高版本的DVD安装包挂载到mnt目录
    $ mount -o loop Yunion-x86_64-DVD-3.x-x.iso /mnt 
    # 切换到/mnt/yunion目录 
    $ cd /mnt/yunion
    $ ./upgrade.sh   
    ```

4. 升级成功后界面如下图所示。
   
    ![](../../images/upgraded.png)

5. 用户可以打开{{<oem_name>}} web控制台的关于页面查看版本信息或执行以下命令查看产品版本是否符合预期。

    ```bash
    $ kubectl get oc -n onecloud default -o go-template --template='{{printf "%s\n" .spec.version}}'
    v3.8.0
    ```

## 从3.8.x升级到3.8.y

从3.8.x升级到3.8.y，除命令行升级外还支持界面升级。

### 命令行升级步骤

同[从3.7.x升级到3.8.x-命令行升级](#命令行升级步骤)

### 界面升级步骤

界面升级即在{{<oem_name>}}平台的关于页面中通过版本更新功能将平台升级。该功能要求用户环境可以访问公网，且只允许在管理后台视图下执行界面升级的操作。

1. 在管理后台视图下，单击![](../../../user/images/intro/more.png)图标，选择下拉菜单 **_"关于"_** 菜单项，进入关于页面。

    ![](../../images/about.png)

2. 单击 **_"版本更新"_** 按钮，弹出版本更新对话框。
   
    ![](../../images/upgradetip1.png)

3. 选择需要升级的版本，并选择更新方式。
    - 立即更新：更新方式选择“立即更新”，单击 **_"确定"_** 按钮。
    - 预约更新：更新方式选择“预约更新”，并设置具体的时间点，单击 **_"确定"_** 按钮。产品将会在预约的时间点进行更新操作，在未更新之前，支持取消预约更新，单击 **_"取消"_** 按钮，在弹出的操作确认对话框中单击<确定>按钮。

    ![](../../images/upgrade.png)

## 从3.0或3.1版本升级到3.2版本后，出现控制台无法访问前端的问题，该怎么解决？

**问题原因**：该问题是由于3.2之前版本进行UI迁移工作，导致前端访问URL中多了V1和V2版本的字段，而3.2版本的UI已全部迁移到V2版本，前端访问的URL中去掉了版本字段。而从3.0和3.1升级到3.2版本的环境访问时默认带着版本字段，导致用户无法访问Web前端。

**解决方法**：在First Node节点上删除web服务的configmap文件，并重启web服务即可。

```bash
# 删除default-web的configmap文件
$ kubectl delete configmap -n onecloud default-web
# 删除default-web容器
$ kubectl delete pods -n onecloud default-web-xxx
```

## 从3.0或3.1版本升级到3.2版本后，notify的pod运行状态不正常，该怎么解决？

**问题原因**：该问题时由于升级到3.2版本后，notify服务的configmap相对于之前版本有变动，而升级过程中没有删除旧的configmap导致的。

**解决方法**：在First Node节点上手动删除notify服务的configmap文件，并重启notify服务即可。

```bash
# 删除default-notify的configmap文件
$ kubectl delete configmap -n onecloud default-notify
# 删除default-notify容器
$ kubectl delete pods -n onecloud default-notify-xxx
```
