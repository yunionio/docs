---
title: "资源和权限体系"
date: 2019-08-04T20:51:23+08:00
weight: 4
description: >
  介绍Keystone的资源归属体系以及相应的权限体系
---

Keystone的资源和权限体系由*项目*，*角色*和*权限*这三类资源定义。项目是资源的归属，用户要使用资源，必须以特定的角色加入相应的项目。角色和策略(policy)关联，定义了用户的权限。

## 项目(Projects)

项目是资源的owner，所有虚拟资源都要归属于一个项目。用户或者用户的组加入项目后，在获得权限后才能授权访问资源。

项目一般用*Project*指代，但是为了和Keystone v2 API兼容，偶尔也用*Tenant*指代。

### 属性

字段           | 说明
---------------|----------------------------
id	           | 项目ID
name           | 项目名称	
domain_id      | 项目归属的域ID	
project_domain | 项目归属域的名称	

### 限制：

v3.7之前，用户或者组只能加入同一个域下的项目，或者default域下的项目。Default域下的项目可以加入任意域的用户或者组，非Default域下的项目只能加入同域的用户或者组。v3.7之后，该限制解除，任意域的用或者组可以加入任意域下的项目。

项目下在其他服务有外部资源的无法删除。他服务的资源，默认每15分钟拉取一次, 通过参数设置：fetch_project_resource_count_interval_seconds。

包含用户和组的项目无法删除

system项目无法删除和修改

### 项目名字空间

项目的名字空间为全局，也就是项目的名称全局唯一

### 预置项目

系统初始化时，预置项目system，作为sysadmin的项目


## 角色(Roles)

角色是用户加入项目的角色。用户的角色确定了用户的权限。

### 属性

角色的属性如下：

字段           | 说明
---------------|-----------------------------
id	           | ID，不可修改	
name	       | 名称，可修改	
public_scope   | 共享范围，可选择值为system（全局共享），domain（域共享）
policies       | 该角色对应的各个级别的权限名称的列表
match_policies | 该角色对应的所有权限名称的列表

### 限制

一个域下的用户，只能使用项目所在域的角色或者共享的角色加入项目

一个被用户或者组使用的角色不能被删除

共享的角色不能被删除

admin角色不能被删除

### 角色名字空间

角色的名字空间为全局，也就是角色的名称全局唯一

### 预置角色

系统初始化时，预置了admin的角色，作为系统用户syadmin加入system项目的缺省角色

同时，在系统初始化完成后，安装程序会自动创建如下的共享项目，以方便用户：

角色名称       | 是否共享 | 含义         | 使用场景
---------------|----------|--------------|--------------------
admin          | 是       | 全局管理员   | 系统管理员角色，最高权限的角色
sa             | 是       | 运维管理员   | 一般给运维人员分配
fa	           | 是       | 财务管理员   | 一般给财务人员分配
domainfa       | 是       | 域财务管理员 | 一般给域内的财务人员分配
projectfa      | 是       | 项目财务管理员 | 一般给项目内的财务人员分配
project_owner  | 是       | 项目主管     | 一般给项目管理员分配
project_editor | 是       | 项目操作员   | 一般给项目内管理员，但是缺少创建和删除资源的权限
project_viwer  | 是       | 项目只读人员 | 一般给项目的普通成员，只能查看，无法操作，创建和删除资源
domainadmin    | 是       | 域管理员     | 一般给域管理员分配
domaineditor   | 是       | 域管理员     | 一般给域管理员分配
domainviwer    | 是       | 域管理员     | 一般给域管理员分配

## 权限策略（Policies） 

权限定义了权限的匹配规则，权限范围和权限定义

### 属性

权限策略的属性如下：

属性           | 类型       | 说明
---------------|------------|---------------
id             | String     | ID
name           | String     | 名称
policy         | JSONObject | 策略定义，存储为json格式，可以yaml或者json方式呈现
scope          | String     | 策略的权限定义范围，project（项目范围权限）, domain（域范围权限）或者system（系统/全局权限）
public_scope   | String     | 策略的共享范围，none (不共享), domain（共享到指定域），system（全局共享）
Domain_id      | String     | 归属域的ID
Project_Domain | String     | 归属域的名称
Is_System      | boolean    | 是否为系统定义的权限策略
enabled        | boolean    | 该策略是否启用

### 权限策略定义

权限策略的Policy字段存储了定义，每个权限策略包含如下几个字段：

权限定义   | 类型   | 具体的权限定义，即对特定服务的特定资源的特定操作是否有权限
-----------|--------|-------------------------------------------------------------
Service	   | string | 适用的服务，例如：compute, identity
Resource   | string | 适用的资源类型，例如：servers
Operation  | string	| 适用的操作，支持的操作为
Result	   | string	| 策略的结果，只有两个值：Allow和Deny

Operation支持的操作如下：

操作    | 说明
--------|----------------------
list    | 列出所有资源
get     | 获取指定资源的详情
create  | 创建新的资源
update  | 更新
delete  | 删除
perform	| 执行操作，例如对主机进行开机关机等操作

### 权限策略举例

* 管理员权限
```yaml
scope: system
policy:
  '*': allow
```

* 项目内计算服务只读
```yaml
scope: project
policy:
  compute:
    '*': allow
```

* 域内计算服务操作者（不能创建和删除资源）

```yaml
scope: domain
policy:
  compute:
    '*':
      create: deny
      delete: deny
      '*': allow
```

### 系统预置策略

为了方便使用，系统内预置了150多个权限策略，例如系统管理员 sysadmin，域管理 domainadmin，项目owner：projectadmin等。

其中，为了使用web控制台，用户需要具备一些特殊权限，预定义到了这几个预置权限策略中：sys-dashboard, domain-doshboard, project-dashboard，分别对应系统视图，域视图和项目视图的web控制台权限。如果一个角色需要访问web控制台，需要给该角色增加对应的权限策略。


### 角色与权限

角色需要和权限关联，关联关系定义在role_policy关联表，该关联关系具有如下属性，定义了角色和权限关联的条件：

属性       | 类型    | 是否必须字段 | 说明
-----------|---------|--------------|-----------------------------------------------------------------
role_id    | string  | 是           | 角色ID
policy_id  | string  | 是           | 权限策略ID
project_id | string  | 否           | 如果设置了项目，则只有用户以指定角色加入该项目，才具备对应的权限
auth       | boolean | 否           | 是否需要认证，不需要认证
ips        | string  | 否           | 如果设置了IPS，则只有用户通过匹配IP登录的才具备对应的权限

例如，sysadmin的权限和admin角色关联，project_id为system项目的ID，auth为true，则要求用户以admin角色加入system项目，才具备sysadmin的权限。

### 限制

启用(enabled=true)的权限无法删除
共享的权限无法删除


### 权限的名字空间

权限的名字空间为全局，也就是权限的名称全局唯一

