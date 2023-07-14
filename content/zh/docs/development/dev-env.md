---
title: "搭建开发环境"
weight: 1
edition: ce
description: >
  介绍如何搭建开发环境，编译和部署相关组件
---

{{% alert title="说明" %}}

- 服务是以容器的方式运行在 Kubernetes(K8S) 集群里面的，所以开发调试需要部署一个 Kubernetes 集群
- 后端服务都是用 Golang 编写，所以需要在开发环境安装 Golang
- 为了把开发的服务发布到 Kubernetes 集群，需要在本地把相关服务构建成 docker 镜像
- 开发环境最好都是在 Linux 上进行，安装使用 docker 和编译源码都很方便

{{% /alert %}}

接下来介绍如何搭建开发环境。

## 部署 {{% oem_name %}} 服务

在开始开发之前，请先参考 [All in One 融合云安装](../../quickstart/allinone-converge) 部署 {{<oem_name>}} 服务。我们的服务全部使用容器的方式运行在 Kubernetes 集群里面，所以需要先搭建好我们的服务，把这个环境作为自己的开发环境。

这里建议使用一个单独的 CentOS 7 虚拟机，配置(至少 4C8G + 100G 系统盘)，安装部署我们的服务。

## 安装 Go

Golang 版本要求 1.15 以上

