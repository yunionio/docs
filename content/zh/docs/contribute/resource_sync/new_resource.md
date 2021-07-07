---
title: "新资源接入"
weight: 50
description: >
  介绍如何接入一个新资源
---

本文以阿里云ElasticSearch为例(cloudpods从v3.8开始支持)，介绍如果纳管一种云平台未接入的资源



## 定义ElasticSearch接口
```bash
# 编辑 pkg/cloudprovider/resources.go
# 文件末尾追加

# 说明: 同步时，可以先定义一些基础的信息，先将资源同步下来
# 后面可以根据资源拥有的属性，不断往资源加相应的接口
type ICloudElasticSearch interface {
    IVirtualResource
    IBillingResource
}
```

## 实现阿里云的基础数据结构
```bash
# 创建 pkg/multicloud/aliyun/elastic_search.go 文件
# 填充阿里云ElasticSearch基础数据结构
package aliyun

type SElasticSearch struct {
    // 这里统一实现了Aliyun标签接口，可以少写一些处理标签的函数
    multicloud.AliyunTags
    // 减少基础的方法实现, 但需要实现IVirtualResource中的接口
    multicloud.SVirtualResourceBase
    // 一些计费的基础方法
    multicloud.SBillingBase
    // 链式资源(ElasticSearch属于区域资源)
    region *SRegion
}

// 实现获取阿里云ElasticSearch资源函数

// 获取ElasticSearch资源列表
func (self *SRegion) GetElasticSearchs(size, page int) ([]SElasticSearch, int, error) {
    ...
}

// 获取单个ElasticSearch资源
func (self *SRegion) GetElasitcSearch(id string) (*SElasticSearch, error) {
    ...
}
```

## 实现aliyuncli命令行(方便调试)
```bash
// 创建 pkg/multicloud/aliyun/shell/elk.go 文件
package shell

func init() {
    type ElkListOptions struct {
        Page int
        Size int
    }
    shellutils.R(&ElkListOptions{}, "elastic-search-list", "List elastic searchs", func(cli *aliyun.SRegion, args *ElkListOptions) error {
        elks, _, err := cli.GetElasticSearchs(args.Size, args.Page)
        if err != nil {
            return err
        }
        printList(elks, 0, 0, 0, nil)
        return nil
    })

    type ElkIdOptions struct {
        ID string
    }

    shellutils.R(&ElkIdOptions{}, "elastic-search-show", "Show elasitc search", func(cli *aliyun.SRegion, args *ElkIdOptions) error {
        elk, err := cli.GetElasitcSearch(args.ID)
        if err != nil {
            return err
        }
        printObject(elk)
        return nil
    })

}
```
## 调试aliyuncli命令
```bash
# 编译aliyuncli命令
$ make cmd/aliyuncli

# 声明环境变量
$ export ALIYUN_ACCESS_KEY=LTAI5H1wXkXeas1M
$ export ALIYUN_SECRET=cByPBQM9zFVgNBMKNJZMYrKFUkvVk8
# 这里需要根据地域情况自行设置
$ export ALIYUN_REGION=cn-beijing

# 执行列出ElasticSearch资源命令
$ ./_output/bin/aliyuncli --debug --region-id cn-beijing elastic-search-list
$ ./_output/bin/aliyuncli --debug --region-id cn-beijing elastic-search-show es-cn-n6w1ptcb30009****
```

## 补充ElasticSearch接口
```bash
# 编辑 pkg/multicloud/aliyun/elastic_search.go 文件
# 实现以下接口
func (self *SElasticSearch) GetId() string {
    ...
}

// 此函数返回值将会存储到数据库的external_id字段里面,请确保能和云上资源一一对应
// 若是Azure资源, 请务必返回时strings.ToLower(), 因为Azure资源Id不区分大小写，但id大小写返回不固定，在同步时会引起资源反复增删问题
func (self *SElasticSearch) GetGlobalId() string {
    ...
}

// 获取ElasticSearch资源名称
func (self *SElasticSearch) GetName() string {
    ...
}

// 创建删除或其他操作需要循环获取资源状态, 来判定操作是否结束, 此函数主要是刷新状态字段或其他相关字段
func (self *SElasticSearch) Refresh() error {
    ...
}

// 获取资源创建时间
func (self *SElasticSearch) GetCreatedAt() time.Time {
    ...
}

// 获取资源计费方式: 预付费, 后付费?
func (self *SElasticSearch) GetBillingType() string {
    ...
}

// 获取资源归属项目Id
func (self *SElasticSearch) GetProjectId() string {
    ...
}

// 获取资源状态
func (self *SElasticSearch) GetStatus() string {
    ...
}

```

