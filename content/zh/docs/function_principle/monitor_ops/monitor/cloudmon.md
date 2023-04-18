---
title: "监控拉取服务(cloudmon)"
weight: 130
description: > 
  介绍监控拉取服务的原理和功能
---

cloudmon服务可以认为是一个cronjob周期任务,通过API调用方式采集各个云平台的监控数据, 并存储到influxdb数据库中, 以供monitor服务查询

## 采集类型
采集一般分为两类, 根据**资源ID获取监控**和**根据监控项获取**类型

### 资源ID类型
此类采集监控数据，每次API调用都需要传入资源Id, 甚至还需要传入监控项，因此会消耗大量API调用
假设有100个资源要获取4类监控数据就需要调用100次甚至400次API

### 监控项类型
此类采集监控数据，每次API调用仅需要传入监控项即可返回多个资源的监控数据，因此
假设有100个资源要获取4类监控数据，最低仅需要调用4次API即可，如果出现分页也仅仅是需要多调用几次

{{% alert title="说明" color="warning" %}}

腾讯云是这两类的结合体, 它需要传入监控项，但是限制了每次最多查10个实例的监控数据，因此
假设有100个资源需要获取4类监控数据就需要调用40次API

调高采集周期可以减少资源ID类型的API调用次数

{{% /alert %}}

## 采集周期

cloudmon默认每6分钟采集一次监控(一个周期内根据资源多少会调用不同云平台多次API)
可以通过以下命令更改采集周期
```shell
# 更改采集周期后会影响查看监控的时效性
$ climc service-config --config collect_metric_interval=12 cloudmon
```

## 忽略某个云平台监控拉取

cloudmon支持忽略某些云平台的监控拉取，但不支持忽略某一个云账号的监控拉取
```shell
# 云平台类型通过逗号隔开
$ climc service-config --config 'skip_metric_pull_providers=Aliyun,Azure' cloudmon
```

## 并发控制

默认一次会同时拉取10个账号的云监控数据, 若云账号过多可适当增加并发量
```shell
$ climc service-config --config cloud_account_collect_metrics_batch_count=15 cloudmon
```

默认每个账号一次性会拉取40个资源的监控, 可以通过以下命令控制资源并发数
```shell
# 此命令仅对根据资源ID采集监控生效
$ climc service-config --config cloud_resource_collect_metrics_batch_count=20 cloudmon
```


## 常用云平台使用监控API

### 阿里云(监控项类别)

[DescribeMetricList](https://next.api.aliyun.com/api/Cms/2019-01-01/DescribeMetricList?lang=GO)

### 飞天(监控项类别)

DescribeMetricList
GetOrganizationTree

### AWS(资源ID类别)

[GetMetricStatistics](https://docs.aws.amazon.com/AmazonCloudWatch/latest/APIReference/API_GetMetricStatistics.html)

### Azure(资源ID类别)

[Metric List](https://learn.microsoft.com/en-us/rest/api/monitor/metrics/list?tabs=HTTP)
[Metric Definitions](https://learn.microsoft.com/en-us/rest/api/monitor/metric-definitions/list?tabs=HTTP)
[Workspaces - Get](https://learn.microsoft.com/en-us/rest/api/loganalytics/workspaces/get?tabs=HTTP)
[Workspaces Query](https://learn.microsoft.com/en-us/rest/api/loganalytics/dataaccess/query/get?tabs=HTTP)

{{% alert title="说明" color="warning" %}}

除Metric List接口外, 其他三个接口是为了获取虚拟机内存和磁盘使用率, 但是会额外产生费用，因此默认不采集
可以通过以下命令开启
```shell
$ climc service-config --config 'support_azure_table_storage_metric=true' cloudmon
```

{{% /alert %}}

### 品高云(资源ID类别)

GetMetricStatistics

### Esxi(监控项类别)

[PerfQuerySpec](https://vdc-repo.vmware.com/vmwb-repository/dcr-public/da47f910-60ac-438b-8b9b-6122f4d14524/16b7274a-bf8b-4b4c-a05e-746f2aa93c8c/doc/vim.PerformanceManager.QuerySpec.html)

{{% alert title="说明" color="warning" %}}

磁盘使用率esxi每半小时才会有一次数据, 且会出现使用率高于100%的情况(esxi控制台可以看到已使用的磁盘大小高于分配大小)

{{% /alert %}}

### Google(监控项类别)

[Metrics](https://cloud.google.com/monitoring/api/metrics_gcp)

### 华为云(资源ID类别)

[batch-query-metric-data](https://support.huaweicloud.com/intl/en-us/api-ces/ces_03_0034.html)

### 腾讯云

[DescribeStatisticData](https://cloud.tencent.com/document/api/248/51845)
[GetMonitorData](https://cloud.tencent.com/document/product/248/31014) 
