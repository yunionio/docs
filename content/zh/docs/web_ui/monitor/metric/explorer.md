---
title: "监控查询"
weight: 2
description: 监控查询支持用户自定义查询平台中的虚拟机、宿主机等资源的CPU、内存、磁盘、网络等指标的监控信息等。    
---

监控查询支持用户自定义查询平台中的虚拟机、宿主机等资源的CPU、内存、磁盘、网络等指标的监控信息等。


**入口**：在云管平台单击左上角![](../../../images/intro/nav.png)导航菜单，在弹出的左侧菜单栏中单击 **_"监控/监控/监控查询"_** 菜单项，进入监控查询页面。

![](../../../images/monitor/explorer.png)

## 添加查询

该功能用于自定义查询监控数据。在左侧查询条件中自定义指标、过滤条件、聚合分组等，右侧将实时显示对应指标的监控数据图表等。支持添加多个查询，每一个查询对应一个图表等。

1. 在监控查询页面补充你的查询条件中配置以下参数：
   - 监控指标：支持通过资源类型、监控指标、指标项等设置具体的监控指标，支持对平台纳管的虚拟机、虚拟机（Agent）、宿主机、云账号、存储桶、RDS、Redis等资源进行监控。
   - 资源过滤（可选）：右侧图表中将默认显示全部资源的所选指标的信息，可通过平台、区域、项目等等条件过滤用户所需的数据。
   - 分组（可选）：当查询返回的数据量较大时，可通过分组和聚合的方式将数据聚合成一条或多条等。支持通过平台、区域、可用区等
   - 函数（可选）：聚合函数包括平均值、最大值、最小值、标准差和分类百分位值。  
2. 右侧或下侧图表中将会实时显示对应指标的监控图表。支持查看近1小时、近3小时、近6小时、近1天、近3天或自定义时间的监控数据。
3. 当配置完第一个查询后，用户可单击 **_"添加查询"_** 按钮，折叠之前的查询条件，添加新的查询条件等。

## 折叠查询条件

用户可以将查询条件折叠，右侧的监控图表不会折叠。

1. 在监控查询页面，单击查询条件右上角![](../../../images/ops/fold.png)图标，将查询条件折叠。

## 删除查询条件

当存在多个查询时，用户可以删除查询，至少将会保留一个查询的设置框。

1. 在监控查询页面，单击查询条件右上角![](../../../images/ops/delete.png)图标，删除查询条件。

## 保存面板

当通过查询条件，查询出图表时，支持将图表保存到监控面板中，请确保已创建了监控面板。

1. 在监控查询页面，通过查询条件，查询出图表时，单击图表右上角 **_"保存"_** 按钮，弹出保存对话框。
2. 配置图标名称以及选择监控面板，单击 **_"确定"_** 按钮，保存到监控面板中。


## 监控指标支持情况

