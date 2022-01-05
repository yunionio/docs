---
title: "修改代理"
weight: 40
description: >
    修改代理的配置信息
---

该功能用于修改代理信息，Direct（直连）代理不支持修改属性。

1. 在代理列表，单击代理右侧操作列 **_"修改属性"_** 按钮，弹出修改属性对话框。
2. 支持修改以下参数：
   - https代理：当请求的url连接为https时，优先使用https代理。https代理为空则使用http代理。https代理可设置为HTTP型代理或socks5://协议代理。若设置代理，建议https代理或http代理至少设置一个。
   - http代理：当请求的url连接为http时，或请求的url连接为https，但未配置https代理时，都使用http代理。http代理可设置为HTTP型代理或socks5://协议代理。若设置代理，建议https代理或http代理至少设置一个。
   - 不走代理地址：即设置不走代理的白名单。设置代理后，访问白名单中的IP地址时不需要经过代理。支持设置域名和IP地址，多个以英文状态的逗号分隔，例如：foo.com,.bar.com,7.7.7.7,8.8.8.8/8,9.9.9.9:80。
3. 单击 **_"连接测试"_** 按钮，测试https代理和http代理是否可以访问。
4. 单击 **_"确定"_** 按钮，完成修改。

```bash
# 修改proxy代理
$ climc proxysetting-update [--http-proxy HTTP_PROXY] [--https-proxy HTTPS_PROXY] [--no-proxy NO_PROXY] [--name NAME] <ID>

```