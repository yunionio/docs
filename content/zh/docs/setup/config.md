---
title: "配置要求"
weight: 2
description: >
    介绍部署 var_oem_name 平台的配置要求
---

### 硬件配置要求

下表为不同场景需要部署的节点及配置要求等。请根据具体使用场景进行规划部署。

<table>
   <tr>
      <th>部署场景</th>
      <th>部署组件</th>
      <th>配置需求</th>
      <th>资源占用情况</th>
      <th>备注</th>
   </tr>
   <tr>
      <td>多云场景</td>
      <td>控制节点</td>
      <td>
        <li>最低配置：8C16G500G（推荐使用SSD硬盘，且系统盘不低于200GB）；</li>
        <li>服务器：支持部署在虚拟机或物理服务器；</li>
        <li>操作系统：推荐CentOS 7.6~7.8 Minimal；</li>
        <li>配置要求：每增加500台虚拟机，需要增加8C8G200G的系统资源；</li>
        <li>高可用要求：至少需要3台相同配置的服务器</li>
      </td>
      <td>全部资源</td>
      <td>待纳管的云账号具有读写权限的Access Key ID和Access Key Secret</td>
   </tr>
   <tr>
      <td rowspan="3">私有云场景</td>
      <td>控制节点</td>
      <td>
        <li>最低配置：8C16G500G（推荐使用SSD硬盘，且系统盘不低于200GB）；</li>
        <li>服务器：支持部署在虚拟机或物理服务器；</li>
        <li>操作系统：推荐CentOS 7.6~7.8 Minimal；</li>
        <li>配置要求：每增加500台虚拟机，需要增加8C8G200G的系统资源；</li>
        <li>高可用要求：至少需要3台相同配置的服务器</li>
      </td>
      <td>全部资源</td>
      <td></td>
   </tr>
   <tr>
      <td>计算节点</td>
      <td>
        <li>服务器：带硬件虚拟化特性的通用X86物理服务器；</li>
        <li>操作系统：推荐CentOS 7.6~7.8 Minimal；</li>
        <li>配置要求：CPU需开启VT、32G以上内存、1T以上的硬盘</li>
      </td>
      <td>产品服务需占用2C2G200G的系统资源</td>
      <td>
        <li>如使用经典网络则需为虚拟机申请网络可达的内网IP。</li>
        <li>如使用VPC网络则需要申请内网可达的IP地址段作为弹性公网IP</li>
      </td>
   </tr>
   <tr>
      <td>Ceph存储</td>
      <td>
        <li>服务器：通用X86物理服务器；</li>
        <li>配置要求：至少32C64G、系统盘使用单独硬盘、数据盘配置4块以上大容量SATA硬盘，且支持直通模式</li>
        <li>网络：万兆及以上</li>
      </td>
      <td>不占用资源</td>
      <td></td>
   </tr>
   <tr>
      <td rowspan="3">物理机纳管</td>
      <td>
        <li>控制节点</li>
        <li>启用Baremetal服务</li>
      </td>
      <td>
        <li>最低配置：8C16G500G（推荐使用SSD硬盘，且系统盘不低于200GB）；</li>
        <li>服务器：支持部署在虚拟机或物理服务器；</li>
        <li>操作系统：推荐CentOS 7.6~7.8 Minimal；</li>
        <li>配置要求：每增加500台虚拟机，需要增加8C8G200G的系统资源；</li>
        <li>高可用要求：至少需要3台相同配置的服务器</li>
      </td>
      <td>全部资源</td>
      <td></td>
   </tr>
   <tr>
      <td>裸金属</td>
      <td>
        <li>服务器：通用X86物理服务器；</li>
        <li>配置要求：具备IPMI管理功能；启用方式设置为BIOS PXE启动</li>
      </td>
      <td>不占用资源</td>
      <td>
        <li>为物理机单独申请网络可达的IPMI和内网IP子网</li>
        <li>若环境不支持DHCP Relay，则要求服务器支持Redfish</li>
      </td>
   </tr>
</table>

### 公有云主机配置注意事项

如在公有云中的云主机上部署{{<oem_name>}}平台，请注意以下事项：

- 由于公有云上的云主机不能设置vip，数据库不是双主模式，因此在公有云上无法安装高可用环境，建议仅配置k8s高可用，{{<oem_name>}}平台部署一个控制节点和两个计算节点。
- 当在公有云上部署多个节点时，建议云主机之间请放开全部端口。
- 在公有云上部署环境时，建议部署Mariadb数据库，不要使用mysql 5.6及以下版本，防止索引长度 bug： Index column size too large. The maximum column size is 767 bytes.