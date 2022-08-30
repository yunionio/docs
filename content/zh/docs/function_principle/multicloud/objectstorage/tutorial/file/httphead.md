---
title: "设置HTTP头"
date: 2021-11-26T17:03:55+08:00
weight: 60
description: >
    设置文件的HTTP头部
---

该功能用于设置文件的HTTP头，当文件的HTTP头编码与文件本身的编码不对应时会导致文件通过浏览器打开显示乱码，此时用户可以通过设置HTTP头功能改变文件的默认HTTP头的编码方式。

**单个文件设置HTTP头**

1. 在左侧导航栏，选择 **_"存储/对象存储/存储桶"_** 菜单项，进入存储桶页面。
2. 单击指定存储桶名称项，进入文件列表页面。 
2. 单击文件右侧操作列的 **_"更多"_** 按钮，选择 **_"设置HTTP头"_** 菜单项，弹出设置HTTP头对话框。
3. 设置以下参数：
   - Content-Type：文件类型，如image/png、"text/html; charset=UTF-8"等。
   - Content-Encoding：编码方式，如gzip、compress、identity等。
   - Content-Language：语言，如de-DE、en-CA等。
   - Content-Disposition：内容呈现方式，其中inline表示可以在浏览器中和页面内容一起显示（如图片），attachment表示是下载的内容。
   - Cache-Control：缓存控制，如no-cache、no-store等。
4. 单击 **_"确定"_** 按钮，完成操作。

**批量设置HTTP头**

1. 在左侧导航栏，选择 **_"存储/对象存储/存储桶"_** 菜单项，进入存储桶页面。
2. 单击指定存储桶名称项，进入文件列表页面。 
2. 在文件列表中选择一个或多个文件，单击列表上方 **_"更多"_** 按钮，选择 **_"设置HTTP头"_** 菜单项，弹出设置HTTP头对话框。
3. 设置以下参数：
   - Content-Type：文件类型，如image/png、"text/html; charset=UTF-8"等。
   - Content-Encoding：编码方式，如gzip、compress、identity等。
   - Content-Language：语言，如de-DE、en-CA等。
   - Content-Disposition：内容呈现方式，其中inline表示可以在浏览器中和页面内容一起显示（如图片），attachment表示是下载的内容。
   - Cache-Control：缓存控制，如no-cache、no-store等。
4. 单击 **_"确定"_** 按钮，完成操作。