## 添加区域获取ElasticSearch接口
```bash
# 编辑 pkg/cloudprovider/resources.go 文件
# 找到 ICloudRegion 定义, 并补充以下两个接口:
type ICloudRegion interface {
    ...

    GetIElasticSearchs() ([]ICloudElasticSearch, error)
    GetIElasticSearchById(id string) (ICloudElasticSearch, error)
}

# 编辑 pkg/multicloud/region_base.go 实现基础的两个方法
# 这里主要是因为对接往往是从一两个云开始
# 若不实现这两个基础方法，则需要在每一个云的region.go文件实现这两个方法
func (self *SRegion) GetIElasticSearchs() ([]cloudprovider.ICloudElasticSearch, error) {
    return nil, errors.Wrapf(cloudprovider.ErrNotImplemented, "GetIElasticSearchs")
}

func (self *SRegion) GetIElasticSearchById(id string) (cloudprovider.ICloudElasticSearch, error) {
    return nil, errors.Wrapf(cloudprovider.ErrNotImplemented, "GetIElasticSearchById")
}

# 实现阿里云的这两个方法
# 编辑 pkg/multicloud/aliyun/elastic_search.go 文件

# 实现 GetIElasticSearchs 接口
func (self *SRegion) GetIElasticSearchs() ([]cloudprovider.ICloudElasticSearch, error) {
    // 获取当前region的所有elasticsearch实例
    ess, err := self.GetElasticSearchs(...)
    if err != nil {
        return err
    }
    ret := []cloudprovider.ICloudElasticSearch{}
    for i := range ess {
        // 这里需要赋值，例如删除, 就可以使用 ess[i].region.DeleteElasticSearch(ess[i].InstanceId)
        ess[i].region = self
        ret = append(ret, &ess[i])
    }
    return ret, nil
}

# 实现 GetIElasticSearchById 接口
func (self *SRegion) GetIElasticSearchById(id string) (cloudprovider.ICloudElasticSearch, error) {
    // 这里没有使用es.region = self，是因为在GetElasitcSearch函数里面已经赋值过了
    es, err := self.GetElasitcSearch(id)
    if err != nil {
        return nil, err
    }
    return es, nil
}
```