<style> 
table tr th, table tr td  { border:1px solid #808080; padding:5px; }
</style>

<table>
    <tr>
        <td>分类</td>
        <td>平台</td>
        <td>资源类型</td>
        <td>监控指标</td>
    </tr>
    <tr>
        <td rowspan="67">公有云</td>
        <td rowspan="13">阿里云</td>
        <td rowspan="5">虚拟机</td>
        <td>CPU</td>
    </tr>
    <tr>
        <td>内存</td>
    </tr>
    <tr>
        <td>磁盘使用情况</td>
    </tr>
    <tr>
        <td>磁盘I/O</td>
    </tr>
    <tr>
        <td>网络</td>
    </tr>
    <tr>
        <td rowspan="3">OSS</td>
        <td>对象存储延时</td>
    </tr>
    <tr>
        <td>网络流量情况</td>
    </tr>
    <tr>
        <td>请求情况</td>
    </tr>
    <tr>
        <td rowspan="4">RDS</td>
        <td>CPU</td>
    </tr>
    <tr>
        <td>内存</td>
    </tr>
    <tr>
        <td>磁盘</td>
    </tr>
    <tr>
        <td>网络</td>
    </tr>
    <tr>
        <td>云账号</td>
        <td>云账号余额</td>
    </tr>
    <tr>
        <td rowspan="9">腾讯云</td>
        <td rowspan="4">虚拟机</td>
        <td>CPU</td>
    </tr>
    <tr>
        <td>内存</td>
    </tr>
    <tr>
        <td>磁盘使用情况</td>
    </tr>
    <tr>
        <td>网络</td>
    </tr>
    <tr>
        <td rowspan="4">RDS</td>
        <td>CPU</td>
    </tr>
    <tr>
        <td>内存</td>
    </tr>
    <tr>
        <td>磁盘</td>
    </tr>
    <tr>
        <td>网络</td>
    </tr>
    <tr>
        <td>云账号</td>
        <td>云账号余额</td>
    </tr>
    <tr>
        <td rowspan="13">华为云</td>
        <td rowspan="5">虚拟机</td>
        <td>CPU</td>
    </tr>
    <tr>
        <td>内存</td>
    </tr>
    <tr>
        <td>磁盘使用情况</td>
    </tr>
    <tr>
        <td>磁盘I/O</td>
    </tr>
    <tr>
        <td>网络</td>
    </tr>
    <tr>
        <td rowspan="3">OSS</td>
        <td>对象存储延时</td>
    </tr>
    <tr>
        <td>网络流量情况</td>
    </tr>
    <tr>
        <td>请求情况</td>
    </tr>
    <tr>
        <td rowspan="4">RDS</td>
        <td>CPU</td>
    </tr>
    <tr>
        <td>内存</td>
    </tr>
    <tr>
        <td>磁盘</td>
    </tr>
    <tr>
        <td>网络</td>
    </tr>
    <tr>
        <td>云账号</td>
        <td>云账号余额</td>
    </tr>
    <tr>
        <td rowspan="5">移动云</td>
        <td rowspan="5">虚拟机</td>
        <td>CPU</td>
    </tr>
    <tr>
        <td>内存</td>
    </tr>
    <tr>
        <td>磁盘使用情况</td>
    </tr>
    <tr>
        <td>磁盘I/O</td>
    </tr>
    <tr>
        <td>网络</td>
    </tr>
    <tr>
        <td rowspan="10">京东云</td>
        <td rowspan="5">虚拟机</td>
        <td>CPU</td>
    </tr>
    <tr>
        <td>内存</td>
    </tr>
    <tr>
        <td>磁盘使用情况</td>
    </tr>
    <tr>
        <td>磁盘I/O</td>
    </tr>
    <tr>
        <td>网络</td>
    </tr>
    <tr>
        <td rowspan="4">RDS</td>
        <td>CPU</td>
    </tr>
    <tr>
        <td>内存</td>
    </tr>
    <tr>
        <td>磁盘</td>
    </tr>
    <tr>
        <td>网络</td>
    </tr>
    <tr>
        <td>云账号</td>
        <td>云账号余额</td>
    </tr>
    <tr>
        <td>天翼云</td>
        <td>不支持</td>
        <td></td>
    </tr>
    <tr>
        <td>UCloud</td>
        <td>不支持</td>
        <td></td>
    </tr>
    <tr>
        <td rowspan="5">AWS</td>
        <td rowspan="5">虚拟机</td>
        <td>CPU</td>
    </tr>
    <tr>
        <td>内存</td>
    </tr>
    <tr>
        <td>磁盘使用情况</td>
    </tr>
    <tr>
        <td>磁盘I/O</td>
    </tr>
    <tr>
        <td>网络</td>
    </tr>
    <tr>
        <td rowspan="5">Azure</td>
        <td rowspan="5">虚拟机</td>
        <td>CPU</td>
    </tr>
    <tr>
        <td>内存</td>
    </tr>
    <tr>
        <td>磁盘使用情况</td>
    </tr>
    <tr>
        <td>磁盘I/O</td>
    </tr>
    <tr>
        <td>网络</td>
    </tr>
    <tr>
        <td rowspan="5">Google </td>
        <td rowspan="5">虚拟机</td>
        <td>CPU</td>
    </tr>
    <tr>
        <td>内存</td>
    </tr>
    <tr>
        <td>磁盘使用情况</td>
    </tr>
    <tr>
        <td>磁盘I/O</td>
    </tr>
    <tr>
        <td>网络</td>
    </tr>
    <tr>
        <td rowspan="20">私有云</td>
        <td rowspan="10">openStack</td>
        <td rowspan="5">虚拟机</td>
        <td>CPU</td>
    </tr>
    <tr>
        <td>内存</td>
    </tr>
    <tr>
        <td>磁盘使用情况</td>
    </tr>
    <tr>
        <td>磁盘I/O</td>
    </tr>
    <tr>
        <td>网络</td>
    </tr>
    <tr>
        <td rowspan="4">宿主机</td>
        <td>CPU</td>
    </tr>
    <tr>
        <td>磁盘使用情况</td>
    </tr>
    <tr>
        <td>磁盘I/O</td>
    </tr>
    <tr>
        <td>网络</td>
    </tr>
    <tr>
        <td>存储</td>
        <td>块存储使用情况</td>
    </tr>
    <tr>
        <td rowspan="10">ZStack</td>
        <td rowspan="5">虚拟机</td>
        <td>CPU</td>
    </tr>
    <tr>
        <td>内存</td>
    </tr>
    <tr>
        <td>磁盘使用情况</td>
    </tr>
    <tr>
        <td>磁盘I/O</td>
    </tr>
    <tr>
        <td>网络</td>
    </tr>
    <tr>
        <td rowspan="4">宿主机</td>
        <td>CPU</td>
    </tr>
    <tr>
        <td>磁盘使用情况</td>
    </tr>
    <tr>
        <td>磁盘I/O</td>
    </tr>
    <tr>
        <td>网络</td>
    </tr>
    <tr>
        <td>存储</td>
        <td>块存储使用情况</td>
    </tr>
    <tr>
        <td rowspan="20">本地IDC</td>
        <td rowspan="10"> {{<oem_name>}} </td>
        <td rowspan="5">虚拟机</td>
        <td>CPU</td>
    </tr>
    <tr>
        <td>内存</td>
    </tr>
    <tr>
        <td>磁盘使用情况</td>
    </tr>
    <tr>
        <td>磁盘I/O</td>
    </tr>
    <tr>
        <td>网络</td>
    </tr>
    <tr>
        <td rowspan="4">宿主机</td>
        <td>CPU</td>
    </tr>
    <tr>
        <td>磁盘使用情况</td>
    </tr>
    <tr>
        <td>磁盘I/O</td>
    </tr>
    <tr>
        <td>网络</td>
    </tr>
    <tr>
        <td>存储</td>
        <td>块存储使用情况</td>
    </tr>
    <tr>
        <td rowspan="10">VMware</td>
        <td rowspan="5">虚拟机</td>
        <td>CPU</td>
    </tr>
    <tr>
        <td>内存</td>
    </tr>
    <tr>
        <td>磁盘使用情况</td>
    </tr>
    <tr>
        <td>磁盘I/O</td>
    </tr>
    <tr>
        <td>网络</td>
    </tr>
    <tr>
        <td rowspan="4">宿主机</td>
        <td>CPU</td>
    </tr>
    <tr>
        <td>磁盘使用情况</td>
    </tr>
    <tr>
        <td>磁盘I/O</td>
    </tr>
    <tr>
        <td>网络</td>
    </tr>
    <tr>
        <td>存储</td>
        <td>块存储使用情况</td>
    </tr>
</table>
