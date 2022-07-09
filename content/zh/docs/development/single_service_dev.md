---
title: "手动部署开发集群"
weight: 4
description: >
  介绍如何手动部署用于开发测试用途的服务集群
---

本文介绍手工部署用于开发测试用途的服务集群的步骤。

## 适用人群

- 想要断点调试
- 虚拟机配置低
- 不想使用docker打包镜像
- 想要在macOS/Linux上直接开发

## 已知问题

- macOS上调试不了host服务
- 配置复杂

## 环境准备

这里以Debain 11环境为例，仅配置nginx, apigateway, keystone, region等服务组成的最小集群，其他服务可以根据需要自行添加。

- Linux 或 macOS
- 4核8G

### 基础软件安装

- nginx
- MariaDB 5.5 或 MySQL 5.7
- git, make, npm, yarn, curl
- go 1.15

### 源码克隆

这里假设克隆源码的目录分别为 **/root/cloudpods** **/root/dashboard**

```sh 
# 克隆后端源代码
$ git clone https://github.com/yunionio/cloudpods.git
# 这里需要将代码切到自己想要的分支，这里设为 release/3.9
$ cd cloudpods && git checkout release/3.9 && cd /root
# 克隆前端源代码
$ git clone https://github.com/yunionio/dashboard.git
# 前端代码分支需要和后端保持一致
$ cd dashboard && git checkout release/3.9 && cd /root
# 创建配置文件放置目录
$ mkdir -p /etc/yunion
```

### 启动nginx及数据库服务

```sh  
$ systemctl enable --now nginx mariadb
```

## 认证服务（keystone）初始化

第一个要起的服务是keystone，因为其他服务都依赖于认证服务

1) 首先配置keystone的数据库

```sh
# 为keystone服务创建数据库及数据库账号
$ mysql -uroot -e 'create database keystone;'
# 这里设置一个密码为cloudpods-keystone的keystone用户，后面配置文件会用到
$ mysql -uroot -e 'grant all privileges on keystone.* to "keystone"@"%" identified by "cloudpods-keystone"; flush privileges;'
```

2) 下面配置keystone服务

```sh
# 编译keysonte
$ cd /root/cloudpods && make cmd/keystone

# 编写keystone服务的配置文件
$ mkdir -p /etc/yunion/keystone
# 这里要注意使用刚创建的数据库及数据库账号密码
$ cat<<EOF >/etc/yunion/keystone/keystone.conf
address = '127.0.0.1'
port = 5000
admin_port = 35357
sql_connection = 'mysql+pymysql://keystone:cloudpods-keystone@localhost:3306/keystone?charset=utf8'
log_level = 'debug'
auto_sync_table = true
EOF

$ 初始化配置
# 这里会先根据配置初始化keystone的数据库表，并设置sysadmin用户密码，这里设置为123@admin 后面会用到
$ /root/cloudpods/_output/bin/keystone --conf /etc/yunion/keystone/keystone.conf --bootstrap-admin-user-password 123@admin --exit-after-db-init
# 启动keystone服务
$ /root/cloudpods/_output/bin/keystone --conf /etc/yunion/keystone/keystone.conf
```

3) 配置keystone服务

## climc 初始化

认证服务完成后，需要用climc进行部分操作