## 定义本地资源模型
```bash
# 创建 pkg/apis/compute/elastic_search.go 文件
# 准备需要的数据结构

package compute

import "yunion.io/x/onecloud/pkg/apis"

const (
    ELASTIC_SEARCH_STATUS_AVAILABLE     = "available"
    ELASTIC_SEARCH_STATUS_UNAVAILABLE   = "unavailable"
    ELASITC_SEARCH_STATUS_CREATING      = "creating"
    ELASTIC_SEARCH_STATUS_DELETING      = "deleting"
    ELASTIC_SEARCH_STATUS_DELETE_FAILED = "delete_failed"
    ELASTIC_SEARCH_STATUS_UNKNOWN       = "unknown"
)

// 资源创建参数, 目前仅站位
type ElasticSearchCreateInput struct {
}

// 资源返回详情
type ElasticSearchDetails struct {
    apis.VirtualResourceDetails
    ManagedResourceInfo
    CloudregionResourceInfo
}

// 资源列表请求参数
type ElasticSearchListInput struct {
    apis.VirtualResourceListInput
    apis.ExternalizedResourceBaseListInput
    apis.DeletePreventableResourceBaseListInput

    RegionalFilterListInput
    ManagedResourceListInput
}

# 创建 pkg/compute/models/elastic_search.go 文件
# 实现基础manager和model
# 由于资源是用户可建，因此定义为Virtual资源

package models

import (
    "context"
    "fmt"

    "yunion.io/x/jsonutils"
    "yunion.io/x/pkg/errors"
    "yunion.io/x/pkg/util/compare"
    "yunion.io/x/sqlchemy"

    billing_api "yunion.io/x/onecloud/pkg/apis/billing"
    api "yunion.io/x/onecloud/pkg/apis/compute"
    "yunion.io/x/onecloud/pkg/cloudcommon/db"
    "yunion.io/x/onecloud/pkg/cloudcommon/db/lockman"
    "yunion.io/x/onecloud/pkg/cloudprovider"
    "yunion.io/x/onecloud/pkg/httperrors"
    "yunion.io/x/onecloud/pkg/mcclient"
    "yunion.io/x/onecloud/pkg/util/stringutils2"
)

type SElasticSearchManager struct {
    db.SVirtualResourceBaseManager
    db.SExternalizedResourceBaseManager
    SDeletePreventableResourceBaseManager

    SCloudregionResourceBaseManager
    SManagedResourceBaseManager
}

var ElasticSearchManager *SElasticSearchManager

func init() {
    ElasticSearchManager = &SElasticSearchManager{
        SVirtualResourceBaseManager: db.NewVirtualResourceBaseManager(
            SElasticSearch{},
            "elastic_searchs_tbl",
            "elastic_search",
            "elastic_searchs",
        ),
    }
    ElasticSearchManager.SetVirtualObject(ElasticSearchManager)
}

type SElasticSearch struct {
    db.SVirtualResourceBase
    db.SExternalizedResourceBase
    SManagedResourceBase
    SBillingResourceBase

    SCloudregionResourceBase
    SDeletePreventableResourceBase
}

func (manager *SElasticSearchManager) GetContextManagers() [][]db.IModelManager {
    return [][]db.IModelManager{
        {CloudregionManager},
    }
}

// ElasticSearch实例列表
func (man *SElasticSearchManager) ListItemFilter(
    ctx context.Context,
    q *sqlchemy.SQuery,
    userCred mcclient.TokenCredential,
    query api.ElasticSearchListInput,
) (*sqlchemy.SQuery, error) {
    var err error
    q, err = man.SVirtualResourceBaseManager.ListItemFilter(ctx, q, userCred, query.VirtualResourceListInput)
    if err != nil {
        return nil, errors.Wrap(err, "SVirtualResourceBaseManager.ListItemFilter")
    }
    q, err = man.SExternalizedResourceBaseManager.ListItemFilter(ctx, q, userCred, query.ExternalizedResourceBaseListInput)
    if err != nil {
        return nil, errors.Wrap(err, "SExternalizedResourceBaseManager.ListItemFilter")
    }
    q, err = man.SDeletePreventableResourceBaseManager.ListItemFilter(ctx, q, userCred, query.DeletePreventableResourceBaseListInput)
    if err != nil {
        return nil, errors.Wrap(err, "SDeletePreventableResourceBaseManager.ListItemFilter")
    }
    q, err = man.SManagedResourceBaseManager.ListItemFilter(ctx, q, userCred, query.ManagedResourceListInput)
    if err != nil {
        return nil, errors.Wrap(err, "SManagedResourceBaseManager.ListItemFilter")
    }
    q, err = man.SCloudregionResourceBaseManager.ListItemFilter(ctx, q, userCred, query.RegionalFilterListInput)
    if err != nil {
        return nil, errors.Wrap(err, "SCloudregionResourceBaseManager.ListItemFilter")
    }

    return q, nil
}

func (man *SElasticSearchManager) OrderByExtraFields(
    ctx context.Context,
    q *sqlchemy.SQuery,
    userCred mcclient.TokenCredential,
    query api.ElasticSearchListInput,
) (*sqlchemy.SQuery, error) {
    q, err := man.SVirtualResourceBaseManager.OrderByExtraFields(ctx, q, userCred, query.VirtualResourceListInput)
    if err != nil {
        return nil, errors.Wrap(err, "SVirtualResourceBaseManager.OrderByExtraFields")
    }
    q, err = man.SCloudregionResourceBaseManager.OrderByExtraFields(ctx, q, userCred, query.RegionalFilterListInput)
    if err != nil {
        return nil, errors.Wrap(err, "SCloudregionResourceBaseManager.OrderByExtraFields")
    }
    q, err = man.SManagedResourceBaseManager.OrderByExtraFields(ctx, q, userCred, query.ManagedResourceListInput)
    if err != nil {
        return nil, errors.Wrap(err, "SManagedResourceBaseManager.OrderByExtraFields")
    }
    return q, nil
}

func (man *SElasticSearchManager) QueryDistinctExtraField(q *sqlchemy.SQuery, field string) (*sqlchemy.SQuery, error) {
    q, err := man.SVirtualResourceBaseManager.QueryDistinctExtraField(q, field)
    if err == nil {
        return q, nil
    }
    q, err = man.SCloudregionResourceBaseManager.QueryDistinctExtraField(q, field)
    if err == nil {
        return q, nil
    }
    q, err = man.SManagedResourceBaseManager.QueryDistinctExtraField(q, field)
    if err == nil {
        return q, nil
    }
    return q, httperrors.ErrNotFound
}

func (man *SElasticSearchManager) ValidateCreateData(ctx context.Context, userCred mcclient.TokenCredential, ownerId mcclient.IIdentityProvider, query jsonutils.JSONObject, input api.ElasticSearchCreateInput) (api.ElasticSearchCreateInput, error) {
    return input, httperrors.NewNotImplementedError("Not Implemented")
}

func (manager *SElasticSearchManager) FetchCustomizeColumns(
    ctx context.Context,
    userCred mcclient.TokenCredential,
    query jsonutils.JSONObject,
    objs []interface{},
    fields stringutils2.SSortedStrings,
    isList bool,
) []api.ElasticSearchDetails {
    rows := make([]api.ElasticSearchDetails, len(objs))
    virtRows := manager.SVirtualResourceBaseManager.FetchCustomizeColumns(ctx, userCred, query, objs, fields, isList)
    manRows := manager.SManagedResourceBaseManager.FetchCustomizeColumns(ctx, userCred, query, objs, fields, isList)
    regRows := manager.SCloudregionResourceBaseManager.FetchCustomizeColumns(ctx, userCred, query, objs, fields, isList)

    for i := range rows {
        rows[i] = api.ElasticSearchDetails{
            VirtualResourceDetails:  virtRows[i],
            ManagedResourceInfo:     manRows[i],
            CloudregionResourceInfo: regRows[i],
        }
    }

    return rows
}

func (self *SCloudregion) GetElasticSearchs(managerId string) ([]SElasticSearch, error) {
    q := ElasticSearchManager.Query().Equals("cloudregion_id", self.Id)
    if len(managerId) > 0 {
        q = q.Equals("manager_id", managerId)
    }
    ret := []SElasticSearch{}
    err := db.FetchModelObjects(ElasticSearchManager, q, &ret)
    if err != nil {
        return nil, errors.Wrapf(err, "db.FetchModelObjects")
    }
    return ret, nil
}

func (self *SCloudregion) SyncElasticSearchs(ctx context.Context, userCred mcclient.TokenCredential, provider *SCloudprovider, exts []cloudprovider.ICloudElasticSearch) compare.SyncResult {
    // 加锁防止重入
    lockman.LockRawObject(ctx, ElasticSearchManager.KeywordPlural(), fmt.Sprintf("%s-%s", provider.Id, self.Id))
    defer lockman.ReleaseRawObject(ctx, ElasticSearchManager.KeywordPlural(), fmt.Sprintf("%s-%s", provider.Id, self.Id))

    result := compare.SyncResult{}

    dbEss, err := self.GetElasticSearchs(provider.Id)
    if err != nil {
        result.Error(err)
        return result
    }

    removed := make([]SElasticSearch, 0)
    commondb := make([]SElasticSearch, 0)
    commonext := make([]cloudprovider.ICloudElasticSearch, 0)
    added := make([]cloudprovider.ICloudElasticSearch, 0)
    // 本地和云上资源列表进行比对
    err = compare.CompareSets(dbEss, exts, &removed, &commondb, &commonext, &added)
    if err != nil {
        result.Error(err)
        return result
    }

    // 删除云上没有的资源
    for i := 0; i < len(removed); i++ {
        err := removed[i].syncRemoveCloudElasticSearch(ctx, userCred)
        if err != nil {
            result.DeleteError(err)
            continue
        }
        result.Delete()
    }

    // 和云上资源属性进行同步
    for i := 0; i < len(commondb); i++ {
        err := commondb[i].SyncWithCloudElasticSearch(ctx, userCred, commonext[i])
        if err != nil {
            result.UpdateError(err)
            continue
        }
        result.Update()
    }

    // 创建本地没有的云上资源
    for i := 0; i < len(added); i++ {
        _, err := self.newFromCloudElasticSearch(ctx, userCred, provider, added[i])
        if err != nil {
            result.AddError(err)
            continue
        }
        result.Add()
    }
    return result
}

// 判断资源是否可以删除
func (self *SElasticSearch) ValidateDeleteCondition(ctx context.Context) error {
    if self.DisableDelete.IsTrue() {
        return httperrors.NewInvalidStatusError("ElasticSearch is locked, cannot delete")
    }
    return self.SStatusStandaloneResourceBase.ValidateDeleteCondition(ctx)
}

func (self *SElasticSearch) syncRemoveCloudElasticSearch(ctx context.Context, userCred mcclient.TokenCredential) error {
    return self.Delete(ctx, userCred)
}

// 同步资源属性
func (self *SElasticSearch) SyncWithCloudElasticSearch(ctx context.Context, userCred mcclient.TokenCredential, ext cloudprovider.ICloudElasticSearch) error {
    diff, err := db.UpdateWithLock(ctx, self, func() error {
        self.ExternalId = ext.GetGlobalId()
        self.Status = ext.GetStatus()

        self.BillingType = ext.GetBillingType()
        if self.BillingType == billing_api.BILLING_TYPE_PREPAID {
            if expiredAt := ext.GetExpiredAt(); !expiredAt.IsZero() {
                self.ExpiredAt = expiredAt
            }
            self.AutoRenew = ext.IsAutoRenew()
        }
        return nil
    })
    if err != nil {
        return errors.Wrapf(err, "db.Update")
    }

    syncVirtualResourceMetadata(ctx, userCred, self, ext)
    if provider := self.GetCloudprovider(); provider != nil {
        SyncCloudProject(userCred, self, provider.GetOwnerId(), ext, provider.Id)
    }
    db.OpsLog.LogSyncUpdate(self, diff, userCred)
    return nil
}

func (self *SCloudregion) newFromCloudElasticSearch(ctx context.Context, userCred mcclient.TokenCredential, provider *SCloudprovider, ext cloudprovider.ICloudElasticSearch) (*SElasticSearch, error) {
    es := SElasticSearch{}
    es.SetModelManager(ElasticSearchManager, &es)

    es.ExternalId = ext.GetGlobalId()
    es.CloudregionId = self.Id
    es.ManagerId = provider.Id
    es.IsEmulated = ext.IsEmulated()
    es.Status = ext.GetStatus()

    if createdAt := ext.GetCreatedAt(); !createdAt.IsZero() {
        es.CreatedAt = createdAt
    }

    es.BillingType = ext.GetBillingType()
    if es.BillingType == billing_api.BILLING_TYPE_PREPAID {
        if expired := ext.GetExpiredAt(); !expired.IsZero() {
            es.ExpiredAt = expired
        }
        es.AutoRenew = ext.IsAutoRenew()
    }

    var err error
    err = func() error {
        // 这里加锁是为了防止名称重复
        lockman.LockRawObject(ctx, ElasticSearchManager.Keyword(), "name")
        defer lockman.ReleaseRawObject(ctx, ElasticSearchManager.Keyword(), "name")

        es.Name, err = db.GenerateName(ctx, ElasticSearchManager, provider.GetOwnerId(), ext.GetName())
        if err != nil {
            return errors.Wrapf(err, "db.GenerateName")
        }
        return ElasticSearchManager.TableSpec().Insert(ctx, &es)
    }()
    if err != nil {
        return nil, errors.Wrapf(err, "newFromCloudElasticSearch.Insert")
    }

    // 同步标签
    syncVirtualResourceMetadata(ctx, userCred, &es, ext)
    // 同步项目归属
    SyncCloudProject(userCred, &es, provider.GetOwnerId(), ext, provider.Id)

    db.OpsLog.LogEvent(&es, db.ACT_CREATE, es.GetShortDesc(ctx), userCred)

    return &es, nil
}

func (manager *SElasticSearchManager) ListItemExportKeys(ctx context.Context,
    q *sqlchemy.SQuery,
    userCred mcclient.TokenCredential,
    keys stringutils2.SSortedStrings,
) (*sqlchemy.SQuery, error) {
    var err error

    q, err = manager.SVirtualResourceBaseManager.ListItemExportKeys(ctx, q, userCred, keys)
    if err != nil {
        return nil, errors.Wrap(err, "SVirtualResourceBaseManager.ListItemExportKeys")
    }

    if keys.ContainsAny(manager.SManagedResourceBaseManager.GetExportKeys()...) {
        q, err = manager.SManagedResourceBaseManager.ListItemExportKeys(ctx, q, userCred, keys)
        if err != nil {
            return nil, errors.Wrap(err, "SManagedResourceBaseManager.ListItemExportKeys")
        }
    }

    if keys.ContainsAny(manager.SCloudregionResourceBaseManager.GetExportKeys()...) {
        q, err = manager.SCloudregionResourceBaseManager.ListItemExportKeys(ctx, q, userCred, keys)
        if err != nil {
            return nil, errors.Wrap(err, "SCloudregionResourceBaseManager.ListItemExportKeys")
        }
    }

    return q, nil
}
```

