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
  - 这里说明下腾讯云的名称**Qcloud**, 本身最好的定义是 TencentCloud, 但最早登录时用的控制台地址是<https://qcloud.com>, 所以才定义为**Qcloud**

- 资源接口
  - 为了屏蔽各个云的差异, 我们分离出 [Cloudmux](https://github.com/yunionio/cloudmux) 仓库, 将各个云的资源操作统一放到这个仓库里面
  - 每一类资源都在 [Resource](https://github.com/yunionio/cloudmux/blob/master/pkg/cloudprovider/resources.go) 可以找到对应的接口
  - 对于每一个云来说基本实现**Resource**里面定义的接口，就完成了 80% 的云平台接入
  - 资源接口的实现文件列表对应路径应该在 pkg/multicloud/testcloud/ 中
- 云账号接入
  - 云账号接入类似于资源接口, 接口定义在[ICloudProvider](https://github.com/yunionio/cloudmux/blob/master/pkg/cloudprovider/cloudprovider.go), 需要实现**ICloudProviderFactory**和**ICloudProvider**
  - **ICloudProviderFactory** 是校验云账号及云账号属性的接口
  - **ICloudProvider** 是云账号真正获取及操作云平台资源的入口
  - 云账号接入的实现文件对应路径应该在 pkg/multicloud/testcloud/provider/ 中
- 快捷操作
  - 为了快捷调试各个云的接口, 每个云平台会有一个对应云平台的 cli 命令实现, 例如[aliyuncli](https://github.com/yunionio/cloudmux/blob/master/cmd/aliyuncli/main.go)
  - aliyuncli 启动时会导入[Shell](https://github.com/yunionio/cloudmux/tree/master/pkg/multicloud/aliyun/shell)里面的子命令, 例如: aliyuncli instance-list
  - 在实现接口初期，可以根据要介入的云平台资源 API, 将基础 API 调用实现, 然后写入 shell 子命令，可以通过 shell 命令快速调试 API

### testcli 调试命令

- 创建 pkg/multicloud/testcloud/test.go 文件
  - 定义 **STestCloudClient** 结构体, 用于保存 aksk
  - 实现 **NewTestCloudClient** 方法, 此方法需要验证测试云的 aksk 是否正确, 并返回\*STestCloudClient
  - 创建 pkg/multicloud/testcloud/region.go 并定义 SRegion 结构体，实现 GetClient 方法
  - 实现绑定 GetRegions 方法到 STestCloudClient, 私有云 region 一般是模拟的, 可以找已经试下的私有云参考

- 创建 pkg/multicloud/testcloud/shell/region.go
  - 实现 region-list 命令, 可参考 pkg/multicloud/aliyun/shell/region.go

- 创建 cmd/testcli/main.go 文件
  - 实现命令调试的入口, 可参考 cmd/aliyuncli/main.go

调试 region-list 命令

```shell
# 编译testcli二进制文件
$ make cmd/testcli 
# 通过命令调试接口
$ ./_output/bin/testcli --debug region-list
```

{{% alert title="说明" color="warning" %}}

- 在对接各个云平台时，一般云平台会提供对应的 golang sdk，这里尽量仅使用提供的 sdk 的认证部分, 其余部分可通过 REST API 文档自行设计, 这样做有以下好处
  - 摆脱 golang sdk 限制
  - 可以统一处理 err 错误，例如后面要用到的 cloudprovider.ErrNotFound 错误
  - 方便实现云账号只读同步及代理
  - 轻量, 部分云平台的 sdk 用了大量指针, 仅仅指针判断会增加很多不必要的代码

{{% /alert %}}

### 添加各个资源接口实现

资源的实现类似于树的生长，自根到枝到叶, 越发扩散，region 类似于树根, region 底下有 vpc, zone..., zone 底下有 host, storage...可依照这个顺序依次实现对应资源的接口

- 添加各个资源的 shell 命令
- 根据资源接口定义实现各个资源相应的接口

{{% alert title="说明" color="warning" %}}
这里有一些接口及方法实现的注意事项

- 资源的 GetGlobalId 要求全局唯一
  - 例如 region 列表不能同时出现两个 region-1
  - region-1 底下可以有 zone1, region-2 底下就不能有 zone1
- 资源的 Refresh
  - 资源如果不存在时 refresh，需要返回 ErrNotFound 错误
  - 在调用 jsonutils.Update 自身时需要将自身的指针或者切片属性设为 nil, 否则这些信息不会被更新
- 资源的 IsEmulated
  - 这个属性是 cloudpods 用来显示或者隐藏某些模拟的资源, 例如公有云并没有宿主机这个概念, 因此公有云的宿主机是 emulated 的
- GetCapabilities 接口
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

实现完成后，编辑 pkg/multicloud/loader/loader.go 文件, 将包导入进去

{{% alert title="说明" color="warning" %}}

这里要注意 GetSubAccounts 实际上是返回了云订阅的信息，有几个 SubAccounts 就有几个云订阅
判断云订阅个数是根据云订阅的特性决定的, 即使是同一个云账号 A, A 账号底下的 a 订阅资源不能关联到 A 账号底下 b 订阅的资源, 例如 a 订阅的 eip 不能绑定到 b 订阅的虚拟机上

GetAccountId 是返回这个账号的唯一标识，用来阻止云账号重复导入的
{{% /alert %}}

### cloudpods 接入

资源接口及云账号接入已经实现后即可正式接入 cloudpods 调试资源

```shell
# 进入cloudpods代码目录, 导入cloudmux, /path/to/local/cloudmux/path需要替换为本地的cloudmux绝对路径
$ go mod edit -replace yunion.io/x/cloudmux=/path/to/local/cloudmux/path
$ make mod
```

- 添加 pkg/compute/guestdrivers/testcloud.go pkg/compute/hostdrivers/testcloud.go pkg/compute/regiondrivers/testcloud.go 文件, 实现基础的 init 方法
- 编辑 cmd/climc/shell/compute/cloudaccounts.go 文件, 添加 create-testcloud 子命令
- 编辑 pkg/apis/compute/cloudaccount\_const.go 文件, 添加云平台名称到对应的变量
- 编辑 pkg/apis/compute/host\_const.go 文件, 添加对应 host\_type, 及底下一些变量需要对应添加
- 编辑 pkg/apis/compute/guest\_const.go 文件, 添加对应的 hypersor, 及底下一些变量需要对应添加
- 若添加的对应的云子网若是 region 级别的，需要编辑 pkg/apis/compute/network\_const.go 文件,添加至 REGIONAL\_NETWORK\_PROVIDERS

```shell
# 编译region二进制, 或者打包region镜像 https://www.cloudpods.org/zh/docs/development/dev-env/#docker-%E9%95%9C%E5%83%8F%E7%BC%96%E8%AF%91%E4%B8%8A%E4%BC%A0
$ make cmd/region
# 编译最新的climc命令
$ make cmd/climc
# 导入云账号
$ ./_output/bin/climc cloud-account-create-testcloud --xxx -xxx -xxx -xxx
```

问题排查

- 确认查看当前部署的服务镜像是否更新成编译后打包的镜像

```shell
# 查看
kubectl get pods -n oneclouds
```

- 可以通过给服务进程发送 SIGUSR1 信号，触发服务进程打印当前调用栈。具体方法参考[问题排查工具](https://www.cloudpods.org/zh/docs/development/devtools/#%E8%8E%B7%E5%8F%96%E8%B0%83%E7%94%A8%E6%A0%88)。

- 从 API 请求定位到对应的后段代码，参考[定位后端代码](https://www.cloudpods.org/zh/docs/development/api-model/)。

监控数据采集

- 修改 cloudmux 的 pkg/cloudmux/testcloud/provider/provider.go 添加实现 GetMetrics 接口
- 添加 cloudpods 的 pkg/cloudmon/providerdriver/testcloud.go 文件
- go mod edit --replace && make mod && make cmd/cloudmon 打包发布最新的 cloudmon 镜像调试
