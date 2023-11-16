---
title: "Ocboot Installation"
linkTitle: "Ocboot Installation"
edition: ce
weight: 1
description: >
  Deploy Cloudpods CMP multi-cloud management version quickly in an All in One way using the ocboot deployment tool
---

## Prerequisites

{{% alert title="Note" color="warning" %}}
This chapter is about setting up the Cloudpods service quickly through the deployment tool. If you want to deploy a highly available cluster in a production environment, please refer to [High Availability Installation] (../../../setup/ha-ce/) .
{{% /alert %}}

## Environment Preparation

### Machine Configuration Requirements

- Operating system: Different distribution versions are supported according to different CPU architectures. Currently, the supported distribution situations are as follows:
    - [CentOS 7.6~7.9 Minimal](http://isoredirect.centos.org/centos/7/isos): x86_64 and arm64 are supported
    - [Debian 10/11](https://www.debian.org/distrib/): x86_64 and arm64 are supported
    - [Ubuntu 22.04](https://releases.ubuntu.com/jammy/): Only x86_64 is supported
    - [Galaxy Kylin V10 SP2/SP3](https://www.kylinos.cn/scheme/server/1.html): x86_64 and arm64 are supported
    - [Trusted UOS Kongzi](https://www.chinauos.com/): x86_64 and arm64 are supported
- The operating system needs to be a clean version. Because the deployment tool will build a kubernetes cluster of the specified version from the beginning, ensure that kubernetes, docker, and other container management tools are not installed on the system, otherwise there will be conflicts and installation abnormalities.
- Minimum configuration requirements: CPU 4 cores, memory 8GiB, storage 100GiB
- The storage path used by virtual machines and services is all under **/opt** directory, so it is recommended to set a separate mount point for the **/opt** directory in an ideal environment
    - For example, partition /dev/sdb1 separately to make ext4 and then mount it to the /opt directory through /etc/fstab.

## Install ansible and git

First, you need to install ansible and git, and the minimum version of ansible is 2.9.27, among which 2.11.12 is tested more.

{{< tabs name="ocboot_install" >}}
{{% tab name="CentOS 7" %}}

```bash
# Install ansible and git locally
$ yum install -y epel-release git python3-pip
$ python3 -m pip install --upgrade pip setuptools wheel
$ python3 -m pip install --upgrade ansible
```
{{% /tab %}}

{{% tab name="Kylin V10" %}}
```bash
# Install ansible and git locally
$ yum install -y git python3-pip
$ python3 -m pip install --upgrade pip setuptools wheel
$ python3 -m pip install --upgrade ansible
```
{{% /tab %}}

{{% tab name="Debian 10/11" %}}

If prompted with `locale` related errors, please execute the following command first:

```bash
if ! grep -q '^en_US.UTF-8' /etc/locale.gen; then
    echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen
    locale-gen
    echo 'LANG="en_US.UTF-8"' >> /etc/default/locale
    source /etc/default/locale
fi
```

```bash
# Install ansible and git locally
$ apt install -y git python3-pip
$ python3 -m pip install --upgrade pip setuptools wheel
$ python3 -m pip install --upgrade ansible
```Note: In a `debian 11` environment, if the boot option `systemd.unified_cgroup_hierarchy=0` is not found in `/proc/cmdline`, ocboot will automatically configure the corresponding `GRUB` option, rebuild the boot parameters, and restart the operating system so that `k8s` can start up normally.

{{% /tab %}}

{{% tab name="Other operating systems" %}}
```bash
# Install ansible locally
$ python3 -m pip install --upgrade pip setuptools wheel
$ python3 -m pip install --upgrade ansible
```
{{% /tab %}}

{{< /tabs >}}

## Install Cloudpods

The deployment tool is located at [https://github.com/yunionio/ocboot](https://github.com/yunionio/ocboot). Clone this tool with `git clone` and run the `run.py` script to deploy the service. The installation steps are as follows:

```bash
# Download the ocboot tool to the local machine
$ git clone -b {{<release_branch>}} https://github.com/yunionio/ocboot && cd ./ocboot
```

Execute `run.py` to deploy the service. **<host_ip>** is the IP address of the deployment node, and is optional. If not specified, the default route is used to deploy the service. If the node has multiple network cards, **<host_ip>** can be specified to choose the corresponding network card to listen for services.

{{< tabs name="ocboot_install_region" >}}
{{% tab name="Mainland China" %}}

```bash
# Direct deployment will pull the container image from registry.cn-beijing.aliyuncs.com
$ ./run.py cmp <host_ip>

# If you encounter slow package downloads during pip installation, you can use the -m parameter to specify the pip source
# For example, use: https://mirrors.aliyun.com/pypi/simple/ as the source below
$ ./run.py -m https://mirrors.aliyun.com/pypi/simple/ cmp <host_ip> 
```

{{% /tab %}}

{{% tab name="Other Regions" %}}

For some network environments, access to registry.cn-beijing.aliyuncs.com is slow or unavailable. Starting from version `v3.9.5`, you can specify the image source [docker.io](http://docker.io) to install. The command is as follows:

```bash
IMAGE_REPOSITORY=docker.io/yunion ./run.py cmp <host_ip>
```

This method automatically generates a configuration file named `config-allinone-current.yaml` in the current directory and executes the deployment based on the parameters in the configuration file.

{{% /tab %}}

{{< /tabs >}}

## Deployment Complete

```bash
....
# After deployment, the following output indicates success
# Open https://10.168.26.216 in the browser, where ip is the <host_ip> set previously
# Login to the front-end page with admin/admin@123
Initialized successfully!
Web page: https://10.168.26.216
User: admin
Password: admin@123
```

Then use a browser to access https://10.168.26.216. Enter `admin` for the username and `admin@123` for the password to enter the Cloudpods interface.

![Login page](../../images/index.png)

## Getting Started with Cloudpods

### Import public clouds or other private cloud platform resources

Cloudpods multi-cloud management platform can unify and manage resources from other cloud platforms.

In the `Multi-Cloud Management` menu, select `Cloud Account` and create a new one. Fill in the authentication information of the corresponding cloud platform according to your needs. After configuring the cloud account, the Cloudpods service will sync the corresponding cloud platform resources, which can be viewed in the front-end after synchronization is complete.

![Multi-Cloud Management](../../images/cloudaccount.png)


## FAQ


### 1. How to reinstall?

1. Execute `kubeadm reset -f` to delete the kubernetes cluster
2. Rerun the ocboot script

### 2. Other problems?

Other issues are welcome to be submitted on the Cloudpods Github issues page: [https://github.com/yunionio/cloudpods/issues](https://github.com/yunionio/cloudpods/issues). We will reply as soon as possible.
