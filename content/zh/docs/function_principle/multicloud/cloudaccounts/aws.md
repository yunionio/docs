---
title: "AWS"
weight: 2
description: >
    AWS 对接常见问题。
---

## 获取AWS子账号资源信息的权限要求

如果云管对接的AWS账号归属于组织（Organization），可以通过权限配置，将AWS组织下所有账号同步到云管，每个账号对应到云账号下的一个订阅。

获取AWS组织的每个成员账号下资源的原理为：使用一个主账号下的IAM账号的AKSK通过AssumeRole的方式获得OrganizationAccountAccessRole的权限，访问每个成员账号下的资源

权限配置要求如下：

1. 对接AK/SK必须是一个主账号一个IAM user的AK/SK，不能是主账号的主AKSK

2. 该IAM user的最小权限要求为：sts:AssumeRole

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "sts:AssumeRole",
            "Resource": "arn:aws:iam::*:role/OrganizationAccountAccessRole"
 
        }
    ]
}
```

3. 每个成员账号内都有 Role：OrganizationAccountAccessRole

对于在AWS组织（Organization）下新建的AWS成员账号，都自动有一个Role：OrganizationAccountAccessRole，该role的权限等同于 AdministratorAccess

如果是邀请加入的AWS成员账号，则不一定有这个Role，需要手工增加，具体步骤参见：https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_accounts_access.html#orgs_manage_accounts_create-cross-account-role
