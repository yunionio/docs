---
title: "创建虚拟机失败问题汇总"
date: 2021-06-11T08:22:33+08:00
weight: 200
---

## 查看虚拟机日志
- 如图点击结果为失败的日志
   ![](../../images/vm_log.png)

## 常见错误整理
{{< tabs >}}


{{% tab name="通用" %}}
- iStorageCache.GetIImageById: NotFoundError
    - 此错误一般是由于镜像未能及时更新导致
    - release/3.6版本及之前版本公有云镜像依赖于云账号更新，若长时间账号未全量同步，镜像可能会和公有云不一致，需要手动全量同步云账号，或设置云账号自动同步修复
    - release/3.7及之后版本，我们会周期同步公有云镜像，并将结果即时更新至阿里云OSS中，每天cloudpods会从阿里云OSS中获取最新镜像，不再依赖云账号同步，此设置仅对公有云公共镜像生效，若使用公有云自定义镜像，依然需要同步云账号更新镜像列表
{{% /tab %}}


{{% tab name="阿里云" %}}

- Failed to create specification ecs.t5-c1m1.large.processCommonRequest: SDK.ServerError\nErrorCode: InvalidParameter.NotMatch\nRecommend: https://error-center.aliyun.com/status/search?Keyword=InvalidParameter.NotMatch&source=PopGw\nRequestId: BAD90CC0-D76D-589D-9701-1516A6FC3C13\nMessage: the provided 'Image -> os_type: CentOS' and 'Rule -> os_type: exclude[Ubuntu Debian Aliyun CentOS]' are not matched.
    - 此返回结果一般是由于选择的套餐和镜像冲突导致的
    - 可以选择非UEFI的镜像避免此错误的发生
    - [Github Issue](https://github.com/yunionio/cloudpods/issues/11481)

{{% /tab %}}

{{% tab name="腾讯云" %}}
- [TencentCloudSDKError] Code=ImageQuotaLimitExceeded, Message=FailedOperation: Failed to create image as the number of image 10 cannot exceed the quota for image 10
    - 此问题出现在使用公有云私有镜像创建机器, 每个区域最多支持10个自定义镜像，可以联系腾讯云调高每个区的配额，或者删除不再使用的私有镜像
    - 偶尔会遇见区域有9个自定义镜像，依然出现这个报错

{{% /tab %}}

{{% tab name="Azure" %}}
- Allocation failed. We do not have sufficient capacity for the requested VM size in this region. Read more about improving likelihood of allocation success at http://aka.ms/allocation-guidance\ 
    - 此问题一般出现在Azure资源不足，或者套餐在所选的region不可用
    - 请更换套餐，或者更换区域再尝试创建

{{% /tab %}}

{{% tab name="AWS" %}}
- Failed to create specification c6g.medium.Unsupported: The requested configuration is currently not supported. Please check the documentation for supported configurations
    - 当前账号不支持c6g.medium套餐，未找到原因，其他账号可能支持
    - 目前出现这个错误只能去更换套餐

{{% /tab %}}

{{< /tabs >}}
