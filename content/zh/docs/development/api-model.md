---
title: "定位后端代码"
weight: 11
edition: ce
description: >
  介绍如何从API请求定位后端代码
---

# 查看前端请求

这里以虚拟机举例

- 打开虚拟机列表界面
![](../images/vms.png)

- 右键打开检查并切换到Network
![](../images/vms-network.png)

- 点击刷新并查看网络请求
![](../images/vms-api.png)

这里看到API请求是 GET https://office.ioito.com/api/v2/servers 其他请求可以查看下[API请求方法](../framework/#model-dispatcher)

可以确定是请求的是servers资源

# 通过资源名称定位代码

```bash
# 进入到cloudpods源码目录
$ cd cloudpods

# 通过关键字'servers'查找
$ grep -r 'servers' pkg/mcclient/modules
pkg/mcclient/modules/compute/mod_servers.go:    Servers = ServerManager{modules.NewComputeManager("server", "servers",
pkg/mcclient/modules/compute/mod_skus.go:       ServerSkus = ServerSkusManager{modules.NewComputeManager("serversku", "serverskus",


# 可以看到servers属于compute(region)服务,现在到compute服务的模型里面搜索servers关键字
$ grep -r 'servers' pkg/compute/models
pkg/compute/models/loadbalanceragents.go:       servers = ["{{ .telegraf.haproxy_input_stats_socket }}"]
pkg/compute/models/skus.go:                     "serverskus_tbl",
pkg/compute/models/skus.go:                     "serversku",
pkg/compute/models/skus.go:                     "serverskus",
pkg/compute/models/skus.go:             return httperrors.NewNotEmptyError("now allow to delete inuse instance_type.please remove related servers first: %s", self.Name)
pkg/compute/models/skus.go:             return httperrors.NewNotEmptyError("instance_type used by servers")
pkg/compute/models/skus.go:     lockman.LockRawObject(ctx, "serverskus", region.Id)
pkg/compute/models/skus.go:     defer lockman.ReleaseRawObject(ctx, "serverskus", region.Id)
pkg/compute/models/skus.go:     lockman.LockRawObject(ctx, "serverskus", region.Id)
pkg/compute/models/skus.go:     defer lockman.ReleaseRawObject(ctx, "serverskus", region.Id)
pkg/compute/models/guests.go:// +onecloud:swagger-gen-model-plural=servers
pkg/compute/models/guests.go:                   "servers",
pkg/compute/models/guests.go:           // fake delete expired prepaid servers
pkg/compute/models/groups.go:                   return nil, errors.Wrapf(httperrors.ErrInvalidStatus, "inconsistent networkId for member servers")
pkg/compute/models/hosts.go:                    "__on_host_down":              "shutdown-servers",
pkg/compute/models/hosts.go:            _, err := self.Request(ctx, userCred, "POST", "/hosts/shutdown-servers-on-host-down",
pkg/compute/models/hosts.go:                    db.OpsLog.LogEvent(host, db.ACT_HOST_DOWN, fmt.Sprintf("migrate servers failed %s", err), userCred)
pkg/compute/models/keypairs.go:         return httperrors.NewNotEmptyError("Cannot delete keypair used by servers")
pkg/compute/models/disks.go:            return httperrors.NewNotEmptyError("Virtual disk %s(%s) used by virtual servers", self.Name, self.Id)
pkg/compute/models/guest_actions.go:    url := fmt.Sprintf("%s/servers/%s/monitor", host.ManagerUri, self.Id)
pkg/compute/models/guest_actions.go:    taskData.Set("servers", jsonutils.Marshal(host.Servers))

# 从上可以看到只有 pkg/compute/models/guests.go 文件有完整的 servers 关键字, 可以确定代码就位于此文件
# 我们详细介绍下guests.go文件
$ cat pkg/compute/models/guests.go | grep '"servers"' -A 7 -B 6
func init() {
        GuestManager = &SGuestManager{
                SVirtualResourceBaseManager: db.NewVirtualResourceBaseManager(
                        SGuest{},
                        "guests_tbl",
                        "server",
                        "servers",
                ),
                SRecordChecksumResourceBaseManager: *db.NewRecordChecksumResourceBaseManager(),
        }
        GuestManager.SetVirtualObject(GuestManager)
        GuestManager.SetAlias("guest", "guests")
        GuestManager.NameRequireAscii = false
}

# 从上面可以看到这里初始化了虚拟机的Manager, 虚拟机数据是存储在数据库guests_tbl这个表里面
```

# 特殊API请求说明

大部分请求都可以从上面的方法找到后端代码, 但部分API请求是由网关直接注册的
这类的API需要查看[API网关](https://github.com/yunionio/cloudpods/tree/master/pkg/apigateway)代码

这里以RPC API举例说明

- 点击获取虚拟机密码查看api请求
![](../images/vms-rpc.png)

```bash
# 搜寻rpc关键字
$ grep -r 'rpc' pkg/apigateway/handler
pkg/apigateway/handler/rpc.go:  h.AddByMethod(GET, mf, NewHP(RpcHandler, APIVer, "rpc"))
pkg/apigateway/handler/rpc.go:  h.AddByMethod(POST, mf, NewHP(RpcHandler, APIVer, "rpc"))


# 通过查看API网关RpcHandler源码可知, RPC请求是依靠反射调用mcclient模型中的GetXXX或DoXXX实现的
# 这里的XXX是驼峰命名
# 这里看到是GET请求，因此可以知道是调用了servers里面的GetLoginInfo
# 因此我们可以顺利找到相关的实现
$ grep -r 'GetLoginInfo' pkg/mcclient/modules/compute
pkg/mcclient/modules/compute/mod_servers.go:func (this *ServerManager) GetLoginInfo(s *mcclient.ClientSession, id string, params jsonutils.JSONObject) (jsonutils.JSONObject, error) {
pkg/mcclient/modules/compute/mod_hosts.go:func (this *HostManager) GetLoginInfo(s *mcclient.ClientSession, id string, params jsonutils.JSONObject) (jsonutils.JSONObject, error) {
pkg/mcclient/modules/compute/mod_dbinstanceaccounts.go:func (this *SDBInstanceAccountManager) GetLoginInfo(s *mcclient.ClientSession, id string, params jsonutils.JSONObject) (jsonutils.JSONObject, error) {
pkg/mcclient/modules/compute/mod_elasticcache.go:func (self *ElasticCacheManager) GetLoginInfo(s *mcclient.ClientSession, id string, params jsonutils.JSONObject) (jsonutils.JSONObject, error) {
pkg/mcclient/modules/compute/mod_elasticcache.go:func (self *ElasticCacheAccountManager) GetLoginInfo(s *mcclient.ClientSession, id string, params jsonutils.JSONObject) (jsonutils.JSONObject, error) {
```
