---
title: "climc 认证"
weight: 2
description: >
    介绍Climc命令行工具认证配置。
---

### 认证配置

climc 请求云平台后端服务的流程如下:

1. 通过配置信息，使用用户名密码从 keystone 获取 token
2. token 中包含了后端服务的 endpoint 地址
3. climc 将对应资源的 CURD 请求发往所属的后端服务

所以在操作资源前，我们可以通过环境变量告诉 climc 想要操作的云平台和认证信息。

目前climc支持两种认证方式：

- 通过用户名／密码认证
- 通过Access Key／Secret认证（从2.11开始支持） 

#### 控制节点认证配置

在控制节点上可直接通过以下命令认证配置。

```bash
# 获取环境变量
$ ocadm  cluster rcadmin
export OS_AUTH_URL=https://192.168.0.246:5000/v3
export OS_USERNAME=sysadmin
export OS_PASSWORD=3hV3***84srk
export OS_PROJECT_NAME=system
export YUNION_INSECURE=true
export OS_REGION_NAME=region0
export OS_ENDPOINT_TYPE=publicURL

# 认证环境变量
$ source <(ocadm cluster rcadmin)
```
注意: 如果执行 climc 时出现 *Error: Missing OS_AUTH_URL* 的错误提示时，请重新执行 `source <(ocadm cluster rcadmin)` 命令。

#### 非控制节点认证配置

在非控制节点做认证配置上首先需要在对应的控制节点上执行`ocadm cluster rcadmin`；
将输出的认证信息保存到本地的文件中，通过source命令认证配置。

以下为用户名／密码认证的配置文件模板，通过OS_USERNAME, OS_DOMAIN_NAME, OS_PASSWORD, OS_PROJECT_NAME, OS_PROJECT_DOMAIN等字段指定用户的信息和项目的信息。

```bash
# 在控制节点上获取认证所需要的配置信息。
$ ocadm cluster rcadmin
export OS_AUTH_URL=https://192.168.0.246:5000/v3
export OS_USERNAME=sysadmin
export OS_PASSWORD=3hV3***84srk
export OS_PROJECT_NAME=system
export YUNION_INSECURE=true
export OS_REGION_NAME=region0
export OS_ENDPOINT_TYPE=publicURL

# 将上述认证信息保存到文件中，方便 source 使用
$ cat <<EOF > ~/test_rc_admin
# keystone 认证地址
export OS_AUTH_URL=https://192.168.0.246:5000/v3
# 用户名
export OS_USERNAME=sysadmin
# 用户密码
export OS_PASSWORD=3hV3***84srk
# 用户所属项目名称
export OS_PROJECT_NAME=system
# 允许 insecure https 连接
export YUNION_INSECURE=true
# 对应的 region
export OS_REGION_NAME=region0
# endpoint 类型为 public
export OS_ENDPOINT_TYPE=publicURL
EOF
```

以下为Access Key/Secret认证的配置文件模板，通过OS_ACCESS_KEY, OS_SECRET_KEY等两个字段指定用户的Access Key/secret。

```bash
# 在控制节点上获取用户在一个项目中的Access Key/Secret

# 生成 Secret Key
$ climc credential-create-aksk
+--------+----------------------------------------------+
| Field  |                    Value                     |
+--------+----------------------------------------------+
| expire | 0                                            |
| secret | VGFxZkE3QTd2MmhCbmZkVkJDcFZFaGJYdUQ2c05mUXM= |
+--------+----------------------------------------------+

# ID为 Access Key
$ climc credential-list
+-----------------------+------------+------------+-----------------------+---------+---------+-----------+---------+-----------------------+-------------+--------------+-----------------------+------+-----------------------+----------------------+----------+----------------------+
|         blob          | can_delete | can_update |      created_at       | deleted | domain  | domain_id | enabled |          id           | is_emulated |     name     |      project_id       | type |    update_version     |      updated_at      |   user   |       user_id        |
+-----------------------+------------+------------+-----------------------+---------+---------+-----------+---------+-----------------------+-------------+--------------+-----------------------+------+-----------------------+----------------------+----------+----------------------+
| {"expire":0,"secret": | true       | true       | 2020-06-15T11:43:32.0 | false   | Default | default   | true    | 0d184a3c9c484e4c892f4 | false       | --1592221412 | d53ea650bfe144da8ee8f | aksk | 0                     | 2020-06-15T11:43:32. | sysadmin | a063d8e2cd584cc48194 |
| "VGFxZkE3QTd2MmhCbmZk |            |            | 00000Z                |         |         |           |         | 855935e37e7           |             |              | 3fba417b904           |      |                       | 000000Z              |          | 5e7169280435         |
| VkJDcFZFaGJYdUQ2c05mU |            |            |                       |         |         |           |         |                       |             |              |                       |      |                       |                      |          |                      |
| XM="}                 |            |            |                       |         |         |           |         |                       |             |              |                       |      |                       |                      |          |                      |
+-----------------------+------------+------------+-----------------------+---------+---------+-----------+---------+-----------------------+-------------+--------------+-----------------------+------+-----------------------+----------------------+----------+----------------------+
***  Total: 1 Pages: 1 Limit: 2048 Offset: 0 Page: 1  ***

# 将认证信息保存到文件中，方便 source 使用
$ cat <<EOF > ~/test_rc_aksk
# Access Key
export OS_ACCESS_KEY=0d184a3c9c484e4c892f4855935e37e7  
# Secret, 注意后面有个'=', 不要少复制
export OS_SECRET_KEY=VG***5mUXM=
# 允许 insecure https 连接
export YUNION_INSECURE=true
# keystone 认证地址
export OS_AUTH_URL=https://192.168.0.246:5000/v3
# 对应的 region
export OS_REGION_NAME=region0
EOF
```

模板配置完成后，通过以下名称认证环境变量。

```bash
# source 认证环境变量
$ source ~/test_rc_admin
# 或者想要使用 Access Key/Secret 登陆
$ source ~/test_rc_aksk

# 执行climc。例如，查看虚拟机列表
$ climc server-list
```

注意: 如果执行 climc 时出现 *Error: Missing OS_AUTH_URL* 的错误提示时，请 source 或设置认证云平台的环境变量。

可以通过查看 climc 的版本号来获取构建的信息。

```bash
$ climc --version
Yunion API client version:
 {
  "major": "0",
  "minor": "0",
  "gitVersion": "v3.1.9-20200609.1",
  "gitBranch": "tags/v3.1.8^0",
  "gitCommit": "5591bbec4",
  "gitTreeState": "clean",
  "buildDate": "2020-06-09T12:00:48Z",
  "goVersion": "go1.13.9",
  "compiler": "gc",
  "platform": "linux/amd64"
}
```
