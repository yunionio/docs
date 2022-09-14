---
title: "云账号删除失败问题排查"
date: 2021-07-05T08:22:33+08:00
weight: 4
description: >
    记录云账号删除失败原因及解决方案 
---


#### 1. Virtual disk **** used by virtual servers

出现此问题一般是由于磁盘漂移导致的，多出现在vmware和私有云账号

解决方案:
- 清理账号的云主机资源([参考文档](../../../../function_principle/onpremise/vminstance/purge))
- 再次删除云账号