## 添加resful接口
```bash
# 编辑 pkg/compute/service/handlers.go 文件
func InitHandlers(app *appsrv.Application) {
    ...
    for _, manager := range []db.IModelManager{
        ...
    } {
        db.RegisterModelManager(manager)
    }

    for _, manager := range []db.IModelManager{
        ...
        
        models.ElasticSearchManager,
    } {
        db.RegisterModelManager(manager)
        handler := db.NewModelHandler(manager)
        dispatcher.AddModelDispatcher("", app, handler)
    }
}
```

## 打包镜像，重启region服务
```bash
# 打包镜像
$ ARCH=all TAG=v3.8.es REGISTRY=registry.cn-beijing.aliyuncs.com/你的镜像命名空间 ./scripts/docker_push.sh region
# 替换镜像，重启服务
$ kubectl edit deployments. -n onecloud default-region # 替换配置文件中的image为上面打包的镜像
```

## climc 命令编写
```bash
# 创建 pkg/mcclient/modules/mod_elastic_searchs.go 文件, 注册module

package modules

import (
    "yunion.io/x/onecloud/pkg/mcclient/modulebase"
)

type ElasticSearchManager struct {
    modulebase.ResourceManager
}

var (
    ElasticSearchs ElasticSearchManager
)

func init() {
    ElasticSearchs = ElasticSearchManager{NewComputeManager("elastic_search", "elastic_searchs",
        []string{},
        []string{})}

    registerCompute(&ElasticSearchs)
}

# 创建 pkg/mcclient/options/compute/elastic_search.go 文件，定义climc命令行参数

package compute

import (
    "yunion.io/x/jsonutils"

    "yunion.io/x/onecloud/pkg/mcclient/options"
)

type ElasticSearchListOptions struct {
    options.BaseListOptions
}

func (opts *ElasticSearchListOptions) Params() (jsonutils.JSONObject, error) {
    return options.ListStructToParams(opts)
}

type ElasticSearchIdOption struct {
    ID string `help:"Elasticsearch Id"`
}

func (opts *ElasticSearchIdOption) GetId() string {
    return opts.ID
}

func (opts *ElasticSearchIdOption) Params() (jsonutils.JSONObject, error) {
    return nil, nil
}

# 创建 cmd/climc/shell/compute/elastic_search.go 文件, 添加命令

package compute

import (
    "yunion.io/x/onecloud/cmd/climc/shell"
    "yunion.io/x/onecloud/pkg/mcclient/modules"
    "yunion.io/x/onecloud/pkg/mcclient/options/compute"
)

func init() {
    cmd := shell.NewResourceCmd(&modules.ElasticSearchs)
    cmd.List(&compute.ElasticSearchListOptions{})
    cmd.Show(&compute.ElasticSearchIdOption{})
}
```

