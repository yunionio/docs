---
title: "Cloudpods Go 语言规范"
weight: 4
description: >
  介绍Cloudpods Go 语言规范
---


## 代码风格

大部分格式问题都可以通过 **gofmt** 解决，gofmt 自动格式化代码，保证所有的go代码与官方推荐的格式保持一致，于是所有格式有关问题，都以gofmt的结果为准。
不同的编辑器有不同的配置, sublime的配置教程：http://michaelwhatcott.com/gosublime-goimports/
- LiteIDE默认已经支持了goimports，如果你的不支持请点击属性配置->golangfmt→勾选goimports保存之前自动fmt你的代码
- 使用 vim 开发请安装插件：https://github.com/fatih/vim-go  或者 coc.nvim + gopls
- 使用 vscode 开发请直接安装里面的 Go 插件：https://github.com/golang/vscode-go

## 命名规则

Go语言程序员推荐使用 **驼峰式** 命名,当名字有几个单词组成的时优先使用大小写分隔,而不是优先用下划线分隔。
因此,在标准库有 QuoteRuneToASCII 和 parseRequestLine 这样的函数命名,但是一般不会用 quote_rune_to_ASCII 和 parse_request_line 这样的命名。
而像ASCII和HTML这样的缩略词则避免使用大小写混合的写法,它们可能被称为htmlEscape、HTMLEscape或escapeHTML,但不会是escapeHtml。


## 文件名
以kerbab命名法命名，比如：foo_bar.go

## 包名 (package)

包名与包所在的目录名一致并小写

## 结构体 (Struct)

