---
title: "资源同步不下来问题排查"
weight: 2
description: >
    部分资源同步不下来，问题排查
---

## 检查账号权限

- 打开云账号详情标签页, 查看是否有截图中提示的缺少权限

![](../images/lake_of_permission.png)


## 检查云订阅是否被禁用

![](../images/cloudprovider_disabled.png)

## 检查资源所在的云订阅区域是否被禁用, 同时查看同步时间，若长时间未同步，可以先手动同步下

![](../images/cloudprovider_region_disabled.png)


## 检查同步参数skip_server_sync_by_sys_tag_keys

```
# 此参数含义是若有公有云虚拟机带有特定系统标签, 则跳过此虚拟机同步，目前默认跳过腾讯云弹性伸缩组相关实例
$ climc service-config-show region2 | grep skip_server_by_sys_tag_keys
          "skip_server_by_sys_tag_keys": "acs:autoscaling:scalingGroupId",

# 若需要同步弹性伸缩组实例，可将此参数改为其他标签 
$ climc service-config --config skip_server_by_sys_tag_keys=other-tag region2
```
