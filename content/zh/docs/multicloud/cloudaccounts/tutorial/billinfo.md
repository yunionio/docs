---
title: "获取云平台账单信息"
date: 2021-06-11T08:22:33+08:00
weight: 220
edition: ee
description: >
    介绍如何获取公有云账单的相关信息
---

{{< tabs >}}

{{% tab name="阿里云" %}}

### 获取阿里云账单存储桶URL

1. 以阿里云主账号为例，以主账号登录阿里云控制台，单击顶部[费用]菜单的下拉菜单 **_"用户中心"_** 菜单项，进入费用用户中心页面。
   ![](../../images/aliyunusercenter.png)

2. 单击 **_"账单数据存储"_** 按钮，进入账单数据存储页面。
   ![](../../images/aliyunusercenterhome.png)

3. 查看并记录计费项消费影响和实例消费明细的bucket名称，如未设置，需要在该页面添加存储文件的订阅bucket，设置完成后，每天的增量账单数据将同步存储到对应的OSS上。建议该bucket中仅存放账单文件。
   ![](../../images/aliyunossbucket.png)

4. 在阿里云控制台的对象存储页面中，查看对应bucket的概览信息，bucket域名即为存储桶URL。
   ![](../../images/aliyunbucketurl.png) 

{{% /tab %}}


{{% tab name="AWS" %}}

### 获取AWS账单存储桶URL

**新版**

2019/08/07日期之后创建的AWS账号必须采用该方式配置并获取存储桶的URL和文件前缀。

1. 使用AWS主账号登录AWS管理控制台，单击右上角[用户名]的下拉菜单 **_"我的账单控制面板"_** 菜单项，进入账单和成本管理控制面板页面。
    
    ![](../../images/awsbilling.png)

2. 单击左侧菜单 **_"Cost & Usage Reoports"_** 菜单项，在AWS成本和使用率报告页面，单击 **_"创建报告"_** 按钮，进入创建报告页面。

    ![](../../images/awscostreport.png)

3. 配置报告名称、勾选“包括资源ID”，单击 **_"下一步"_** 按钮，进入交付选项页面。

    ![](../../images/awscreatecostreport.png)

4. 配置S3存储桶，支持选择已有的存储桶或创建新的存储桶。

    ![](../../images/awscosts3.png)
    ![](../../images/awscosts3policy.png)

5. 配置报告路径前缀、时间粒度选择“每小时”、报告版本为“创建新报告版本”、压缩类型选择“ZIP”，单击 **_"下一步"_** 按钮，进入审核页面。

    ![](../../images/awscostreportconfig.png)

6. 确认配置无误后，记录红框中的S3存储桶和报告路径前缀，单击 **_"查看和完成"_** 按钮，完成配置，创建报告。

    ![](../../images/awscostreportfinish.png)

7. 在AWS控制台的S3存储管理页面中查看对应存储桶中任意账单文件的概述信息，并记录对象URL，存储桶URL即为去掉后面文件名称的URL，如红框所示。

    ![](../../images/awscosts3bucketurl.png)

8. 文件前缀即为步骤6中红框中的报告路径前缀。

**旧版**

1. 使用AWS主账号登录AWS管理控制台，单击右上角[用户名]的下拉菜单 **_"我的账单控制面板"_** 菜单项，进入账单和成本管理控制面板页面。
    
    ![](../../images/awsbilling.png)

2. 单击左侧菜单 **_"账单首选项"_** ，在首选项页面的“成本管理首选项”中查看并记录“接收账单报告”的S3存储桶，如未配置，需要勾选“接收账单报告”并配置S3存储桶并验证，设置完成后，将根据设置的粒度将增量账单数据将同步存储到对应的OSS上。建议该bucket中仅存放账单文件。
    
    ![](../../images/awsbillingbucket.png)
   
3. 在AWS控制台的S3存储管理页面中查看对应存储桶中任意账单文件的概述信息，并记录对象URL，存储桶URL即为去掉后面文件名称的URL，如红框所示。
    
    ![](../../images/awsbillingbucketurl.png)

4. AWS的文件前缀为AWS账号ID。

{{% alert title="说明" %}}
当账单bucket中除账单文件外还存放了其他文件时，需要配置文件前缀仅获取bucket中的账单文件等。
{{% /alert %}}

{{% /tab %}}


{{% tab name="Azure" %}}

### 如何获取Azure合约编号和密钥？

