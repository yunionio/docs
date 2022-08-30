---
title: "角色"
date: 2021-12-08T16:26:09+08:00
weight: 60
description: >
    角色是一系列权限的集合
---

角色是一系列权限的集合，用户加入项目时的角色决定了用户在项目中的权限。

系统内置角色说明如下：

| 角色          | 权限          | 是否共享 | 权限范围 | 权限说明                                                     |
| ------------- | ------------- |-------- |  -------- | ----------------------------------------------------------- |
| admin         | sysadmin      | 全局共享     | 系统     | 用户只有以admin角色加入default的system项目时才有管理后台全部权限。 |
| domainadmin   | domainadmin   | 全局共享     | 域       | 域管理后台全部权限     |
| project_owner | projectadmin | 全局共享     | 项目     | 项目范围内的全部权限                                         |
| project_editor | projecteditor | 全局共享 | 项目 | 项目范围内任意资源的编辑操作权限     |
| member        | projectviewer、projectdashboard  | 全局共享  | 项目     | 项目范围内任意资源的只读权限   |
| fa            | sysmeteradmin、sysdashboard  |  全局共享     | 系统 | 系统内计费计量的全部权限   |

### 前提条件

可管理角色的视图

- 管理后台视图
- 域管理后台视图（需开启三级权限）