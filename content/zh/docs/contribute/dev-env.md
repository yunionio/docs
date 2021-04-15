---
title: "搭建开发环境"
weight: 1
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

## 部署云联壹云服务

在开始开发之前，请先参考 [All in One 安装](../../quickstart/allinone) 或者 [MiniKube 安装](../../quickstart/minikube) 部署云联壹云服务。我们的服务全部使用容器的方式运行在 Kubernetes 集群里面，所以需要先搭建好我们的服务，把这个环境作为自己的开发环境。

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

{{< /tabs >}}

### 配置 Docker

后续的代码编译和打包使用了 [docker buildx](https://github.com/docker/buildx/) 的功能，需要做在让 docker daemon 开启 experimental 特性。

```bash
# 在 docker daemon 的配置里面打开 experimental 特性
$ cat /etc/docker/daemon.json
{
  "experimental": true
}

# 重启 docker 服务
$ systemctl restart docker

# 创建 buildx context
$ docker buildx create --use --name build --node build --driver-opt network=host
```

## 编译 云联壹云 组件

### Fork 仓库

访问 https://github.com/yunionio/onecloud ，将仓库 fork 到自己的 github 用户下。

### Clone 源码

git clone 前确保 GOPATH 等环境变量已经设置好，clone 你自己 fork 的仓库

```sh
$ git clone https://github.com/<your_name>/onecloud $GOPATH/src/yunion.io/x/onecloud
$ cd $GOPATH/src/yunion.io/x/onecloud
$ git remote add upstream https://github.com/yunionio/onecloud
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

climc 的本地安装参考: [源码编译安装](../../howto/climc/#源码编译安装)

climc 的本地配置参考: [非控制节点认证配置](../../howto/climc/#非控制节点认证配置)

climc 的使用简介参考: [climc 使用](../../howto/climc/#使用)


## 快速开发调试

我们的服务都已经容器化运行在 Kubernetes 集群中，使用上面说的 **"制作docker镜像->发布到集群"** 的开发流程有些长，对于快速开发调试并不方便。

通过 [Telepresence](https://www.telepresence.io) 提供远程 Kubernetes 连接信息上下文，可以在本地开发调试。下面介绍使用 Telepresence 进行本地快速开发。

### 安装配置 kubectl

需要在本地安装 [kubectl](https://kubernetes.io/zh/docs/tasks/tools/install-kubectl/)。

需要在本地配置好集群信息，以通过 kubectl 访问；将云联壹云控制节点上的`$KUBECONFIG`文件拷贝到本地`~/.kube/config`;
如果本地已经有此文件，参考 [配置多集群访问](https://kubernetes.io/zh/docs/tasks/access-application-cluster/configure-access-multiple-clusters/) 进行合并。

### 安装 telepresence

这里介绍 CentOS 7 的本地环境安装，其他发行版可参考官方文档：[Installing Telepresence](https://www.telepresence.io/reference/install)。

> 不建议K8S集群的部署和开发在同一个环境，使用Telepresence会有端口冲突。

```bash
# 安装依赖
$ yum install -y python3 sshfs conntrack iptables torsocks sshuttle sudo yum-utils
# 安装 kubectl 用于连接 K8S 集群
$ cat <<EOF >/etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=http://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=0
repo_gpgcheck=0
gpgkey=http://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg http://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF
$ yum install -y kubectl-1.15.8-0
# 需要自行配置kubctl config
# 测试kubctl可以访问之前部署的K8S集群
$ kubctl version
# 源码安装 telepresence 到 /usr/local/bin/telepresence
$ git clone https://github.com/telepresenceio/telepresence
$ cd telepresence
$ sudo env PREFIX=/usr/local ./install.sh
```

### 使用

利用 telepresence 本地连通远端 K8S 的特性，我们就可以做到在本地编译运行 region，keystone 等服务，同时又能访问远端 K8S 其它服务的环境。


**macOS 或 linux 中本地编译运行 region 服务**

```bash
# 切换到 云联壹云 代码目录
$ cd $GOPATH/src/yunion.io/x/onecloud
 
# 编译 region 服务
$ make cmd/region
 
# 使用 telepresence 替换 K8S 里面的 default-region deployment
# 该命令在 K8S 集群中启动一个 deployment 替换掉原来的 default-regoin
# 然后把流量的访问导向本地
# 如果想要使用特定的 shell，比如 zsh，可以在后面加上"--run /bin/zsh"
$ telepresence --swap-deployment default-region --namespace onecloud
```
到这里已经进入到 telepresence 隔离的 namespace 里面了，
$TELEPRESENCE_ROOT 这个目录 是通过 sshfs 挂载的远端 K8S pod 的文件系统。
接下来我们就可以在这个 namespace 里面运行 region 服务了：
```bash
$ sudo chmod 777 /etc
 
# 将 $TELEPRESENCE_ROOT/etc/yunion 链接到本地的 /etc
$ ln -s $TELEPRESENCE_ROOT/etc/yunion /etc
 
# 启动 region 服务
$ ./_output/bin/region --config /etc/yunion/region.conf
```

这个时候如果我们在外部调用 climc 就会发现相关的请求已经被转发到本地开发机启动 region 服务了。

```bash
$ climc network-list
```

调试完成后需要进行清理操作

```bash
# 退出 telepresence
$ exit
# 会看到类似下面的输出
T: Your process exited with return code 127.
T: Exit cleanup in progress
T: Cleaning up Pod

# 删除链接文件
$ rm /etc/yunion
```

**Linux系统中本地编译运行 region 服务**

这种方式相比上一种方式，更加干净；但是相对复杂

```bash
# 切换到 云联壹云 代码目录
$ cd $GOPATH/src/yunion.io/x/onecloud
 
# 编译 region 服务
$ make cmd/region
 
# 使用 telepresence 替换 K8S 里面的 default-region deployment
# 该命令在 K8S 集群中启动一个 deployment 替换掉原来的 default-regoin
# 然后把流量的访问导向本地
# 如果想要使用特定的 shell，比如 zsh，可以在后面加上"--run /bin/zsh"
$ telepresence --swap-deployment default-region --namespace onecloud
```
到这里已经进入到 telepresence 隔离的 namespace 里面了，
$TELEPRESENCE_ROOT 这个目录 是通过 sshfs 挂载的远端 K8S pod 的文件系统。
接下来我们就可以在这个 namespace 里面运行 region 服务了：
```bash
# 设置 max_user_namespaces
$ cat /proc/sys/user/max_user_namespaces
0
# 如果 max_user_namespaces 为 0，需要设置下 user_namespaces
$ echo 640 > /proc/sys/user/max_user_namespaces
 
# 启动一个新的 namespace , 但不共享 mount namespace，这样接下来的 mount bind 操作就不会影响到宿主机
$ unshare --map-root-user --mount
# bind K8S /var/run/secrets
$ mount --bind $TELEPRESENCE_ROOT/var/run /var/run
$ ls /var/run/
secrets
# bind 云联壹云 config
$ mkdir /etc/yunion
$ mount --bind $TELEPRESENCE_ROOT/etc/yunion /etc/yunion
$ ls /etc/yunion/
pki  region.conf
 
# 启动 region 服务
$ ./_output/bin/region --config /etc/yunion/region.conf
# 这个时候如果我们在外部调用 climc
$ climc network-list
# 就会发现相关的请求已经被转发到本地开发机启动 region 服务了
```

更多用法，以及 telepresence 的原理请参考[官方文档](https://www.telepresence.io/discussion/overview)。

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


### 3. 使用 telepresence 时，上次未正常退出，再次使用一直报错

尝试手动清理: 
1. 使用 kubectl 删除 onecloud namespace 下除 default-region-dns-xxxxx 外，所有以 default-region 开头的Pod；
2. 使用`kubectl edit deployment default-region -n onecloud`，将 spec 下的 replicas 从0改为1.

```bash
# 可以编译cmd下制定的组件，比如：编译 region 和 host 组件
$ make cmd/region cmd/host

# 查看编译好的二进制文件
$ ls _output/bin
region host
```

### 4. 本地直接运行 `make cmd/host` 会出现 ceph 依赖的报错

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