## 调试 climc 命令
```bash
# 编译climc命令
$ make cmd/climc

# 声明环境变量
$ source <(ocadm cluster rcadmin)

# 执行列出ElasticSearch资源命令
$ ./_output/bin/climc --debug elastic-search-list # 由于此时还未同步elastic search资源，返回结果为空
$ ./_output/bin/climc --debug elastic-search-show es-cn-n6w1ptcb30009****

```

## 同步ElasticSearch资源
```bash
# 编辑 pkg/cloudprovider/consts.go 文件, 定义新资源类型
const (
    CLOUD_CAPABILITY_PROJECT         = "project"
    ...
    CLOUD_CAPABILITY_ES              = "es"        // ElasticSearch
)

# 编辑 pkg/multicloud/aliyun/aliyun.go 文件, 添加云平台对新资源的能力
func (region *SAliyunClient) GetCapabilities() []string {
    caps := []string{
        cloudprovider.CLOUD_CAPABILITY_PROJECT,
        ...
        ...
        cloudprovider.CLOUD_CAPABILITY_ES,
    }
    return caps
}

# 编辑 pkg/compute/models/cloudsync.go 文件, 添加同步逻辑
func syncPublicCloudProviderInfo(
    ctx context.Context,
    userCred mcclient.TokenCredential,
    syncResults SSyncResultSet,
    provider *SCloudprovider,
    driver cloudprovider.ICloudProvider,
    localRegion *SCloudregion,
    remoteRegion cloudprovider.ICloudRegion,
    syncRange *SSyncRange,
) error {
    ...

    // 若云平台支持ElasticSearch则同步es资源
    if utils.IsInStringArray(cloudprovider.CLOUD_CAPABILITY_ES, driver.GetCapabilities()) {
        syncElasticSearchs(ctx, userCred, syncResults, provider, localRegion, remoteRegion)
    }

    if cloudprovider.IsSupportCompute(driver) {
        ...
    }
    ...
}


func syncElasticSearchs(ctx context.Context, userCred mcclient.TokenCredential, syncResults SSyncResultSet, provider *SCloudprovider, localRegion *SCloudregion, remoteRegion cloudprovider.ICloudRegion) error {
    iEss, err := remoteRegion.GetIElasticSearchs()
    if err != nil {
        msg := fmt.Sprintf("GetIElasticSearchs for region %s failed %s", remoteRegion.GetName(), err)
        log.Errorf(msg)
        return err
    }

    result := localRegion.SyncElasticSearchs(ctx, userCred, provider, iEss)
    syncResults.Add(ElasticSearchManager, result)
    msg := result.Result()
    log.Infof("SyncElasticSearchs for region %s result: %s", localRegion.Name, msg)
    if result.IsError() {
        return result.AllError()
    }
    return nil
}

```

