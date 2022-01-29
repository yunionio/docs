---
title: "关联虚拟机"
weight: 20
description: >
  安全组创建完成后，需要将安全组与虚拟机进行绑定，使之生效。
---

## 普通安全组

对于内置私有云虚拟机，每台虚拟机有一个主安全组，由虚拟机的 secgroup_id 字段指定。当创建主机未指定安全组时，则平台会默认关联一个安全组，该默认安全组由region服务的 default_security_group_id 指定。同时，主机还可以额外关联多个安全组（最多5个安全组）。

### climc操作

```bash
# 为主机增加安全组
climc server-add-secgroup <server> <secgroup1> <secgroup2> ...
# 全量替换主机安全组
climc server-set-secgroup <server> <secgroup1> <secgroup2> ...
# 取消安全组
climc server-revoke-secgroup <server> <secgroup>
```

通过如下命令修改region的 default_security_group_id:

```bash
climc service-config-edit region2
```

### Web控制台操作

通过web控制台关联虚拟机和安全组的操作如下：

#### 关联虚拟机

1. 在安全组页面，单击安全组右侧操作列 **_"管理虚拟机"_** 按钮，进入关联虚拟机页面。
2. 单击列表上方 **_"关联虚拟机"_** 按钮，弹出关联虚拟机对话框。
3. 选择需要关联安全组的虚拟机（支持选择多个），单击 **_"确定"_** 按钮，将安全组关联到虚拟机。

#### 解绑虚拟机

**单个解绑**

1. 在安全组页面，单击安全组右侧操作列 **_"管理虚拟机"_** 按钮，进入关联虚拟机页面。
2. 单击虚拟机右侧操作列 **_"解绑"_** 按钮，弹出操作确认对话框。
3. 单击 **_"确定"_** 按钮，完成操作。

**批量解绑**

1. 在安全组页面，单击安全组右侧操作列 **_"管理虚拟机"_** 按钮，进入关联虚拟机页面。
2. 在列表中选择一个或多个虚拟机，单击列表上方 **_"解绑"_** 按钮，弹出操作确认对话框。
3. 单击 **_"确定"_** 按钮，完成操作。

## 管理安全组

同时，每台虚拟机有一个管理安全组，由虚拟机的 admin_secgroup_id 字段指定。管理安全组只能由系统管理员权限指定，用户无法指定。管理安全组用于实现平台层面的网络安全策略，例如：禁止虚拟机访问宿主机网段，禁止虚拟机提供80/443端口服务（未在公网备案）等。主机创建时，如果region服务的 default_admin_security_group_id 设置了管理安全组的ID，则主机自动设置 admin_secgroup_id。否则，需要管理在事后，通过如下 climc 命令设置或者解除设置 管理安全组。

```bash
# 设置主机的管理安全组，只有系统管理员权限才能设置
climc server-assign-admin-secgroup <server> <secgroup>
```

```bash
# 清除主机的管理安全组，只有系统管理员权限才能设置
climc server-revoke-admin-secgroup <server>
```

通过如下命令修改region服务的 default_admin_security_group_id 配置:

```bash
climc service-config-edit region2
```

默认管理安全组在系统初始化时未设置。管理员设置了默认管理安全组后，重启region，则会自动将 admin_secgroup_id 未设置的主机 设置 admin_secgroup_id 为该 default_admin_security_group_id 。新创建的主机的 admin_secgroup_id 都会自动设置为 default_admin_security_group_id 的值。

在清除主机的管理安全组后，如果 default_admin_security_group_id 不为空，则会自动恢复为 default_admin_security_group_id 。

注意：管理安全组在应用生效时，总是会以比普通安全组高的优先级进行应用。无论如何配置，普通安全组规则无法override管理安全组的规则。
