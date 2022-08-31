---
title: "添加选项支持外表查询"
edition: ce
weight: 4
description: 对于表内的排序功能，可以通过order_by&&order来实现，而对于表外的关联查询功能，order_by&&order已不足以实现,因此需要添加额外的字段来实现关联查询的功能，本次以disk关联guest根据guest总数排序为例
---

## 确定资源
首先确定所需添加关联的资源，例如本次为disk资源，因此在climc调用中即对应disk-list,而在climc，与region中所需修改添加的文件有cmd/climc/shell/compute/disks.go、pkg/apis/compute/disks.go、pkg/compute/models/disks.go

## climc内容

在climc中主要用于命令行输入，确定传入参数，--order-by-guest-count asc|desc

```bash
# vim cmd/climc/shell/compute/disks.go，在init()中的ListOptions中添加命令

type DiskListOptions struct {
		options.BaseListOptions
		...
		OrderByGuestCount string `help:"Order By Guest Count"`
        ...
}

```

##  region内容

在climc中主要用于逻辑处理，确定所需添加list的命令的region服务字段

```sh
#vim pkg/apis/compute/disks.go，在ListInput中添加字段
type DiskListInput struct {
	...
	OrderByGuestCount sting `json:"order_by_guest_count" choices:"asc|desc"`
	...
}
```


```sh
#vim pkg/compute/models/disks.go,在OrderByExtraFields函数中添加排序逻辑
func (manager *SDiskManager) OrderByExtraFields(
	ctx context.Context,
	q *sqlchemy.SQuery,
	userCred mcclient.TokenCredential,
	query api.DiskListInput,
) (*sqlchemy.SQuery, error) {
	...
if db.NeedOrderQuery([]string{query.OrderByGuestCount}) {
		guestdisks := GuestdiskManager.Query().SubQuery()
		disks := DiskManager.Query().SubQuery()
		guestdiskQ := guestdisks.Query(
			guestdisks.Field("guest_id"),
			guestdisks.Field("disk_id"),
			sqlchemy.COUNT("guest_count", guestdisks.Field("guest_id")),
		)

		guestdiskQ = guestdiskQ.LeftJoin(disks, sqlchemy.Equals(guestdiskQ.Field("disk_id"), disks.Field("id")))
		guestdiskSQ := guestdiskQ.GroupBy(guestdiskQ.Field("disk_id")).SubQuery()
		q.AppendField(q.QueryFields()...)
		q.AppendField(guestdiskSQ.Field("guest_count"))
		q = q.LeftJoin(guestdiskSQ, sqlchemy.Equals(q.Field("id"), guestdiskSQ.Field("disk_id")))
		db.OrderByFields(q, []string{query.OrderByGuestCount}, []sqlchemy.IQueryField{guestdiskQ.Field("guest_count")})
	}
	...
}
```
