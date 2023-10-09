---
title: "查询 API"
weight: 1
description:
  概述monitor监控服务unifiedmonitor的查询接口，以及一些额外注意事项。
---

## 查询请求

目前监控服务的后端对接的 influxdb ，发送的查询请求会转换成 influxdb 的 query 请求，然后返回转换相关 metrics 。

- 方法: POST
- 路径: /api/v1/unifiedmonitors/query/
- Body: 内容参考下面的例子

### 查询举例

下面的查询请求会转换成 influxdb 的 query 请求：

1. 查询虚拟机 CPU 使用率

```javascript
{
    "metric_query": [
        {
            "model": {
                "measurement": "vm_cpu", // 对应 influxdb 里面的 measurement
                "select": [ // 对应 SELECT
                    [
                        {
                            "type": "field",
                            "params": [
                                "usage_active" // 查询的指标字段
                            ]
                        },
                        {
                            "type": "mean", // 取平均值，其他支持的类型请参考：https://github.com/yunionio/cloudpods/blob/v3.10.0-rc2/pkg/monitor/tsdb/driver/influxdb/query_part.go#L36-L116
                            "params": []
                        },
                        {
                            "type": "alias", // 设置别名
                            "params": [
                                "CPU使用率"
                            ]
                        }
                    ]
                ],
                "tags": [ // 对应 WHERE
                    {
                        "key": "vm_id",
                        "value": "49d1f759-138e-4495-8e35-94c2128374f1",
                        "operator": "="
                    },
                    {
                        "condition": "OR", // 可设置 OR 和 AND
                        "key": "hostname",
                        "value": "vm1",
                        "operator": "="
                    }
                ],
                "group_by": [ // 对应 GROUP BY
                    {
                        "type": "tag",
                        "params": [
                            "vm_id"
                        ]
                    }
                ]
            }
        }
    ],
    "scope": "system", // 查询资源作用域，system 代表全局作用域，domain 代表域作用域，project 代表项目作用域
    "from": "1h", // 查询过去 1h 的指标
    "to": "now", // 到现在，非必需，默认就是从 from 到现在
    "interval": "1m", // 指标间隔
    "skip_check_series": false, // 是否跳过去云平台进行资源检查，补充缺失的 tag
    "signature": "3be888cf6e45cb72cc1103ec0fd789572e2f3dc93566a8fe86694518e83625e8" // 根据以上字段计算出来的签名
}
```

转换后的 influxdb 请求为：

```sql
SELECT mean("usage_active") AS "CPU使用率" FROM "vm_cpu"
WHERE ("vm_id" = '49d1f759-138e-4495-8e35-94c2128374f1' OR "hostname" = 'vm1') and time > now() - 1h
GROUP BY "vm_id", time(1m) fill(none)
```

更多支持的查询举例：

可以参考：[https://github.com/yunionio/cloudpods/blob/v3.10.0-rc2/pkg/monitor/tsdb/driver/influxdb/query_test.go](https://github.com/yunionio/cloudpods/blob/v3.10.0-rc2/pkg/monitor/tsdb/driver/influxdb/query_test.go)

```
# 下面的请求 body 对应 influxdb sql 为："SELECT mean(\"free\") / mean(\"total\") FROM \"disk\" WHERE (\"path\" = '/') AND time > now() - 1h GROUP BY *, time(2m) fill(none)"

{
	"database": "telegraf",
	"measurement": "disk",
	"select": [
		[
			{
				"type": "field",
				"params": [
					"free"
				]
			},
			{
				"type": "mean"
			},
			{
				"type": "math",
				"params": [
					"/ mean(\"total\")"
				]
			}
		]
	],
	"tags": [
		{
			"key": "path",
			"value": "/",
			"operator": "="
		}
	]
}
```

2. 自定义查询时间段

通过设置 from 和 to 两个参数，可以定义查询时间段，influxdb 里面的指标会默认保留 30 天。

其中 from 和 to 需要转换为 unix epoch 的格式，比如：

```javascript
{
  "metric_query": [...],
  "from": "1474973725473", // 2016年9月27日星期二晚上6点55分 GMT+08:00
  "to":   "1474975757930", // 2016年9月27日星期二晚上7点29分 GMT+08:00
}
```

## 签名

signature 签名的作用是防止查询条件被篡改，如果不需要该功能，可以配置 monitor 服务关闭。

### 关闭签名

使用下面的方式关闭签名校验：

```bash
# 修改 monitor 服务 configmap 配置
$ kubectl edit configmap -n onecloud default-monitor
...
    # 将该配置改为 true
    disable_query_signature_check: true
...

# 重启 monitor 服务
$ kubectl rollout restart deployment -n onecloud default-monitor
```

### 计算方法

如果需要使用签名校验的功能，可以参考下面的方式计算 signature:

signature 的计算方法可以参考这里前端 javascript 代码：[https://github.com/yunionio/dashboard/blob/v3.10.0-rc2/src/utils/crypto.js#L11-L18](https://github.com/yunionio/dashboard/blob/v3.10.0-rc2/src/utils/crypto.js#L11-L18)

## 登陆 influxdb 直接查询数据

有些情况不确定查询的 API 数据是否准确，可以用下面的方法直接进入 influxdb 容器使用命令行查询指标：

```bash
$ kubectl exec -ti -n onecloud $(kubectl get pods -n onecloud | grep default-influxdb | awk '{print $1}') -- influx -host 127.0.0.1 -port 30086 -type influxql -ssl  -precision rfc3339 -unsafeSsl

# 使用 telegraf database
use telegraf

# 查看有哪些 measurements
show measurements
```
