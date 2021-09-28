---
title: "通用问题汇总"
date: 2021-09-28T08:22:33+08:00
weight: 200
---

## 查看虚拟机日志
- 如图点击结果为失败的日志
   ![](../../images/vm_log.png)

- Client.Timeout exceeded while awaiting headers
    - 此问题一般出现在网络环境不好，或者使用了代理
    - 请检查网络环境，或者检查代理日志，是否出现超时

- dial tcp: lookup example.com on 192.168.222.171:53: read udp 10.168.222.219:463933->192.168.222.171:53: i/o timeout
    - 此问题一般出现在DNS网络不通，不能正常解析域名
    - 请检查DNS配置，再重试操作
