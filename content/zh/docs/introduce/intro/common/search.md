---
title: "搜索"
date: 2022-02-09T19:16:42+08:00
weight: 20
description: >
    介绍 var_oem_name 平台资源列表的搜索功能
---

{{<oem_name>}}平台中的所有资源页面都支持搜索功能，支持根据平台、区域、名称等条件快速搜索到符合条件的资源。以虚拟机为例介绍下搜索功能的使用。

![](../../images/search1.png)

搜索规则如下：

- 在搜索框中输入关键字，并按回车键，将搜索名称包含关键字（字母）或IP包含关键字（数字）的资源。如搜索名称包含host的资源。

   ![](../../images/keysearch.png)

- 资源属性搜索：单击搜索框，根据资源属性（如平台、所属项目、IP、状态等）进行搜索。支持同时搜索多个资源属性。如搜索项目为system下平台为{{<oem_name>}}的资源。
  
   ![](../../images/searchrange.png)

   ![](../../images/searchresult.png)