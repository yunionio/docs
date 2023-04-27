---
title: "接入一个云"
weight: 100
edition: ce
description: >
  介绍如何接入一个新的云平台

---


假设这里要接入的云为测试云(TestCloud)

## 基础概念

- 平台名称
    - 每接入一个云，都需要定义一个云平台的名称，[Provider](https://github.com/yunionio/cloudmux/blob/master/pkg/apis/compute/cloudaccount_const.go) 这里是目前已经接入的各个云的名称
    - 这里说明下腾讯云的名称**Qcloud**, 本身最好的定义是TencentCloud, 但最早登录时用的控制台地址是https://qcloud.com, 所以才定义为**Qcloud**

- 资源接口
    - 为了屏蔽各个云的差异, 我们分离出 [Cloudmux](https://github.com/yunionio/cloudmux) 仓库, 将各个云的资源操作统一放到这个仓库里面
    - 每一类资源都在 [Resource](https://github.com/yunionio/cloudmux/blob/master/pkg/cloudprovider/resources.go) 可以找到对应的接口
    - 对于每一个云来说基本实现**Resource**里面定义的接口，就完成了80%的云平台接入
    - 这里的实现文件列表为 pkg/multicloud/testcloud/
- 云账号接入
    - 云账号接入类似于资源接口, 接口定义在[ICloudProvider](https://github.com/yunionio/cloudmux/blob/master/pkg/cloudprovider/cloudprovider.go), 需要实现**ICloudProviderFactory**和**ICloudProvider**
    - **ICloudProviderFactory** 是校验云账号及云账号属性的接口
    - **ICloudProvider** 是云账号真正获取及操作云平台资源的入口
    - 这里的实现文件在 pkg/multicloud/testcloud/provider/
- 快捷操作
    - 为了快捷调试各个云的接口, 每个云平台会有一个对应云平台的cli命令实现, 例如[aliyuncli](https://github.com/yunionio/cloudmux/blob/master/cmd/aliyuncli/main.go)
    - aliyuncli启动时会导入[Shell](https://github.com/yunionio/cloudmux/tree/master/pkg/multicloud/aliyun/shell)里面的子命令, 例如: aliyuncli instance-list
    - 在实现接口初期，可以根据要介入的云平台资源API, 将基础API调用实现, 然后写入shell子命令，可以通过shell命令快速调试API


### testcli调试命令

- 创建 pkg/multicloud/testcloud/test.go 文件
    - 定义 **STestCloudClient** 结构体, 用于保存aksk
    - 实现 **NewTestCloudClient** 方法, 此方法需要验证测试云的aksk是否正确, 并返回\*STestCloudClient
    - 创建 pkg/multicloud/testcloud/region.go 并定义SRegion结构体，实现 GetClient 方法
    - 实现绑定 GetRegions 方法到 STestCloudClient, 私有云region一般是模拟的, 可以找已经试下的私有云参考

- 创建 pkg/multicloud/testcloud/shell/region.go
    - 实现 region-list 命令, 可参考pkg/multicloud/aliyun/shell/region.go

- 创建 cmd/testcli/main.go 文件
    - 实现命令调试的入口, 可参考cmd/aliyuncli/main.go

调试 region-list 命令
```shell
# 编译testcli二进制文件
$ make cmd/testcli 
# 通过命令调试接口
$ ./_output/bin/testcli --debug region-list
```

### 添加各个资源接口实现

资源的实现类似于数的生长，自根到枝到叶, 越发扩散，region类似于树根, region底下有vpc, zone..., zone底下有host, storage...可依照这个顺序依次实现对应资源的接口

- 添加各个资源的shell命令
- 根据资源接口定义实现各个资源相应的接口

{{% alert title="说明" color="warning" %}}
这里有一些接口及方法实现的注意事项
- 资源的GetGlobalId要求全局唯一
    - 例如region列表不能同时出现两个region-1
    - region-1 底下可以有zone1, region-2底下就不能有zone1
- 资源的Refresh
    - 资源如果不存在时refresh，需要返回ErrNotFound错误
    - 在调用jsonutils.Update自身时需要将自身的指针或者切片属性设为nil, 否则这些信息不会被更新
- 资源的IsEmulated
    - 这个属性是cloudpods用来显示或者隐藏某些模拟的资源, 例如公有云并没有宿主机这个概念, 因此公有云的宿主机是emulated的
- GetCapabilities接口
    - 此接口定义了这个云实现了哪些资源，包括资源是否只读
    - 若实现了某些资源接口，需要将这些资源加入到返回列表里面，否则资源存在同步不下来的问题

{{% /alert %}}

### 云账号接入

首先需要实现上面**基础概念**定义的**云账号接入**里面的接口
- 主要实现以下几个接口
    - ICloudProviderFactory
        - GetProvider
        - GetId
        - GetName
        - ValidateCreateCloudaccountData
    - ICloudProvider
        - GetFactory
        - GetIRegions
        - GetIRegionById
        - GetSubAccounts
        - GetAccountId
        - GetCloudRegionExternalIdPrefix

实现完成后，编辑pkg/multicloud/loader/loader.go文件, 将包导入进去

{{% alert title="说明" color="warning" %}}

这里要注意GetSubAccounts实际上是返回了云订阅的信息，有几个SubAccounts就有几个云订阅
判断云订阅个数是根据云订阅的特性决定的, 即使是同一个云账号A, A账号底下的a订阅资源不能关联到A账号底下b订阅的资源, 例如a订阅的eip不能绑定到b订阅的虚拟机上

GetAccountId是返回这个账号的唯一标识，用来阻止云账号重复导入的
{{% /alert %}}


### cloudpods 接入

资源接口及云账号接入已经实现后即可正式接入cloudpods调试资源

```shell
# 进入cloudpods代码目录, 导入cloudmux, /path/to/local/cloudmux/path需要替换为本地的cloudmux绝对路径
$ go mod edit -replace yunion.io/x/cloudmux=/path/to/local/cloudmux/path
$ make mod
```

- 添加 pkg/compute/guestdrivers/testcloud.go pkg/compute/hostdrivers/testcloud.go pkg/compute/regiondrivers/testcloud.go 文件, 实现基础的init方法
- 编辑 cmd/climc/shell/compute/cloudaccounts.go 文件, 添加create-testcloud子命令
- 编辑 pkg/apis/compute/cloudaccount\_const.go 文件, 添加云平台名称到对应的变量
- 编辑 pkg/apis/compute/host\_const.go 文件, 添加对应host\_type, 及底下一些变量需要对应添加
- 编辑 pkg/apis/compute/guest\_const.go 文件, 添加对应的hypersor, 及底下一些变量需要对应添加
- 若添加的对应的云子网若是region级别的，需要编辑pkg/apis/compute/network\_const.go文件,添加至REGIONAL\_NETWORK\_PROVIDERS


```shell
# 编译region二进制, 或者打包region镜像 https://www.cloudpods.org/zh/docs/development/dev-env/#docker-%E9%95%9C%E5%83%8F%E7%BC%96%E8%AF%91%E4%B8%8A%E4%BC%A0
$ make cmd/region
# 编译最新的climc命令
$ make cmd/climc
# 导入云账号
$ ./_output/bin/climc cloud-account-create-testcloud --xxx -xxx -xxx -xxx
```

监控数据采集

- 修改 cloudmux 的 pkg/cloudmux/testcloud/provider/provider.go 添加实现GetMetrics接口
- 添加 cloudpods 的 pkg/cloudmon/providerdriver/testcloud.go 文件
- go mod edit --replace && make mod && make cmd/cloudmon 打包发布最新的cloudmon镜像调试
