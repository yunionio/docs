---
title: "添加一个API的过程"
weight: 50
description: >
  介绍如何添加一个新的API

---

本文以DNS记录导出Zone格式文件为例，介绍如何添加一个API。

## 原理

实现Zone格式文件导出DNS资源记录：将某个dns zone在数据库中的dns记录读出，按Zone文件的格式组织成字符串，并返回json格式的结果。

根据[后端服务框架](https://www.cloudpods.org/zh/docs/development/framework/#)：

* REST API 负责解析客户端发送的 CRUD http 请求，将不同的请求对应到 Model Dispatcher 模块；
* Model Dispatcher 将客户端的请求分发到对应资源的业务操作；
* Model 定义云平台各种资源，会进行数据库读写相关操作。

因此根据[后端代码结构](https://www.cloudpods.org/zh/docs/development/codestruct/)：

* pkg/compute/models为服务资源模型代码，一般一个model对应数据库中的一张表。由于要处理某个zone下的所有dns记录，所以在dns_zones.go文件中给SDnsZone增加**GetDetailsExports**方法，必要时也可以在dns_recordsets.go文件中向SDnsRecordSet增加处理一条dns记录的方法。

  ```go
  func (self *SDnsZone) GetDetailsExports(ctx context.Context, userCred mcclient.TokenCredential, query jsonutils.JSONObject) (jsonutils.JSONObject, error) {
      // TODO
  }
  ```

* pkg/cloudcommon/db为服务models通用代码，在db_dispatcher.go文件的**GetSpecific**方法中，可以看到对上述GetDetailsXXX方法进行了反射调用。

* cmd/climc/shell为各个服务对应的命令行工具代码，在cmd/climc/shell/compute/dnszone.go文件中调用**GetWithCustomShow**方法，该方法会调用上述GetSpecific方法，用于测试dns-zone-exports命令返回的结果。GetWithCustomShow的第一个参数是GetDetailsXXX的XXX的小写，第二个参数为处理GetDetailsXXX返回结果的函数，第三个参数为该测试命令的参数。

  ```go
  cmd.GetWithCustomShow("exports", func(result jsonutils.JSONObject) {
      // TODO	
  }, &options.SDnsZoneIdOptions{})
  ```

## 实现

### 实现GetDetailsExports方法

编辑 pkg/compute/models/dns_zones.go 文件

```go
// 将dns记录转换成zone格式，返回json
func (self *SDnsZone) GetDetailsExports(ctx context.Context, userCred mcclient.TokenCredential, query jsonutils.JSONObject) (jsonutils.JSONObject, error) {
        // 获取数据库中dns记录
        records, err := self.GetDnsRecordSets()
        if err != nil {
                return nil, errors.Wrapf(err, "GetDnsRecordSets")
        }
        // zone文件内容
        result := "$ORIGIN " + self.Name + ".\n"
        lines := []string{}
        for _, record := range records {
                lines = append(lines, record.ToZoneLine())
        }
        result += strings.Join(lines, "\n")
        // 将string写成map，并转换成json返回
        rr := make(map[string]string)
        rr["zone"] = result
        return jsonutils.Marshal(rr), nil
}
```

### 实现ToZoneLine方法

编辑 pkg/compute/models/dns_recordsets.go 文件，实现上文的 ToZoneLine() 方法

```go
// 将一条dns记录转换成zone格式，返回string
func (self *SDnsRecordSet) ToZoneLine() string {
        result := self.Name + "\t" + fmt.Sprint(self.TTL) + "\tIN\t" + self.DnsType + "\t"
        if self.MxPriority != 0 {
                result += fmt.Sprint(self.MxPriority) + "\t"
        }
        result += self.DnsValue
        if self.DnsType == "CNAME" || self.DnsType == "MX" || self.DnsType == "SRV" {
                result += "."
        }
        return result
}
```

### climc命令编写

编辑 cmd/climc/shell/compute/dnszone.go 文件

```go
// 用于命令行测试
func init() {
        cmd := shell.NewResourceCmd(&modules.DnsZones).WithKeyword("dns-zone")
    
        ...
    
        // 添加dns-zone-exports命令
        cmd.GetWithCustomShow("exports", func(result jsonutils.JSONObject) {
                // 将 GetDetailsExports 返回的json转换成map
                rr := make(map[string]string)
                err := result.Unmarshal(&rr)
                if err != nil {
                        log.Errorf("error: %v", err)
                        return
                }
                // 输出结果
                for _, v := range rr {
                        fmt.Printf("%s\n", v)
                }
        }, &options.SDnsZoneIdOptions{})
}
```

## 测试

```bash
# 编译 climc 和 region
$ make cmd/climc cmd/region

# 执行climc
$ cd cloudpods/_output/bin
$ climc

# 测试命令
climc> dns-zone-exports <zone id>

# 退出
climc> exit
```

