---
title: "Private Cloud Installation"
linkTitle: "Private Cloud Installation"
edition: ce
weight: 1
description: >
  Use ocboot deployment tool to deploy the private cloud version in an All-in-One way.
---

## Prerequisites

{{% alert title="Note" color="warning" %}}
The content of this chapter is to quickly set up the Cloudpods service through deployment tool. If you want to deploy a highly available cluster in a production environment, please refer to: [High Availability Installation](../../setup/ha-ce/).
{{% /alert %}}

## Environment Preparation

### Machine Configuration Requirements

- Operating system: Different CPUs support different distributions. Currently, the supported distribution statuses are as follows:
    - [CentOS 7.6~7.9 Minimal](http://isoredirect.centos.org/centos/7/isos): Support x86_64 and arm64
    - [Debian 10/11](https://www.debian.org/distrib/): Support x86_64 and arm64
    - [Ubuntu 22.04](https://releases.ubuntu.com/jammy/): Only support x86_64
    - [Galaxy Kylin V10 SP2/SP3](https://www.kylinos.cn/scheme/server/1.html): Support x86_64 and arm64
    - [Transtonic UOS kongzi](https://www.chinauos.com/): Support x86_64 and arm64
- The operating system needs to be a clean version. Because the deployment tool will rebuild the specified version of the Kubernetes cluster from scratch, ensure that the system does not have container management tools such as Kubernetes and Docker installed, otherwise it will cause conflicts and installation exceptions.
- Minimum configuration requirements: CPU 4 cores, memory 8 GiB, storage 100 GiB
- The storage paths used by virtual machines and services are all under **/opt**, so it is recommended to set a mount point separately for the **/opt** directory in an ideal environment.
    - For example, create a separate partition /dev/sdb1 and format it as ext4, and then mount it to the /opt directory through /etc/fstab.

## Install Ansible and Git

First, you need to install Ansible and Git. The minimum version requirement for Ansible is 2.9.27, and version 2.11.12 is more thoroughly tested.

{{< tabs name="ocboot_install" >}}
{{% tab name="CentOS 7" %}}

```bash
# Install Ansible and Git locally
$ yum install -y epel-release git python3-pip
$ python3 -m pip install --upgrade pip setuptools wheel
$ python3 -m pip install --upgrade ansible
```
{{% /tab %}}

{{% tab name="Kylin V10" %}}
```bash
# Install Ansible and Git locally
$ yum install -y git python3-pip
$ python3 -m pip install --upgrade pip setuptools wheel
$ python3 -m pip install --upgrade ansible
```
{{% /tab %}}

{{% tab name="Debian 10/11" %}}

If there is an error message related to `locale`, please execute the following command first:

```bash
if ! grep -q '^en_US.UTF-8' /etc/locale.gen; then
    echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen
    locale-gen
    echo 'LANG="en_US.UTF-8"' >> /etc/default/locale
    source /etc/default/locale
fi
```

```bash
# Install Ansible and Git locally
$ apt install -y git python3-pip
$ python3 -m pip install --upgrade pip setuptools wheel
$ python3 -m pip install --upgrade ansible
```Note: In the `debian 11` environment, if the boot option `systemd.unified_cgroup_hierarchy=0` cannot be found in `/proc/cmdline`, ocboot automatically configures the relevant `GRUB` options, rebuilds the boot options, and restarts the operating system to enable `k8s` to start normally.

{{% /tab %}}

{{% tab name="Other Operating Systems" %}}
```bash
# Install ansible locally
$ python3 -m pip install --upgrade pip setuptools wheel
$ python3 -m pip install --upgrade ansible
```
{{% /tab %}}

{{< /tabs >}}

## Install Cloudpods

The deployment tool is located at [https://github.com/yunionio/ocboot](https://github.com/yunionio/ocboot). You need to clone this tool using `git clone` and then run the `run.py` script to deploy the service. The steps are as follows:

```bash
# Download the ocboot tool to the local machine
$ git clone -b {{<release_branch>}} https://github.com/yunionio/ocboot && cd ./ocboot
```

Execute run.py to deploy the service. The **<host_ip>** is the IP address of the deployment node and is an optional parameter. If not specified, it will choose the default network card for service deployment. If your node has multiple network cards, you can choose the corresponding network card to listen to the service by specifying the **<host_ip>**.

{{< tabs name="ocboot_install_region" >}}
{{% tab name="Mainland China" %}}

```bash
# Directly deploy and pull the container image from registry.cn-beijing.aliyuncs.com
$ ./run.py virt <host_ip> 

# If there is a problem with slow pip installation package download, you can use the -m parameter to specify the pip source
# For example, use https://mirrors.aliyun.com/pypi/simple/ source below
$ ./run.py -m https://mirrors.aliyun.com/pypi/simple/ virt <host_ip> 
```

{{% /tab %}}

{{% tab name="Other Regions" %}}

For some network environments, registry.cn-beijing.aliyuncs.com may be slow or unreachable. Starting from version `v3.9.5`, you can specify the image source: [docker.io](http://docker.io) for installation. The command is as follows:

```bash
IMAGE_REPOSITORY=docker.io/yunion ./run.py virt <host_ip>
```

{{% /tab %}}

{{< /tabs >}}

## Deployment Completed

```bash
....
# After the deployment is completed, the following output indicates that it has run successfully
# Open https://10.168.26.216 in the browser, where the IP address is the <host_ip> set earlier. 
# Use admin/admin@123 for the user password to log in to access the front-end interface
Initialized successfully!
Web page: https://10.168.26.216
User: admin
Password: admin@123
```

Then use the browser to access https://10.168.26.216, enter `admin` for the username and `admin@123` for the password to enter the Cloudpods interface.

![Login page](../images/index.png)

## Start Using Cloudpods

### Create the First Virtual Machine

Create the first virtual machine through the following three steps:

#### 1. Import Image

Browse the [CentOS 7 Cloud Host Image](https://cloud.centos.org/centos/7/images/), select a GenericCloud image, and copy the image URL.

In the `Host` menu, select `System Image`, choose `Upload`. Enter the image name, select `Enter Image URL`, paste the CentOS 7 image URL above, and select `OK`.

You can access https://docs.openstack.org/image-guide/obtain-images.html for more virtual machine images.

#### 2. Create Network (VPC and IP Subnet)

- Create VPC: In the `Network` menu, select the `VPC` submenu, and select `Create`. Enter a name, for example `vpc0`, select the target network segment, for example `192.168.0.0/16`. Click `Create`.

- Create IP subnet: After creating the VPC, select the `IP subnet` submenu, and select `Create`. Enter a name, for example `vnet0`, select the VPC (`vpc0`) that was just created, select the availability zone, and enter the `subnet network segment`, for example `192.168.100.0/24`. Click `Create`.

[Typical Network Configuration](../../function_principle/onpremise/network/examples) provides several common host network configurations for reference.

#### 3. Create Virtual Machine

In the `Host` menu, select `Virtual Machine`, and select `Create`. Enter the host name, select the image and IP subnet, and create the virtual machine.

## FAQ

### 1. After the All-in-One deployment is completed, there are no hosts in the host list?

As shown in the figure below, if there are no hosts in the host list after the environment deployment is completed, you may troubleshoot as follows:

  ![](../images/nohost.png)


1. Troubleshooting the host service on the control node, please refer to: [Host Service Troubleshooting Skills](../../function_principle/onpremise/host/troubleshooting/)


    1. If the error message in the log contains "register failed: try create network: find_matched == false", it means that the IP subnet containing the host was not successfully created, resulting in the host registration failure. Please create an IP subnet containing the host network segment.

    ```
    # Create an IP subnet containing the host network segment
    $ climc network-create bcast0 adm0 <start_ip> <end_ip> mask
    ```

    ![](../images/iperror.png)

    2. If the error message in the log contains "name starts with letter, and contains letter, number and - only", it means that the hostname of the host does not meet the specifications and should be changed to an hostname starting with a letter.

    ![](../images/hostnameerror.png)

### 2. Can't find the virtual machine interface in All-in-One?

The node deployed by All-in-One will deploy Cloudpods host computing services as a host, which has the ability to create and manage private cloud virtual machines. The lack of virtual machine interface may be due to the host not enabled in the Cloudpods environment.

Please go to the `Management Console` interface, click `Host/Basic Resources/Host` to view the host list, enable the corresponding host, and refresh the interface to display the virtual machine interface.

{{% alert title="Note" color="warning" %}}
If you want to use Cloudpods private cloud virtual machines, and the host is the CentOS 7 distribution. The host needs to use the kernel compiled by Cloudpods. You can use the following command to check whether the host is using the Cloudpods kernel (contains yn keyword).

```bash
# Check whether the yn kernel is in use
$ uname -a | grep yn
Linux office-controller 3.10.0-1160.6.1.el7.yn20201125.x86_64
# If the kernel is not a version with a yn keyword, it may be the first time using ocboot installation, and you can enter the yn kernel by restarting
$ reboot
```
{{% /alert %}}

![Host](../images/host.png)

### 3. Why can't the service be started after changing the hostname of the node?

Cloudpods uses Kubernetes in the underlying system to manage nodes, and the Kubernetes node name depends on the hostname. Changing the hostname will cause the node to fail to register to the Kubernetes cluster, so do not modify the hostname. If you modify the hostname, please change it back to the original name, and the service will automatically resume.

### 4. How to reinstall?

1. Execute `kubeadm reset -f` to remove the Kubernetes cluster.

2. Re-run the run.py script under ocboot.

### 5. Any other questions?

Other questions are welcome to be submitted on the Cloudpods github issues page: [https://github.com/yunionio/cloudpods/issues](https://github.com/yunionio/cloudpods/issues), and we will reply as soon as possible.