```sh
# 编译climc命令, 并放置到可执行环境目录里面
$ cd /root/cloudpods && make cmd/climc && cp /root/cloudpods/_output/bin/climc /usr/local/bin/

# 编写rc_admin文件
$ cat<<EOF >/etc/yunion/rc_admin
export OS_REGION_NAME=Yunion
export OS_PROJECT_NAME=system
export OS_PASSWORD=123@admin
export OS_AUTH_URL=http://127.0.0.1:35357/v3
export OS_USERNAME=sysadmin
export OS_ENDPOINT_TYPE=publicURL
EOF

# 设置环境变量
$ source /etc/yunion/rc_admin

# 保存sysadmin的policy
$ cat<<EOF >/root/sysadmin
policy:
  '*':
    '*':
      '*': allow
EOF
# 创建sysadmin的权限
$ climc policy-create --enabled --scope system --is-system sysadmin /root/sysadmin

# 将sysadmin权限绑定到admin角色上
$ climc policy-bind-role --project-id system --role-id admin sysadmin

# 将sysadmin以admin的角色加入system项目, 此后sysadmin用户才拥有整个平台的操作权限, 若报ForbiddenError错误，可以重启keystone服务后,再次尝试此操作
$ climc user-join-project --role admin --project system sysadmin

# 创建 Yunion 区域
$ climc region-create Yunion
```    

## 初始化服务及端点

```sh
# 创建 keystone 服务
$ climc service-create --enabled identity keystone

# 创建 keystone 端点
$ climc endpoint-create --enabled keystone Yunion public http://127.0.0.1:35357/v3
$ climc endpoint-create --enabled keystone Yunion admin http://127.0.0.1:35357/v3
$ climc endpoint-create --enabled keystone Yunion internal http://127.0.0.1:5000/v3

```

## 计算服务（region）初始化

region服务是基础服务，也是控制节点。

1) 首先在keystone配置region服务的服务账号，并且注册region服务的服务端点（service endpoint）。

```sh
# 创建 region 服务
$ climc service-create --enabled compute_v2 region2

# 确定 region 服务监听端口，这里假定是8090，后面region服务配置时指定端口得是8090
# 创建 region 端点
$ climc endpoint-create --enabled region2 Yunion internal http://127.0.0.1:8090
$ climc endpoint-create --enabled region2 Yunion public http://127.0.0.1:8090

# 创建 region 服务的服务账号
$ climc user-create --enabled --system-account --no-web-console --password region@admin regionadmin
# 赋予 regionadmin 用户 admin 角色
$ climc user-join-project --role admin --project system regionadmin
```

2) 其次配置region的数据库

```sh
# 为region服务创建数据库及数据库账号
$ mysql -uroot -e 'create database yunioncloud;'
# 这里设置一个密码为cloudpods-yunioncloud的yunioncloud用户
$ mysql -uroot -e 'grant all privileges on yunioncloud.* to "yunioncloud"@"%" identified by "cloudpods-yunioncloud"; flush privileges;'
```

3) 下面配置并启动region服务

```
# 编译 region
$ cd /root/cloudpods/ && make cmd/region

# 编写region服务的配置文件
# 这里要注意使用刚创建的数据库及数据库账号密码, 及region服务认证的用户名密码
$ cat<<EOF >/etc/yunion/region.conf
region = 'Yunion'
address = '127.0.0.1'
port = 8090
auth_uri = 'http://127.0.0.1:35357/v3'
admin_user = 'regionadmin'
admin_password = 'region@admin'
admin_tenant_name = 'system'
sql_connection = 'mysql+pymysql://yunioncloud:cloudpods-yunioncloud@localhost:3306/yunioncloud?charset=utf8'
log_level = 'debug'
auto_sync_table = true
EOF

# 启动 region 服务
$ /root/cloudpods/_output/bin/region --conf /etc/yunion/region.conf
```

4) 测试region服务是否正常

```
# 测试 region 服务接口
$ climc server-list
***  Total: 0  ***
```

其他使用数据库的服务的配置步骤和region类似。


## API网关服务（apigateway）初始化

api网关是web到各个服务的中间层，web请求到达nginx再由nginx分发到api网关服务，最终由api网关去判断请求需要转发到哪个服务

首先为api网关创建服务账号

```sh
# 创建 api网关 服务认证用户
$ climc user-create --enabled --system-account --no-web-console --password apigateway@admin apigateway
# 赋予 apigateway 用户 admin 角色
$ climc user-join-project --role admin --project system apigateway
```
下面配置api网关服务

