---
title: "创建页面无任何资源"
date: 2021-09-01T16:57:43+08:00
weight: 30
---

## 现象

1. 如下图所示, 创建页面无任何可选资源
   ![](../images/no_region.png)


## 可能的原因

- 前端缓存
    1. 可通过刷新整个页面解决
- 当前所选的域底下没有 **可用** 的云账号
    1. [创建云账号](../../../../../web_ui/multiplecloud/cloudaccount/cloudaccount) 到所选域
- 云账号健康状态异常
    1. 查看 [健康检查](../../../../../function_principle/multicloud/cloudaccounts/health_check)
- 没有可用套餐
    1. 同步套餐异常(一般是由于外网不通引起的)
    2. 请查看控制节点到 `https://yunionmeta.oss-cn-beijing.aliyuncs.com` 是否可以正常通信
    3. 再次同步云账号
- 没有可用的IP子网
    1. 页面默认显示的是有ip子网的平台和区域
    2. 若页面中没有想要的平台或区域，请确保要选定的平台及区域有正常的ip子网
