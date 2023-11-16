---
title: "Hybrid Cloud Installation"
linkTitle: "Hybrid Cloud Installation"
edition: ce
weight: 3
description: >
  Deploy the Hybrid Cloud version in an All-in-One manner using the ocboot deployment tool.
---

## Prerequisites

{{% alert title="Note" color="warning" %}}
This chapter uses the deployment tool to quickly build the Cloudpods service. If you want to deploy a high-availability cluster in a production environment, see [High Availability Installation](../../setup/ha-ce/) for reference.
{{% /alert %}}

## Environment Preparation

### Machine Configuration Requirements

- Operating System: Different distributions are supported based on CPU architecture. The currently supported distributions and architectures are as follows:
    - [CentOS 7.6~7.9 Minimal](http://isoredirect.centos.org/centos/7/isos): x86_64 and arm64
    - [Debian 10/11](https://www.debian.org/distrib/): x86_64 and arm64
    - [Ubuntu 22.04](https://releases.ubuntu.com/jammy/): x86_64 only
    - [Galaxy Kylin V10 SP2/SP3](https://www.kylinos.cn/scheme/server/1.html): x86_64 and arm64
    - [TrusOS kongzi](https://www.chinauos.com/): x86_64 and arm64
- The operating system needs to be a clean version because the deployment tool will build a specific version of the Kubernetes cluster from scratch. Ensure that the system does not have container management tools installed such as Kubernetes, Docker, etc., otherwise, conflicts may occur, resulting in installation exceptions.
- Minimum configuration requirements: CPU 4 cores, Memory 8GiB, Storage 100GiB
- The storage path used by the virtual machine and service is under **/opt**, so it is recommended to set a mount point separately for the **/opt** directory in an ideal environment.
    - For example, create a separate partition for /dev/sdb1, format it as ext4 and mount it to the /opt directory through /etc/fstab

## Install Ansible and Git

First, you need to install Ansible and Git. The minimum Ansible version requirement is 2.9.27, and version 2.11.12 has been widely tested.

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

If prompted with `locale` related errors, execute the following command first:

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
```Note: It is known that in the `debian 11` environment, if the boot option `systemd.unified_cgroup_hierarchy=0` cannot be found in `/proc/cmdline`, ocboot will automatically configure the corresponding `GRUB` option, rebuild the startup parameters, and restart the operating system so that `k8s` can start normally.

{{% /tab %}}

{{% tab name="Other Operating Systems" %}}
```bash
# Local installation of Ansible
$ python3 -m pip install --upgrade pip setuptools wheel
$ python3 -m pip install --upgrade ansible
```
{{% /tab %}}

{{< /tabs >}}

## Install Cloudpods

The deployment tool is available at [https://github.com/yunionio/ocboot](https://github.com/yunionio/ocboot), and this tool needs to be cloned using `git clone`, then run the `run.py` script to deploy the service. The operation steps are as follows:

```bash
# Download ocboot tool to local
$ git clone -b {{<release_branch>}} https://github.com/yunionio/ocboot && cd ./ocboot
```

Execute run.py to deploy the service. **<host_ip>** is the IP address of the deployment node. This parameter is optional. If not specified, the default route will be used to deploy the service. If there are multiple network cards on your node, you can specify **<host_ip>** to select the corresponding network card to monitor the service.

{{< tabs name="ocboot_install_region" >}}
{{% tab name="China" %}}

```bash
# Direct deployment, the container image is pulled from registry.cn-beijing.aliyuncs.com
$ ./run.py full <host_ip>

# If you encounter problems with slow pip package downloads, you can use the -m parameter to specify the pip source
# For example, using: https://mirrors.aliyun.com/pypi/simple/ source below
$ ./run.py -m https://mirrors.aliyun.com/pypi/simple/ full <host_ip>
```

{{% /tab %}}

{{% tab name="Other Regions" %}}

For some network environments where registry.cn-beijing.aliyuncs.com is slow or unreachable, as of version `v3.9.5`, you can specify the image source: [docker.io] (http://docker.io) to install. The command is as follows:

```bash
IMAGE_REPOSITORY=docker.io/yunion ./run.py full <host_ip>
```

{{% /tab %}}

{{< /tabs >}}

The **./run.py** script will call ansible to deploy the service. If there is a problem during the deployment process that causes the script to exit, the script can be executed again for retry.

{{% alert title="Note" color="warning" %}}
If you are deploying based on the CentOS 7 distribution, there will be one restart due to kernel installation. The ./run.py script will be interrupted, please wait for the operating system to restart, and then execute the ./run.py script again to install the subsequent steps.
{{% /alert %}}

## Deployment Complete

```bash
....
# After the deployment is complete, there will be the following output, indicating successful operation
# Open https://10.168.26.216 in the browser, where this ip was set up earlier
# Log in with admin/admin@123 user password to access the frontend interface
Initialized successfully!
Web page: https://10.168.26.216
User: admin
Password: admin@123
```

Then, use a browser to access https://10.168.26.216 , enter the username `admin` and password `admin@123` to access the Cloudpods interface.

![Login page](../images/index.png)

## Get Started with Cloudpods

### Create the first Virtual Machine

Follow these three steps to create your first virtual machine:

#### 1. Import Image

Browse to [CentOS 7 Cloud Host Image](https://cloud.centos.org/centos/7/images/) and select a GenericCloud image, copy the Image URL.# Translation

In the `Host` menu, select `System Image`, and then choose `Upload`. Enter the image name and select `Enter Image URL`. Paste the CentOS 7 image URL above and choose `OK`.

For more virtual machine images, please visit https://docs.openstack.org/image-guide/obtain-images.html.

#### 2. Create network (VPC and IP subnet)

[Create a new VPC] In the `Networking` menu, select the `VPC` submenu, and then choose `New`. Enter the name, for example, `vpc0`, select the target subnet, for example, `192.168.0.0/16`, and click `Create`.

[Create a new IP subnet] After the VPC is created, select the `IP subnet` submenu and choose `New`. Enter the name, for example, `vnet0`, select the VPC as the VPC that was just created, `vpc0`, select the availability zone, enter the `subnet` subnet, for example, `192.168.100.0/24`, and click `Create`.

[Typical network configuration](../../function_principle/onpremise/network/examples) provides several common host network configurations for your reference.

#### 3. Create a virtual machine

In the `Host` menu, choose `Virtual Machine` and then select `New`. Enter the host name, select the image and IP subnet, and create a virtual machine.

### Import public cloud or other private cloud platform resources

Cloudpods is itself a complete private cloud and can also manage resources from other cloud platforms.

In the `Multi-Cloud` menu, select `Cloud Account`, and then create an account. Fill in the corresponding authentication information for the corresponding cloud platform based on your requirements. After the cloud account is configured, the Cloudpods service synchronizes the resources of the corresponding cloud platform, and the results can be viewed on the frontend after the synchronization is complete.

![Multi-Cloud Management](../images/cloudaccount.png)


## FAQ

### 1. After All-in-One deployment, the host list does not display any hosts?

As shown in the figure below, if you find that there are no hosts in the host list after the environment deployment is complete, you can troubleshoot in the following ways:

![](../images/nohost.png)

1. Check the host problem on the control node, please refer to: [Host Service Problem Troubleshooting Skills](../../function_principle/onpremise/host/troubleshooting/)


    1. If the error message in the log includes "register failed: try create network: find_matched == false", it means that the IP subnet that contains the host was not created successfully, which caused the host registration to fail. Please create an IP subnet that contains the host subnet.


    ```
    # Create an IP subnet that contains the host subnet
    $ climc network-create bcast0  adm0 <start_ip> <end_ip> mask
    ```

    ![](../images/iperror.png)

    2. If the error message in the log includes "name starts with letter, and contains letter, number and - only", it means that the host name is not compliant and should be changed to a hostname starting with a letter.

    ![](../images/hostnameerror.png)

### 2. In the All-in-One environment, the virtual machine interface cannot be found?

The node that is deployed in the All-in-One environment will deploy the Cloudpods host compute service as a host machine that has the ability to create and manage private cloud virtual machines. If the virtual machine machine interface is not available, it means that the host machine has not been started in the Cloudpods environment.

Please go to the `Management Console` interface, click `Host/Basic Resources/Host` to view the host list, and then start the corresponding host. After refreshing the interface, the virtual machine interface will be available.

{{% alert title="Note" color="warning" %}}
If you want to use the Cloudpods private cloud virtual machine and the distribution version of the host machine is CentOS 7, the host machine needs to use the Cloudpods-compiled kernel. You can use the following command to check whether the host machine is using the Cloudpods kernel (contains the key word `yn`).

```bash
# Check whether to use yn kernel
$ uname -a | grep yn
Linux office-controller 3.10.0-1160.6.1.el7.yn20201125.x86_64
# If the kernel is not a version that contains the keyword yn, it may be the first time using ocboot installation. Restart to enter the yn kernel
$ reboot
```
{{% /alert %}}

![Host](../images/host.png)

### 3. Why can't the service be started after modifying the node's hostname?

Cloudpods uses Kubernetes to manage its nodes at the underlying level. The hostnames of the Kubernetes nodes are dependent on their nodes names. Changing a hostname would cause the node to fail to register with the Kubernetes cluster. Therefore, do not modify the hostname. If necessary, restore the hostname to its original name and the services will automatically recover.

### 4. How to reinstall?

1. Execute `kubeadm reset -f` to remove the Kubernetes cluster.

2. Re-run the run.py script of ocboot.

### 5. Other issues?

For other issues, please submit them on the Cloudpods GitHub issues page: [https://github.com/yunionio/cloudpods/issues](https://github.com/yunionio/cloudpods/issues). We will respond as soon as possible.