```sh
# 编译 apigateway
$ cd /root/cloudpods/ && make cmd/apigateway

# 编写apigateway服务的配置文件, 注意，这里监听的端口是3000, 后面配置nginx时需要用到
$ cat<<EOF >/etc/yunion/apigateway.conf
region = 'Yunion'
address = '0.0.0.0'
port = 3000
auth_uri = 'http://127.0.0.1:35357/v3'
admin_user = 'apigateway'
admin_password = 'apigateway@admin'
admin_tenant_name = 'system'
log_level = 'debug'
EOF

# 启动apigateway服务
$ /root/cloudpods/_output/bin/apigateway --conf /etc/yunion/apigateway.conf
```

## 前端服务配置

### 前端编译

```sh
# 安装yarn, 参考 https://yarn.bootcss.com/docs/install
$ apt install yarn
# 编译前端代码
$ cd /root/dashboard && yarn && yarn build
```

### nginx配置

```sh
# 修改nginx默认配置
# 这里不一定是要改/etc/nginx/conf.d/default 文件，有可能是其他配置问题，主要是让以下内容生效
# 编辑 /etc/nginx/conf.d/default 文件，输入以下代码
server {
    listen 80;

    location ~ /.well-known {
        allow all;
    }

    location / {
        # 注意这里要匹配前端编译后代码的位置
        root /root/dashboard/dist;
        index index.html;
        add_header Cache-Control no-cache;
        expires 1s;
        if (!-e $request_filename) {
            rewrite ^/(.*) /index.html last;
            break;
        }
    }

    location /static/ {
        # Some basic cache-control for static files to be sent to the browser # 同上
        root /root/dashboard/dist;
        expires max;
        add_header Pragma public;
        add_header Cache-Control "public, must-revalidate, proxy-revalidate";
    }

    location /api {
        # 这里要匹配到api网关的地址和端口
        proxy_pass http://127.0.0.1:3000;
        proxy_redirect   off;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }

    location /api/v1/imageutils/upload {
        proxy_pass http://127.0.0.1:3000;
        client_max_body_size 0;
        proxy_http_version 1.1;
        proxy_request_buffering off;
        proxy_buffering off;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $remote_addr;
    }
}
    
# 为了防止/root/dashboard/dist目录权限问题，建议将启动用户改为root，或者设置正确的目录权限，可以忽略此步
$ sed -i '/^user.*/c\user root;' /etc/nginx/nginx.conf

# 重新加载nginx配置文件
$ nginx -s reload

# 测试 web 是否加载正确
$ curl http://127.0.0.1 | grep OneCloud

# 测试nginx是否可以将请求转发至api网关服务
$ curl http://127.0.0.1/api/v2/servers | python3 -m json.tool
```

### 前端登录

```sh
# 创建 web 登录用户 admin
$ climc user-create --enabled --password admin@123 admin
# 赋予 admin 用户 admin 角色
$ climc user-join-project --role admin --project system admin
# 此时可以打开虚拟机的地址(http://ip)进行前端登录, 用户名密码分别为admin/admin@123
```

# 后续改进

- 此步骤是直接指定的参数执行各个服务
    - macOS推荐使用launchctl+LaunchControl进行各个服务的启动管理
    - Linux可以编写systemd script管理各个服务
- 此步骤并没有使用ssl，若使用ssl需要变更以下内容
    - 修个各个服务的配置文件，添加ssl的配置
    - 修个各个服务的端点，指定https
    - 修改nginx配置，将转发请求改为https
- 此步骤中服务监听的地址都是127.0.0.1，若想对外暴露各个服务的api，需要改以下内容
    - 修改监听地址为0.0.0.0
    - 修改服务的public端点地址，改为外部可访问地址
- 由于依然有很多服务没有部署，因此前端会有很多服务没找到的报错，甚至前端很多功能都用不了
    - 根据前端的提示, 将缺失的服务部署起来