必须以 **S** 开头，私有struct名以小写 s 开头
遵循CamelCase(驼峰）命名法，由有意义的名词组合而成

## 接口 (Interface)

遵循CamelCase(驼峰）命名法
必须以 I 开头，私有interface名以小写 i 开头 , 比如：IModelManager 

## 函数或方法

- 遵循CamelCase(驼峰）命名法，由有意义的英文单词拼接而成
- 若函数或方法为判断类型（返回值主要为 bool 类型），则名称应以 Has, Is, Can 或 Allow 等判断性动词开头：
```go
func HasPrefix(name string, prefixes []string) bool { ... }
func IsEntry(name string, entries []string) bool { ... }
func CanManage(name string) bool { ... }
func AllowGitHook() bool { ... }
```
- 必须以动词开头，如Get/Set/Make/Upload等，从名字能看出该方法实现的功能

## 常量

- 常量均需使用全部大写字母组成，并使用下划线分词：
```go
const APP_VER = "0.7.0.1110 Beta"
```

- 如果是枚举类型的常量，需要先创建相应类型，并且以大写 T（公共类型） 或小写 t（私有类型） 开头：
```go
type TScheme string
 
const (
   HTTP  TScheme = "http"
   HTTPS TScheme = "https"
)
```

- 如果模块的功能较为复杂、常量名称容易混淆的情况下，为了更好地区分枚举类型，可以使用完整的前缀：
```go
type TPullRequestStatus int
 
const (
   PULL_REQUEST_STATUS_CONFLICT TPullRequestStatus = iota
   PULL_REQUEST_STATUS_CHECKING
   PULL_REQUEST_STATUS_MERGEABLE
)
```

## 变量

### 变量命名
- 遵循CamelCase(驼峰）命名法，由有意义的英文单词拼接而成
- 必须为名词，变量命名基本上遵循相应的英文表达或简写
- 在相对简单的环境（对象数量少、针对性强）中，可以将一些名称由完整单词简写为单个字母，例如：
    - user 可以简写为 u
    - userID 可以简写 uid
- 若变量类型为 bool 类型，则名称应以 Has, Is, Enable, Can 或 Allow 开头：
```go

var isExist bool
var hasConflict bool
var canManage bool
var allowGitHook bool
```
- 上条规则也适用于结构定义：
```go

// Webhook represents a web hook object.
type Webhook struct {
   Id           int64 `xorm:"pk autoincr"`
   RepoID       int64
   OrgID        int64
   Url          string `xorm:"url TEXT"`
   ContentType  HookContentType
   Secret       string `xorm:"TEXT"`
   Events       string `xorm:"TEXT"`
   *HookEvent   `xorm:"-"`
   IsSSL        bool `xorm:"is_ssl"`
   IsActive     bool
   HookTaskType HookTaskType
   Meta         string     `xorm:"TEXT"` // store hook-specific attributes
   LastStatus   HookStatus // Last delivery status
   Created      time.Time  `xorm:"CREATED"`
   Updated      time.Time  `xorm:"UPDATED"`
}
```

###  string变量

类似Java的String，golang中的string为immutable变量，通过concat构造string时，请用bytes.Buffer或者strings.Builder
```go
var buf bytes.Buffer
buf.WriteByte('a')
buf.WriteString("b")
return buf.String()
```

### size变量命名

容量，大小，时间等的变量，为了避免量纲的混淆，需要带上单位量纲，例如：sizeMb, sizeGb, intervalSeconds等。

## 声明语句

### 函数或方法

- 函数或方法的参数排列顺序遵循以下几点原则（从左到右）：
    - 简单类型优先于复杂类型
    - 尽可能将同种类型的参数放在相邻位置，则只需写一次类型

以下声明语句，User 类型要复杂于 string 类型，但由于 Repository 是 User 的附属品，首先确定 User 才能继而确定 Repository。因此，User 的顺序要优先于 repoName。
```go
func IsRepositoryExist(user *User, repoName string) (bool, error) { ...
```
- 函数的返回值尽量避免使用命名的函数返回值
举例：
```go
func findCertEndPosition(certBytes []byte) (endPost int, err error) {
    endPos = bytes.Index(certBytes, CERT_SEP)
    if endPos < 0 {
        err = ErrOutOfRange
        return
    }
    return
}
```
建议的方式：
```go
func findCertEndPosition(certBytes []byte) (int, error) {
    endPos := bytes.Index(certBytes, CERT_SEP)
    if endPos < 0 {
        return -1, ErrOutOfRange
    }
    return endPos, nil
}
```

- 除非函数执行流程确定无错误发生，或者错误可以确定忽略，函数的返回值尽量携带error。代码流程中遇到错误要尽早返回，并且除非做了特殊处理，遇到错误时应该立即显式返回。

举例：不建议的方式
```go

func findCertEndPosition(certBytes []byte) (int, error) {
    endPos := bytes.Index(certBytes, CERT_SEP)
    if endPos < 0 {
        log.Errorf("find not certEndPost") // find error, but no immediate return
    }
    ...
    return endPos, nil
}
```

建议的方式：
```go
func findCertEndPosition(certBytes []byte) (int, error) {
    endPos := bytes.Index(certBytes, CERT_SEP)
    if endPos < 0 {
        log.Errorf("find not certEndPost") // find error and immediately return error
        return -1, ErrOutOfRange
    }
    ...
    return endPos, nil
}
```
- 避免不必要的else分支

举例: 不建议的方式
```go
func (s *SReadSeeker) Read(p []byte) (int, error) {
    if s.offset == s.readerOffset && s.offset < s.readerSize {
        n, err := s.reader.Read(p)
        if n > 0 {
            wn, werr := s.tmpFile.Write(p[:n])
            if werr != nil {
                return n, werr
            }
            if wn < n {
                return n, errors.Error("sFakeSeeker write less bytes")
            }
            s.offset += int64(n)
            s.readerOffset += int64(n)
        }
        return n, err
    } else {
        n, err := s.tmpFile.ReadAt(p, s.offset)
        if n > 0 {
            s.offset += int64(n)
        }
        return n, err
    }
}
```
建议的方式
```go
func (s *SReadSeeker) Read(p []byte) (int, error) {
    if s.offset == s.readerOffset && s.offset < s.readerSize {
        n, err := s.reader.Read(p)
        if n > 0 {
            wn, werr := s.tmpFile.Write(p[:n])
            if werr != nil {
                return n, werr
            }
            if wn < n {
                return n, errors.Error("sFakeSeeker write less bytes")
            }
            s.offset += int64(n)
            s.readerOffset += int64(n)
        }
        return n, err
    }
    n, err := s.tmpFile.ReadAt(p, s.offset)
    if n > 0 {
        s.offset += int64(n)
    }
    return n, err
}
```

- 除非必要，尽量避免使用interface{}, jsonutils.JSONObject等通用的数据类型作为函数的输入参数和输出参数。建议定义struct或者专门的type来约束参数类型，以利用好golang的静态类型检查，发现传参错误。

## 控制语句

如非必须，避免使用超过3个分支以上的if ... else ... 嵌套，这种情况应该考虑使用switch case语句替换。
尽量避免使用if初始化语句，除非初始化语句只有一个分支。禁止使用多个分支的if初始化语句。

举例：不建议的方式
```go
if diskId, err := cli.CreateDisk(args.StorageType, args.NAME, args.SizeGb, args.Desc, args.Image); err != nil {
    return err
} else if disk, err := cli.GetDisk(diskId); err != nil {
    return err
} else {
    printObject(disk)
    return nil
}
```
建议的方式:
```go
diskId, err := cli.CreateDisk(args.StorageType, args.NAME, args.SizeGb, args.Desc, args.Image)
if err != nil {
    return err
}
disk, err := cli.GetDisk(diskId)
if err != nil {
    return err
}
printObject(disk)
return nil
```

当使用range循环枚举Array/Slice和Map时，需要注意在如下的模式中，变量k, v的内存地址在每次循环时都是同一个，每次循环开始时通过内存拷贝，将对应key值和Slice[k]/Map[k]的值拷贝到k, v的内存中。
```go
for k, v := range myMap {
    // access v
}
```
如果要直接访问Slice[k]/Map[k]的内存，请用如下方式
```go
for k := range myMap {
    // access &myMap[k]
}
```
建议：使用for...range遍历map或slice时，如果不确定，请只对key(for map)或index(for slice)进行遍历，在for ...range的body里，通过map[key]或slice[index]访问map或slice里的元素。

## 行宽

尽量避免很长的一行代码

举例：不建议的方式
```go
func init() {
    CachedimageManager = &SCachedimageManager{SStandaloneResourceBaseManager: db.NewStandaloneResourceBaseManager(SCachedimage{}, "cachedimages_tbl", "cachedimage", "cachedimages")}
}
```
建议的方式
```go
func init() {
    CachedimageManager = &SCachedimageManager{
        SStandaloneResourceBaseManager: db.NewStandaloneResourceBaseManager(
            SCachedimage{},
            "cachedimages_tbl",
            "cachedimage",
            "cachedimages",
        ),
    }
}
```

## 函数间距
尽量避免函数直接紧挨一起
举例：不建议的方式
```go
func IsRepositoryExist(user *User, repoName string) (bool, error) { ...
    
}
func findCertEndPosition(certBytes []byte) (int, error) {
    endPos := bytes.Index(certBytes, CERT_SEP)
    if endPos < 0 {
        return -1, ErrOutOfRange
    }
    return endPos, nil
}
```
建议的方式
```go
func IsRepositoryExist(user *User, repoName string) (bool, error) { ...
    
}

func findCertEndPosition(certBytes []byte) (int, error) {
    endPos := bytes.Index(certBytes, CERT_SEP)
    if endPos < 0 {
        return -1, ErrOutOfRange
    }
    return endPos, nil
}
```

## Receiver或者函数传参类型（by value or by pointer）建议
- 方法的receiver或者入参可以by value或by pointer来传递，参考https://github.com/golang/go/wiki/CodeReviewComments#receiver-type，一般来说遵循如下建议：
    - 如果receiver或入参的类型是map, func或者chan，不要用指针。如果是slice，如果不想重新分配slice（reslice or reallocate the slice），也不要用指针。
    - 如果该方法内需要修改该receiver或入参的成员变量，必须用指针
    - 如果receiver或者入参是包含sync.Mutex或其他用于同步的数据结构，必须用指针
    - 如果receiver或者入参是很大的struct或者array，用指针传递会高效一些（避免了内存拷贝）
    - 如果receiver或者入参是struct, array, slice，并且其成员变量包含指针，并且需要修改该指针指向的值，那么建议用指针
    - 如果receiver或者入参是一个基本数据（如int, string, time.Time），小的struct，并且对该数的修改只在函数内有效，那建议传值。值传递的参数在栈上分配，尽量使用值传递可以降低内存垃圾回收几率，提高程序的效率
    - 最后，如果不太确定，就传指针

## 代码注释

注释应优先使用双斜线（//）。用“/* ... */”的情况：大段文字，长度达页，例如encoding/gob的doc.go
代码中“魔法”的部分，应通过注释描述缘由，变更此处的注意事项，以及变更不当的后果。这样做改进时有机会可以照顾到
注释应该“言之有物”，简练便于快速阅读
 - 通常以被注释的名字开头，用一个短句概括功能（who does what），上下文一般是当前package或者其所组成的更大功能点。
 - 更细节的描述另开段落，一个段落一件事，段首第一句话体现后续内容主题
代码变更过程中，不再使用的代码应直接删除，不建议使用注释
举例:
```go
// Errorf formats according to a format specifier and returns the string
// as a value that satisfies error.
func Errorf(format string, a ...interface{}) error {
        return errors.New(Sprintf(format, a...))
}
 
// Strings for use with buffer.WriteString.
// This is less overhead than using buffer.Write with byte arrays.
const (
        commaSpaceString  = ", "
        nilAngleString    = "<nil>"
        ...
)
 
// State represents the printer state passed to custom formatters.
// It provides access to the io.Writer interface plus information about
// the flags and options for the operand's format specifier.
type State interface {
        // Write is the function to call to emit formatted output to be printed.
        Write(b []byte) (n int, err error)
        ...
}
```

## 导入标准库、第三方或其它包

除标准库外，Go 语言的导入路径基本上依赖代码托管平台上的 URL 路径，因此一个源文件需要导入的包有 4 种分类：标准库、第三方包、组织内其它包和当前包的子包。
基本规则：
- 如果同时存在 2 种及以上，则需要使用分区来导入。每个分类使用一个分区，采用空行作为分区之间的分割。
- 在非测试文件(\*_test.go）中，禁止使用 . 来简化导入包的对象调用。
- 禁止使用相对路径导入（./subpackage），所有导入路径必须符合 go get 标准。
下面是一个完整的示例：
```go
import (
    "fmt"
    "encoding/json"
    "net/http"
    "os"
 
    "github.com/codegangsta/cli"
    "gopkg.in/macaron.v1"
    "k8s.io/helm/pkg/helm"
 
    "github.com/yunionio/jsonutils"
    "github.com/yunionio/log"
 
    "github.com/yunionio/onecloud/pkg/cloudcommon"
    "github.com/yunionio/onecloud/pkg/compute/models"
)
```

## API参数暴露
基本规则：
- 创建及过滤参数,若是内部的model,请使用model的keyword, 避免使用keyword_id向外暴露参数

```go
type ServerCreateInput struct {
 
    //主机快照ID或name，尽量使用主机快照ID进行唯一匹配
    InstanceSnapshot string
 
    //swagger:ignore 内部使用，API文档里面不会出现此参数
    InstanceSnapshotId string
}
 
func (manager *SGusetManager)ValidateCreateData(...., input api.ServerCreateInput) (..., error) {
    var err error
    input.InstanceSnapshotId, err = InstanceSnapshotManager.FetchByIdOrName(userCred, input.InstanceSnapshot)
    if err != nil {
        return nil, err
    }
}
```

## 参考
- https://github.com/Unknwon/go-code-convention/tree/master/zh-CN
- https://github.com/golang/go/wiki/CodeReviewComments
- Godoc: documenting Go code，https://blog.golang.org/godoc-documenting-go-code
