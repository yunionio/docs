---
title: "新建代理"
weight: 10
description: >
    新建proxy代理
---

该功能用于为指定域创建代理，当在指定域新建云账号时可选择域下的代理连接访问云平台。

1. 在左侧导航栏，选择 **_"多云管理/云账号/代理"_** 菜单项，进入代理页面。
2. 单击列表上方 **_"新建"_** 按钮，弹出新建代理对话框。
2. 设置以下参数：
   - 指定域：选择代理所属的域。
   - 名称：代理的名称。
   - https代理：当请求的url连接为https时，优先使用https代理。https代理为空则使用http代理。https代理可设置为HTTP型代理或socks5://协议代理。若设置代理，建议https代理或http代理至少设置一个。
   - http代理：当请求的url连接为http时，或请求的url连接为https，但未配置https代理时，都使用http代理。http代理可设置为HTTP型代理或socks5://协议代理。若设置代理，建议https代理或http代理至少设置一个。
   - 不走代理地址：即设置不走代理的白名单。设置代理后，访问白名单中的IP地址时不需要经过代理。支持设置域名和IP地址，多个以英文状态的逗号分隔，例如：foo.com,.bar.com,7.7.7.7,8.8.8.8/8,9.9.9.9:80。
3. 单击 **_"连接测试"_** 按钮，测试https代理和http代理是否可以访问。
4. 单击 **_"确定"_** 按钮，完成操作。

```bash
# 新建proxy代理
$ climc proxysetting-create [--https-proxy HTTPS_PROXY] [--no-proxy NO_PROXY] [--http-proxy HTTP_PROXY] <NAME>

```