安装 Golang 环境请参考： [Install Golang](https://golang.org/doc/install)

## 安装配置 Docker

因为要把服务打包成容器镜像，所以需要先安装 docker，这里的 docker 版本需要是 docker-ce 19.03 以上的版本。

下面是不同操作系统和 Linux 发行版的安装方式，这里还是建议开发环境是 Linux 。

### 安装 Docker

{{< tabs name="docker_install" >}}

{{% tab name="CentOS 7" %}}

```bash
# 1. 安装必要的一些系统工具
sudo yum install -y yum-utils
# 2. 添加软件源信息
sudo yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
# 3. 更新并安装 Docker CE
sudo yum -y install docker-ce
```

{{% /tab %}}

{{% tab name="MAC" %}}
```bash
# 1. 安装brew  参考[brew官网](https://brew.sh/index_zh-cn)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# 2. 安装 Docker CE
brew install docker
# 3. 查看版本
docker --version
```

{{% /tab %}}

{{< /tabs >}}

### 配置 Docker

后续的代码编译和打包使用了 [docker buildx](https://github.com/docker/buildx/) 的功能，需要做在让 docker daemon 开启 experimental 特性，用于编译不同架构的镜像，可参考 docker 官方的 [Building multi-platform images](https://docs.docker.com/build/building/multi-platform/) 文档。

```bash
# 在 docker daemon 的配置里面打开 experimental 特性
$ cat /etc/docker/daemon.json
{
  "experimental": true
}

# 重启 docker 服务
$ systemctl restart docker

# 打开 binfmt_misc 特性，用于 qemu 模拟编译其他架构镜像
# 详细说明参考：https://docs.docker.com/build/building/multi-platform/#building-multi-platform-images
$ docker run --privileged --rm tonistiigi/binfmt --install all

# 创建 buildx context
$ docker buildx create --use --name build --node build --driver-opt network=host
```

## 编译 cloudpods 组件

### Fork 仓库

访问 https://github.com/yunionio/cloudpods ，将仓库 fork 到自己的 github 用户下。

### Clone 源码

git clone 前确保 GOPATH 等环境变量已经设置好，clone 你自己 fork 的仓库

```sh
$ git clone https://github.com/<your_name>/cloudpods $GOPATH/src/yunion.io/x/cloudpods
$ cd $GOPATH/src/yunion.io/x/cloudpods
$ git remote add upstream https://github.com/yunionio/cloudpods
```

### 二进制编译

编译是直接调用 go 编译器在本地编译出二进制，对应的 Makefile 规则为 `make cmd/%` ，`%` 对应的是 `cmd` 目录里面的组件名称。

```sh
# cmd 目录下面存放着所有的组件:
$ ls cmd
...
ansibleserver    climc      glance      keystone  qcloudcli     ucloudcli
awscli           cloudir    host        lbagent   region        webconsole

# 可以编译cmd下指定的组件，比如：编译 climc 和 region 组件
$ make cmd/climc cmd/region

# 编译好的二进制会直接在 _output/bin 目录下面，查看编译好的二进制文件
$ ls _output/bin
climc region

# 编译所有组件
$ make
```

### Docker 镜像编译上传

通常我们的开发流程是写完代码，把相应服务打包生成 docker 镜像，然后发布到自己搭建的 Kubernetes 集群里面测试。
下面说明如何生成 docker 镜像。

生成好的 docker 镜像需要上传的镜像仓库，这里以 [Aliyun 的容器镜像服务](https://cn.aliyun.com/product/acr) 为例，比如我在 aliyun 创建了一个公开的命令空间，仓库地址为: `registry.cn-beijing.aliyuncs.com/zexi` 。

```bash
# 在本地登录镜像仓库，这里以你自己的镜像仓库为准
# 需要先用自己的 aliyun 帐号登录下，后面容器镜像的上传就不需要密码了
$ docker login registry.cn-beijing.aliyuncs.com/zexi
......
Login Succeeded
```

准备好镜像仓库后，就可以开始打包上传镜像了，这些步骤是通过 Makefile 的 image 规则来执行的。

这里有以下环境变量用来控制制作镜像的内容：

- REGISTRY: 对应镜像上传的仓库
- VERSION: 用于生成镜像的 tag
- ARCH: 对应 docker 镜像的 arch，可设置成 'arm64' 或者 'all'
    - arm64: 编译打包制作 arm64 的 docker 镜像
    - all: 编译打包制作 amd64 和 arm64 的镜像
- DEBUG: 如果设置为 true 会显示打包步骤

根据 REGISTRY 和 VERSION 这两个环境变量，会生成各个组件的镜像地址，格式是:
`$(REGISTRY)/$(component):$VERSION`

```bash
# 将 region 服务编译并制作成 docker 镜像
# 然后上传到 registry.cn-beijing.aliyuncs.com/zexi/region:dev
$ VERSION=dev REGISTRY=registry.cn-beijing.aliyuncs.com/zexi make image region

# 编译多个组件，并上传，以下命令会上传以下的组件
# - registry.cn-beijing.aliyuncs.com/zexi/ansibleserver:dev
# - registry.cn-beijing.aliyuncs.com/zexi/apigateway:dev
# - registry.cn-beijing.aliyuncs.com/zexi/region:dev
$ VERSION=dev REGISTRY=registry.cn-beijing.aliyuncs.com/zexi make image \
     ansibleserver apigateway region

# 编译 arm64 的镜像，如果指定了 ARCH=arm64 ，则会在对应镜像的末尾加上 '-arm64' 的后缀
# - registry.cn-beijing.aliyuncs.com/yunionio/scheduler:dev-arm64
$ VERSION=dev REGISTRY=registry.cn-beijing.aliyuncs.com/zexi ARCH=arm64 make image scheduler

# 编译 amd64 + arm64 的镜像，指定 ARCH=all，这里不会添加后缀，会在镜像名里面包含两个架构的版本
# - registry.cn-beijing.aliyuncs.com/yunionio/cloudid:dev
$ VERSION=dev REGISTRY=registry.cn-beijing.aliyuncs.com/zexi ARCH=all make image cloudid

# 同时编译多个多架构的组件，并上传
$ VERSION=dev ARCH=all REGISTRY=registry.cn-beijing.aliyuncs.com/zexi make image \
     ansibleserver apigateway baremetal-agent climc cloudevent \
     cloudnet devtool esxi-agent glance host host-deployer keystone \
     logger notify region s3gateway scheduler webconsole yunionconf \
     vpcagent monitor region-dns cloudid
```

## 开发调试

开发调试的通常步骤是，写好代码后，使用之前说的 [make image](#docker-镜像编译上传) 规则打包上传对应服务的 docker 镜像，然后将镜像发布到自己的 Kubernetes 集群进行测试。

### 将镜像发布到 Kubernetes 集群

后端的服务都运行在 Kubernetes 的 onecloud namespace 里面，可以通过以下命令查看对应的 Kubernetes 资源。我们的服务使用以下的 Kubernetes 资源进行服务的管理。

- deployment: 管理大部分的服务，这种服务会在 Kubernetes 的任意一个 master 节点启动，比如: region, apigateway 服务等
- daemonset: 管理需要在每个 Kubernetes 节点都启动的服务，比如: host 服务(私有云计算节点服务)


{{% alert title="说明" %}}
另外需要简单了解下 Kubernetes pod 这种资源，pod 是实际运行容器的集合，是 Kubernetes 里面运行容器化服务的最小单元，一个 pod 里面可以运行多个容器，每个容器都有自己对应的镜像。

其它 Kubernetes 资源介绍可参考官方的 [工作负载介绍](https://kubernetes.io/zh/docs/concepts/workloads/)。
{{% /alert %}}

下面是使用 kubectl(Kubernetes 命令行工具) 查看各个服务对应资源的命令：

```bash
# 查看 onecloud 命令空间下面的 deployment
$ kubectl -n onecloud get deployment

# 查看 onecloud 命令空间下面的 daemonset
$ kubectl -n onecloud get daemonset

# 查看 onecloud 命名空间下面的 pods
$ kubectl -n onecloud get pod 
```

对 Kubernetes 资源有了大概了解后，接下来的步骤就是把刚才打包的服务镜像发布到集群里面对应的服务，这里以 region 这个服务为例。

```bash
# 先在本地编译打包 region 镜像
# 会在 aliyun 生成镜像: registry.cn-beijing.aliyuncs.com/zexi/region:dev-test
$ VERSION=dev-test REGISTRY=registry.cn-beijing.aliyuncs.com/zexi make image region

# 找到 region 服务对应的 kubernetes 资源名称
$ kubectl get deployment -n onecloud | grep region
default-region                      1/1     1            1           90d

# 更新 default-region deployment 资源里面 image 属性
# 然后对应的 default-region 的 pod 就会自动拉取镜像重启
$ kubectl -n onecloud edit deployment default-region
```

使用 `kubectl -n onecloud edit deployment default-region` 命令后，进入编辑资源 YAML 属性的步骤，只需要将里面的 `image` 属性修改成 aliyun 对应镜像地址，截图如下：

![](../images/kubectl-edit-image.png)

修改完后保存退出，就会拉取刚才指定的镜像创建新的 region pod，删除旧的。可以再次查看 region pod 的当前状态。

![](../images/kubectl-get-region-pod.png)

### 查看服务输出日志

可以使用 `kubectl log` 命令查看对应 pod 的输出日志，这里以刚才发布的 region pod 为例。

```bash
# 先找到 region 服务对应的 pod
$ kubectl get pods -n onecloud | grep region
default-region-6bd8c54d68-sq4gq                     1/1     Running            0          101m

# 查看日志
$ kubectl logs -n onecloud default-region-6bd8c54d68-sq4gq

# 把日志重定向到文件 /tmp/region.log
$ kubectl logs -n onecloud default-region-6bd8c54d68-sq4gq > /tmp/region.log

# 流式查看日志，类似于 'tail -f'
$ kubectl logs -n onecloud default-region-6bd8c54d68-sq4gq -f

# 查看 5 分钟前的日志
$ kubectl logs -n onecloud default-region-6bd8c54d68-sq4gq -f --since 5m
```

### 安装配置 climc

climc 是访问后端的命令行工具，可以通过该工具向后端各个服务发送API请求，日常开发中会使用改命令行工具进行功能验证和调试，安装和使用方法参考下面的连接。

climc 的本地安装参考: [源码编译安装](../../ops/climc/usage/#源码编译安装)

climc 的本地配置参考: [非控制节点认证配置](../../ops/climc/usage/#非控制节点认证配置)

climc 的使用简介参考: [climc 使用](../../ops/climc/usage/#使用)


## FAQ

### 1. 开发环境是 windows 或者 macOS，怎么开发？

因为我们的服务最后会运行在基于 CentOS 7 搭建的 K8S 集群里面，所以日常的开发和打包中一般都是在 CentOS 7 里面做的。

如果开发环境是 windows ，可以在 windows 里面写代码，然后创建一个 CentOS 7 的虚拟机，在虚拟机里面把开发环境搭建好，写完代码利用 `rsync` 等同步工具，把修改的代码增量拷贝到虚拟机中，然后进行打包发布等流程。

对于 Mac 上的 macOS 也是类似的，可以使用和 windows 开发一样的流程。但 macOS 里开发和 Linux 里面开发差异没有很大，在 macOS 里面安装好对应的命令行工具和 docker 后，就可以直接使用 `make image` 相关的规则打包生成 docker 镜像了。

### 2. 本地调试启动 region 服务，报以下错误

![](../images/region_error.png)

使用`climc service-config-edit region2`编辑 region 服务的配置，修改参数：
>     fetch_etcd_service_info_and_use_etcd_lock: false 
>     enable_host_health_check: false


### 3. 本地直接运行 `make cmd/host` 会出现 ceph 依赖的报错

host 组件是私有云里面管理虚拟机的一个关键组件，依赖了 cephfs, rbd 和 rados 相关的库，如果是本地直接编译，则需要安装对应的依赖，操作如下：

{{< tabs name="host_dep_install" >}}

{{% tab name="CentOS 7" %}}
On rpm based systems (dnf, yum, etc):
```bash
sudo rpm --import https://download.ceph.com/keys/release.asc
sudo yum install -y https://download.ceph.com/rpm-luminous/el7/noarch/ceph-release-1-1.el7.noarch.rpm
sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo yum install -y libcephfs-devel librbd-devel librados-devel
```
{{% /tab %}}

{{% tab name="Ubuntu 20.04" %}}
On debian systems (apt):
```sh
wget -q -O- 'https://download.ceph.com/keys/release.asc' | sudo apt-key add -
echo deb https://download.ceph.com/debian-luminous/ $(lsb_release -sc) main | sudo tee /etc/apt/sources.list.d/ceph.list
apt-get update && apt-get install -y libcephfs-dev librbd-dev librados-dev
```
{{% /tab %}}

{{< /tabs >}}

### 4. 如何更新cloudpods后端代码仓库的vendor目录的代码？

cloupods依赖的第三方代码静态维护在vendor目录中。更新了cloudmux等依赖仓库的代码后，进入cloudpods仓库，执行如下命令更新vendor的代码：

```bash
make mod
```

### 5. 如何解决在cherrypick时出现的vendor代码的冲突？

首先解决解决go.mod和go.sum的代码冲突，然后执行 make mod 刷新vendor里的代码。最后提交go.mod，go.sum以及vendor的所有变更。