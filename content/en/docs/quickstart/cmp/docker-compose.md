---
title: "Docker Compose Installation"
linkTitle: "Docker Compose Installation"
weight: 2
edition: ce
description: >
  Use [Docker Compose](https://docs.docker.com/compose/) to quickly deploy the Cloudpods CMP multi-cloud management version.
---

## Prerequisites

{{% alert title="Warning" color="warning" %}}
This solution uses Docker Compose to deploy the Cloudpods multi-cloud management version. This method deploys an All-in-One environment, which means that all multi-cloud management services are run in containers on a single node.

This deployment method is only applicable for using multi-cloud management functions, such as managing public clouds (AWS, Alibaba Cloud, Tencent Cloud, etc.) or other private clouds (Zstack, OpenStack, etc.), and cannot use built-in private cloud-related functions (because built-in private clouds require installation and configuration of various virtualization software such as qemu and OpenVswitch on the nodes).

In addition, VMware cannot currently be managed using the Docker Compose method because current disk management for VMware relies on the nbd module in the kernel, which cannot be loaded within Docker Compose. If you need to manage VMware, please use the [Ocboot installation] by following the steps described in the [../cmp/allinone-multicloud] section.

If you need to use built-in private clouds, please use the [Private Cloud Installation](../../../quickstart/allinone-virt) method of deployment.
{{% /alert %}}

## Environmental Requirements

### Machine Configuration Requirements

- Minimum configuration requirements: 4 core CPU, 8GB RAM, and 100GB storage
- Docker version: ce-23.0.2
    - Docker recommends installing the latest version of ce, which already includes the Docker Compose plugin.
    - Docker requires enabling container networks and iptables.

### Installation and Configuration of Docker

{{% alert title= "Attention" color="warning" %}}
Skip this step if your environment has already installed the new version of Docker.
{{% /alert %}}

The following is an example of how to install Docker on CentOS 7. If you are using another distribution, please refer to the official documentation for installation: [Install Docker Engine] (https://docs.docker.com/engine/install/).

Chinese users can use the aliyun repository to install Docker-CE, as shown below:

```bash
# Install necessary system tools
$ sudo yum install -y yum-utils device-mapper-persistent-data lvm2

# Add software source information
$ sudo yum-config-manager --add-repo https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo

# Update and install docker-ce and compose plugins
$ sudo yum makecache fast
$ sudo yum -y install docker-ce docker-ce-cli docker-compose-plugin

# enable docker service
$ sudo systemctl enable --now docker
```

## Running Cloudpods CMP

After the Docker Compose environment is ready, you can use the docker-compose.yml configuration file in https://github.com/yunionio/ocboot to start the service. The steps are as follows:

```bash
# download ocboot tool locally
$ git clone -b release/3.10 https://github.com/yunionio/ocboot && cd ./ocboot

# enter the compose directory
$ cd compose
$ ls -alh docker-compose.yml

# run service
$ docker compose up
```

After the service is started, you can log in to *https://<local-ip>* to access the frontend service, and the default login user password is: admin and admin@123.

## Operating Instructions

### 1. Run services in the background

You can use the '-d/--detach' parameter to run all services in the background, as shown below:

```bash
# run all services in the background```
$ docker compose up -d

# After putting the service to the background, the log output can be viewed with the logs command
$ docker compose logs -f
```

### 2. Login to the climc command line container

If you want to operate the platform with command line tools, you can use the following method to enter the container:

```bash
$ docker exec -ti compose-climc-1 bash
Welcome to Cloud Shell :-) You may execute climc and other command tools in this shell.
Please exec 'climc' to get started

# Source authentication information
bash-5.1# source /etc/yunion/rcadmin
bash-5.1# climc user-list
```

### 3. View service configuration and persistent data

The persistent data of all services is stored under the *ocboot/compose/data* directory. All configurations are automatically generated and usually do not need to be manually modified. The following explains each directory:

```bash
$ tree data
data
├── etc
│   ├── nginx
│   │   └── conf.d
│   │       └── default.conf    # Front-end nginx configuration
│   └── yunion
│       ├── *.conf  # Configuration of each Cloudpods service
│       ├── pki     # Certificate directory
│       ├── rcadmin     # Command line authentication information
├── opt
│   └── cloud
│       └── workspace
│           └── data
│               └── glance # Image directory for image services
└── var
    └── lib
        ├── influxdb    # influxdb persistent data directory
        └── mysql       # mysql database persistent data directory
```

### 4. Delete all containers

The persistent data of all services is stored under the *ocboot/compose/data* directory. Deleting containers will not lose data. You can restart directly with *docker compose up* next time, and the operation is as follows:

```bash
# Delete services
$ docker compose down
```

## Common Questions

### 1. Docker service does not open iptables and bridge, causing the container network to fail to create

By default, when starting the Docker service, iptables is turned on by default. If "bridge: none" and "iptables: false" are set in */etc/docker/daemon.json*, docker compose cannot be used.

Before running docker compose, make sure that the bridge and iptables functions are turned on.


### 2. How was docker-compose.yml with many services generated?

The Cloudpods CMP multi-cloud version includes many services. If you manually write the compose configuration for each service, it will be very complicated. Therefore, there is a *generate-compose.py* script in ocboot, which is responsible for generating a docker-compose.yml file. You can use the following command to generate the compose configuration file:

```bash
$ python3 generate-compose.py > compose/docker-compose.yml
```

### 3. How to upgrade the service?

Upgrading through docker compose is very convenient, just update the docker-compose.yml configuration file.

For example, if *ocboot/compose/docker-compose.yml* is updated, you can use git pull to get the latest code and then restart it. The steps are as follows:

```bash
# Use git pull to update
$ cd ocboot
$ git pull

# Restart compose service
$ cd compose
$ docker compose down
$ docker compose up -d
```
