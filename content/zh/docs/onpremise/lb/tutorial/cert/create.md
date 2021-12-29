---
title: "新建证书"
date: 2021-12-17T15:53:58+08:00
weight: 10
description: >
    新建证书
---


{{% alert title="说明" %}}

**常用证书申请流程**：

- 本地生成私钥：openssl genrsa -out privateKey.pem 2048 ，其中生成的privateKey.pem为私钥文件，请妥善保管。
- 生成证书请求文件：openssl req -new -key privateKey.pem -out server.csr ，其中server.csr是证书请求文件，可用其去申请证书。
- 获取请求文件中的内容前往 CA 等机构站点申请证书。
{{% /alert %}}

1. 单击列表上方 **_"新建"_** 按钮，弹出新建证书对话框。
2. 设置以下参数：
    - 证书名称：设置证书名称。
    - 证书内容：cert.pem证书的内容，证书内容要求：
        - 以-----BEGIN CERTIFICATE-----开头,以-----END CERTIFICATE-----结尾；
        - 每行64个字符，最后一行长度可以不足64个字符；
        - 证书内容不能包含空格。
    - 证书密钥：privkey.pem密钥的内容，密钥内容要求：
        - 以-----BEGIN RSA PRIVATE KEY-----开头,以-----END RSA PRIVATE KEY-----结尾；
        - 每行64个字符，最后一行长度可以不足64个字符；
        - 证书密钥内容不能包含空格。
3. 单击 **_"确定"_** 按钮，新建证书。