## 打包镜像，重启服务，同步资源
```bash
# 打包镜像
$ ARCH=all TAG=v3.8.es REGISTRY=registry.cn-beijing.aliyuncs.com/你的镜像命名空间 ./scripts/docker_push.sh region
# 替换镜像，重启服务
$ kubectl edit deployments. -n onecloud default-region # 替换配置文件中的image为上面打包的镜像
# 声明环境变量
$ source <(ocadm cluster rcadmin)
$ climc cloud-account-sync --force --full-sync 阿里云账号id
# 等待资源同步完成, 查看资源是否同步下来
$ climc elastic-search-list --scope system
```


## 添加资源删除操作
```bash
# 编辑 pkg/cloudprovider/resources.go
type ICloudElasticSearch interface {
    IVirtualResource
    IBillingResource
    
    // 添加删除接口
    Delete()
}

# 编辑 pkg/multicloud/aliyun/elastic_search.go 文件，实现Delete操作
func (self *SElasticSearch) Delete() error {
    return self.region.DeleteElasticSearch(self.InstanceId)
}

func (self *SRegion) DeleteElasticSearch(id string) error {
    ...
}

# 添加aliyuncli命令
# 编辑 pkg/multicloud/aliyun/shell/elk.go 文件
func init() {
    ...
    type ElkIdOptions struct {
        ID string
    }
    ...
    shellutils.R(&ElkIdOptions{}, "elastic-search-delete", "Delete elasitc search", func(cli *aliyun.SRegion, args *ElkIdOptions) error {
        return cli.DeleteElasticSearch(args.ID)
    })
}

# 编辑 pkg/compute/models/elastic_search.go 文件
# 添加删除逻辑
... 
func (self *SElasticSearch) Delete(ctx context.Context, userCred mcclient.TokenCredential) error {
    return nil
}

// 只有在资源真正删除后才删除本地数据库资源
func (self *SElasticSearch) RealDelete(ctx context.Context, userCred mcclient.TokenCredential) error {
    return self.SVirtualResourceBase.Delete(ctx, userCred)
}

// 进入删除任务
func (self *SElasticSearch) CustomizeDelete(ctx context.Context, userCred mcclient.TokenCredential, query jsonutils.JSONObject, data jsonutils.JSONObject) error {
    return self.StartDeleteTask(ctx, userCred, "")
}

func (self *SElasticSearch) StartDeleteTask(ctx context.Context, userCred mcclient.TokenCredential, parentTaskId string) error {
    task, err := taskman.TaskManager.NewTask(ctx, "ElasticSearchDeleteTask", self, userCred, nil, parentTaskId, "", nil)
    if err != nil {
        return err
    }
    self.SetStatus(userCred, api.ELASTIC_SEARCH_STATUS_DELETING, "")
    task.ScheduleRun(nil)
    return nil
}

func (self *SElasticSearch) GetRegion() (*SCloudregion, error) {
    region, err := CloudregionManager.FetchById(self.CloudregionId)
    if err != nil {
        return nil, errors.Wrapf(err, "CloudregionManager.FetchById(%s)", self.CloudregionId)
    }
    return region.(*SCloudregion), nil
}

func (self *SElasticSearch) GetIRegion() (cloudprovider.ICloudRegion, error) {
    region, err := self.GetRegion()
    if err != nil {
        return nil, errors.Wrapf(err, "GetRegion")
    }
    provider, err := self.GetDriver()
    if err != nil {
        return nil, errors.Wrap(err, "self.GetDriver")
    }
    return provider.GetIRegionById(region.GetExternalId())
}

// 获取云上对应的资源
func (self *SElasticSearch) GetIElasticSearch() (cloudprovider.ICloudElasticSearch, error) {
    if len(self.ExternalId) == 0 {
        return nil, errors.Wrapf(cloudprovider.ErrNotFound, "empty externalId")
    }
    iRegion, err := self.GetIRegion()
    if err != nil {
        return nil, errors.Wrapf(cloudprovider.ErrNotFound, "GetIRegion")
    }
    return iRegion.GetIElasticSearchById(self.ExternalId)
}

func (self *SElasticSearch) syncRemoveCloudElasticSearch(ctx context.Context, userCred mcclient.TokenCredential) error {
    // 这里需要将之前的self.Delete变更为self.RealDelete, 防止同步时资源没有删除
    return self.RealDelete(ctx, userCred)
}

# 创建 pkg/compute/tasks/elastic_search_delete_task.go 文件
# 编写删除任务

package tasks

import (
    "context"

    "yunion.io/x/jsonutils"
    "yunion.io/x/pkg/errors"

    api "yunion.io/x/onecloud/pkg/apis/compute"
    "yunion.io/x/onecloud/pkg/cloudcommon/db"
    "yunion.io/x/onecloud/pkg/cloudcommon/db/taskman"
    "yunion.io/x/onecloud/pkg/cloudprovider"
    "yunion.io/x/onecloud/pkg/compute/models"
    "yunion.io/x/onecloud/pkg/util/logclient"
)

type ElasticSearchDeleteTask struct {
    taskman.STask
}

func init() {
    taskman.RegisterTask(ElasticSearchDeleteTask{})
}

func (self *ElasticSearchDeleteTask) taskFail(ctx context.Context, es *models.SElasticSearch, err error) {
    es.SetStatus(self.GetUserCred(), api.ELASTIC_SEARCH_STATUS_DELETE_FAILED, err.Error())
    db.OpsLog.LogEvent(es, db.ACT_DELOCATE_FAIL, err, self.UserCred)
    // 记录删除失败日志
    logclient.AddActionLogWithStartable(self, es, logclient.ACT_DELETE, err, self.UserCred, false)
    self.SetStageFailed(ctx, jsonutils.NewString(err.Error()))
}

func (self *ElasticSearchDeleteTask) OnInit(ctx context.Context, obj db.IStandaloneModel, data jsonutils.JSONObject) {
    es := obj.(*models.SElasticSearch)

    iEs, err := es.GetIElasticSearch()
    if err != nil {
        if errors.Cause(err) == cloudprovider.ErrNotFound {
            self.taskComplete(ctx, es)
            return
        }
        self.taskFail(ctx, es, errors.Wrapf(err, "GetIElasticSearch"))
        return
    }
    err = iEs.Delete()
    if err != nil {
        self.taskFail(ctx, es, errors.Wrapf(err, "iEs.Delete"))
        return
    }
    self.taskComplete(ctx, es)
}

func (self *ElasticSearchDeleteTask) taskComplete(ctx context.Context, es *models.SElasticSearch) {
    es.RealDelete(ctx, self.GetUserCred())
    self.SetStageComplete(ctx, nil)
}

# 编辑 cmd/climc/shell/compute/elastic_search.go 文件
# 添加climc删除命令
func init() {
    ...
    cmd.Delete(&compute.ElasticSearchIdOption{})
}

# 测试删除
$ climc elastic-search-delete test-elastic-search
```

## 资源清理(云账号删除)
```bash
# 此步骤仅适用于新资源接入，已有资源不涉及此操作
# 编辑 pkg/compute/models/purge.go 文件
# 追加以下内容
func (manager *SElasticSearchManager) purgeAll(ctx context.Context, userCred mcclient.TokenCredential, providerId string) error {
    ess := []SElasticSearch{}
    err := fetchByManagerId(manager, providerId, &ess)
    if err != nil {
        return errors.Wrapf(err, "fetchByManagerId")
    }
    for i := range ess {
        lockman.LockObject(ctx, &ess[i])
        defer lockman.ReleaseObject(ctx, &ess[i])

        err := ess[i].RealDelete(ctx, userCred)
        if err != nil {
            return errors.Wrapf(err, "elastic search delete")
        }
    }
    return nil
}
# 编辑 pkg/compute/models/cloudproviders.go 文件
func (self *SCloudprovider) RealDelete(ctx context.Context, userCred mcclient.TokenCredential) error {
    for _, manager := range []IPurgeableManager{
        ...
        // 根据资源依赖排序，依赖越小，排的越前
        ElasticSearchManager,
        ...
    } {
        ...
    }
    
    ...
}
```
