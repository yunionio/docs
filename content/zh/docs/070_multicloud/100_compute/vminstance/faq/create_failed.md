---
title: "创建虚拟机失败"
date: 2021-06-11T08:22:33+08:00
weight: 200
---

## 查看虚拟机日志
- 如图点击结果为失败的日志
   ![](../../images/vm_log.png)

## 常见错误整理
{{< tabs >}}

{{% tab name="阿里云" %}}

- Failed to create specification ecs.t5-c1m1.large.processCommonRequest: SDK.ServerError\nErrorCode: InvalidParameter.NotMatch\nRecommend: https://error-center.aliyun.com/status/search?Keyword=InvalidParameter.NotMatch&source=PopGw\nRequestId: BAD90CC0-D76D-589D-9701-1516A6FC3C13\nMessage: the provided 'Image -> os_type: CentOS' and 'Rule -> os_type: exclude[Ubuntu Debian Aliyun CentOS]' are not matched.
    - 此返回结果一般是由于选择的套餐和镜像冲突导致的
    - 可以选择非UEFI的镜像避免此错误的发生
    - [Github Issue](https://github.com/yunionio/cloudpods/issues/11481)

{{% / tab %}}

{{< /tabs >}}
