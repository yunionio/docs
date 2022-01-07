---
title: "问题排查工具"
weight: 8
description:
  介绍Cloudpods的问题排查工具
---

本节介绍有助于调试服务程序的工具和API。

## 内置API

每个采用Cloudpods服务框架的服务都会自动注册一系列的API，用于获得服务的关键运行指标和状态，方便诊断服务程序问题。下面逐一介绍。

### 内置状态API

| 请求方法  | API路径       | climc子命令       | 说明                                                                       |
|-----------|---------------|-------------------|-----------------------------------------------------------------------------|
| GET       | /stats        | api-stats-show    | 对应服务的每个API URL的请求统计，累计请求次数，平均请求延时等               |
| GET       | /db_stats     | db-stats-show     | 对应服务的数据库统计，包括最大连接数，活跃连接数等                          |
| GET       | /worker_stats | worker-stats-show | 对应服务内的goroutine池的worker的统计，包括每个worker的活跃数量，队列长度等 |
| GET       | /version      | version-show      | 服务的版本号                                                                |

### Profile API

Cloudpods服务内置了golang的profile工具(https://pkg.go.dev/net/http/pprof)，可以通过调用这些API获得服务的profile数据。

| 请求方法 | API路径              | 对应pprof方法 |
|----------|----------------------|---------------|
| GET      | /debug/pprof/        | pprof.Index   |
| GET      | /debug/pprof/cmdline | pprof.Cmdline |
| GET      | /debug/pprof/profile | pprof.Profile |
| GET      | /debug/pprof/symbol  | pprof.Symbol  |
| POST     | /debug/pprof/symbol  | pprof.Symbol  |
| GET      | /debug/pprof/trace   | pprof.Trace   |

### 获取调用栈

可以通过给服务进程发送SIGUSR1信号，触发服务进程打印当前调用栈。该方法有助于发现程序Block的函数调用栈，找到阻塞的函数方法。

```bash
kill -s SIGUSR1 <pid>
```
