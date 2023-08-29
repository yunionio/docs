---
title: "Azure 创建订阅设置"
weight: 2
description: >
    描述如何给应用程序赋权支持创建订阅
---

## 前置条件
- Azure账号为国际区账号
- Azure账号为企业账号
- 平台录入的账号和此文档中的应用程序是同一个

## 登录Azure控制台, 开启CloudShell

![](../images/az_cloud_shell.png)

## 获取 enrollment account id

在上面的cloud shell中执行 az billing enrollment-account list, 如下图

![](../images/az_enrollment_account.png)

这里假设id 为 /providers/Microsoft.Billing/enrollmentAccounts/747ddfe5-xxxx-xxxx-xxxx-xxxxxxxxxxxx 保存 以备用

## 获取应用程序Id

到Azure Active Directory => 应用注册中找到使用的应用，并获得 应用程序(客户端) ID, 并在cloud shell执行
```shell
az ad sp show --id 7ffdacec-8769-4802-9975-4ba7a2906ec8 | grep id
```

![](../images/az_app_id.png)

获得应用程序Id为 5b744b52-4215-4cc7-b776-429ce447c62c 保存备用


## 赋予应用程序enrollment account Onwer权限

打开cloud shell 执行

```shell
# 这里的 5b744b52-4215-4cc7-b776-429ce447c62c 是应用程序Id
# /providers/Microsoft.Billing/enrollmentAccounts/747ddfe5-xxxx-xxxx-xxxx-xxxxxxxxxxxx 是 enrollment account id
az role assignment create --role Owner --assignee-object-id 5b744b52-4215-4cc7-b776-429ce447c62c --scope /providers/Microsoft.Billing/enrollmentAccounts/747ddfe5-xxxx-xxxx-xxxx-xxxxxxxxxxxx
```

如图所示即赋权成功
![](../images/az_assign_role.png)


{{% alert title="说明" %}}

若创建订阅时报 **EntitlementNotFound** 的错误，需要根据文档到ea上开启[创建订阅权限](https://learn.microsoft.com/en-us/azure/cost-management-billing/manage/ea-portal-administration#enterprise-devtest-offer)

{{% /alert %}}

## 参考文档
- [编程创建订阅](https://learn.microsoft.com/en-us/azure/cost-management-billing/manage/programmatically-create-subscription-preview?tabs=azure-cli)
- [赋权文档](https://learn.microsoft.com/en-us/azure/cost-management-billing/manage/grant-access-to-create-subscription?tabs=rest%2Crest-2)
- [开启创建订阅权限](https://learn.microsoft.com/en-us/azure/cost-management-billing/manage/ea-portal-administration#enterprise-devtest-offer)