1. 登录[Azure中国EA Portal](https://ea.azure.cn/)or[Azure EA Portal](https://ea.azure.com/)，登录系统后，左上角数字即为合约编号。
   ![](../../images/azure_number.png)

2. 单击左侧导航栏 **_"报表"_** 菜单项，选择“下载使用量>API访问密钥”页签，该页面的主密钥即为密钥。
   ![](../../images/azure_apikey.png) 


{{% /tab %}}

{{% tab name="华为云" %}}

### 获取华为云账单存储桶的URL

#### 新版

1. 登录华为云平台，单击顶部 **_"费用中心-费用账单"_** 菜单项，进入费用中心页面。
    ![](../../images/huaweinewconsum.png)

2. 单击左侧[总览]菜单，在总览页面的右侧部分“账单数据存储”中查看并记录对象存储名称，如未配置，需要在该页面启用账单数据存储，并配置存储的OBS桶并进行授权验证操作等，设置完成后，每天的增量账单数据将同步存储到对应的OBS上。建议该bucket中仅存放账单文件。

    ![](../../images/huaweinewbillingbucket.png)

3. 在华为云控制台的对象存储服务(OBS)中查看对应存储桶的概览信息，获取访问域名即为存储桶URL。

    ![](../../images/huaweibillingbucketurl.png) 

#### 旧版

1. 登录华为云平台，单击顶部[更多]菜单的下拉菜单 **_"费用-消费总览"_** 菜单项，进入费用中心页面。
   ![](../../images/huaweiconsum.png)

2. 单击左侧[消费数据存储]菜单，在进入的消费数据存储中查看并记录对象存储桶名称，如未配置，需要在该页面设置存储的OBS桶并进行授权验证操作等，设置完成后，每天的增量账单数据将同步存储到对应的OBS上。建议该bucket中仅存放账单文件。
   ![](../../images/huaweibillingbucket.png)

3. 在华为云控制台的对象存储服务(OBS)中查看对应存储桶的概览信息，获取访问域名即为存储桶URL。
   ![](../../images/huaweibillingbucketurl.png) 

{{% /tab %}}

{{% tab name="Google" %}}

### 获取Google Bigquery配置信息

1. 登录谷歌云控制台，单击左侧菜单 **_"结算"_** 菜单项，进入结算页面。
   ![](../../images/googlebilling.png)

2. 单击左侧菜单[结算导出]，在BIGQUERY EXPORT页签下，启用详细使用费，并配置项目和数据集名称。

    ![](../../images/googlebigqueryconfig.png)

3. 单击数据集名称，跳转到Bigquery，展开右侧节点，选中数据集名称下的分区表，在进入的页面中单击顶部“详情”页签，获取表ID信息。

    ![](../../images/gcpbigquerytableid.png)

4. 在表详情页面，单击右上角 **_"修改详情"_** 按钮，将有效期设置为None。若设置有效期则会从bigquery中清理过期的数据，请谨慎设置。

    ![](../../images/gcomodifytable.png)

### 获取Google账单存储信息

#### 获取账单文件的存储桶URL以及文件前缀

1. 登录谷歌云控制台，单击左侧菜单 **_"结算"_** 菜单项，进入结算页面。
   ![](../../images/googlebilling.png)

2. 单击左侧菜单[结算导出]，在进入的账单页面中单击“文件导出”页签，查看并记录存储分区名称以及报告前缀的信息。其中报告前缀即文件前缀。如果未设置，需要在该页面配置存储分区名称和报告前缀信息等，设置完成后，每天的增量账单数据将同步存储到对应的存储上。建议该bucket中仅存放账单文件。
   ![](../../images/googlebillingbucket.png)

3. 单击左侧菜单[Storage/浏览器]，在进入的存储页面中单击对应存储分区名称，并单击“概览”页签，查看存储分区的概览信息，其中链接网址为存储桶URL。
   ![](../../images/googlebillingbucketurl.png) 

4. 当账单bucket中除账单文件外还存放了其他文件时，需要配置文件前缀仅获取bucket中的账单文件等。

#### 获取使用量文件存储桶URL和文件前缀

1. 在谷歌云控制台中单击左侧菜单[Compute Engine/设置]，进入设置页面。</br>
   ![](../../images/googleusagesetting.png)

2. 请确保已勾选“启用使用情况导出功能”，并记录存储分区名称和报告前缀信息，其中报告前缀即文件前缀。如未配置，需要勾选“启用使用情况导出功能”，并配置存储分区等。
   ![](../../images/googleusagebucket.png) 

3. 单击左侧菜单[Storage/浏览器]，在进入的存储页面中单击对应存储分区名称，并单击“概览”页签，查看存储分区的概览信息，其中链接网址为存储桶URL。
   ![](../../images/googleusagebucketurl.png)

4. 当使用量bucket中除使用量文件外还存放了其他文件时，需要配置文件前缀仅获取bucket中的使用量文件等。

{{% /tab %}}

{{< /tabs >}}