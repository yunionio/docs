---
title: "代码结构"
weight: 7
description:
  介绍Cloudpods的代码结构
---

## 后端代码结构

TODO

## 前端代码结构

- [containers](https://github.com/yunionio/dashboard/tree/master/containers): 功能模块（对应一级菜单）
  - [Dashboard](https://github.com/yunionio/dashboard/tree/master/containers/Dashboard): 控制面板
    - components: 模块内组件
    - extends: 控制面板不同种类的磁贴目录
    - locales: 国际化（控制面板部分）
    - router: 路由
    - sections: 磁贴配置时使用的业务组件
    - styles: 样式文件
    - utils: 工具方法
    - views: 页面展示文件
  - [Cloudenv](https://github.com/yunionio/dashboard/tree/master/containers/Cloudenv): 多云管理
    - contants: 模块内常量
    - locales: 国际化（当前模块部分）
    - router: 路由（当前模块部分）
    - sections: 业务组件
    - utils: 工具方法
    - views: 模块页面（对应二级菜单）
      - cloudaccount: 模块名
        - components: 组件目录，其中 List.vue 为当前二级菜单模块的列表页
        - create: 新建相关页面
        - dialogs: 弹框组件
        - mixins: 提供当前模块列表、详情、新建、弹框等使用的mixin，常见singleAction.js（列表单行操作按钮）与columns.js（定义列表表头）
        - sidepage: 包含但不限于详情页的侧边栏组件
        - utils: 工具方法
        - index.vue: 当前模块的入口文件
  - [Compute](https://github.com/yunionio/dashboard/tree/master/containers/Compute): 主机
    - 以下各模块代码结构同 多云管理
  - [DB](https://github.com/yunionio/dashboard/tree/master/containers/DB): 数据库
  - [Helm](https://github.com/yunionio/dashboard/tree/master/containers/Helm): 运维工具
  - [IAM](https://github.com/yunionio/dashboard/tree/master/containers/IAM): 认证与安全
  - [K8S](https://github.com/yunionio/dashboard/tree/master/containers/K8S): 容器
  - [Middleware](https://github.com/yunionio/dashboard/tree/master/containers/Middleware): 中间件
  - [Monitor](https://github.com/yunionio/dashboard/tree/master/containers/Monitor): 监控
  - [Network](https://github.com/yunionio/dashboard/tree/master/containers/Network): 网络
  - [Storage](https://github.com/yunionio/dashboard/tree/master/containers/Storage): 存储
- [mock](https://github.com/yunionio/dashboard/tree/master/mock): API管理（测试用）
- [public](https://github.com/yunionio/dashboard/tree/master/public): 
  - [index.html](https://github.com/yunionio/dashboard/tree/master/public/index.html): 入口页面
- [scope](https://github.com/yunionio/dashboard/tree/master/scope): 授权相关
  - [assets](https://github.com/yunionio/dashboard/tree/master/scope/assets): 存放全局自定义icon
  - [router](https://github.com/yunionio/dashboard/tree/master/scope/router): 路由（登录授权部分）
  - [store](https://github.com/yunionio/dashboard/tree/master/scope/store): 状态管理（登录授权部分）
- [scripts](https://github.com/yunionio/dashboard/tree/master/scripts): 可执行脚本
- [src](https://github.com/yunionio/dashboard/tree/master/src): 源码目录
  - [assets](https://github.com/yunionio/dashboard/tree/master/src/assets): 静态资源
  - [components](https://github.com/yunionio/dashboard/tree/master/src/components): 全局通用组件（可直接使用，无需引入）
  - [config](https://github.com/yunionio/dashboard/tree/master/src/config): 配置，包含插件、主题、语言、渠道等
  - [constants](https://github.com/yunionio/dashboard/tree/master/src/constants): 全局常量，包含多云类型、全局搜索、色彩配置、监控等
  - [layouts](https://github.com/yunionio/dashboard/tree/master/src/layouts): 页面排版相关组件
  - [locales](https://github.com/yunionio/dashboard/tree/master/src/locales): 国际化（全局）
  - [mixins](https://github.com/yunionio/dashboard/tree/master/src/mixins): 全局mixin
  - [plugins](https://github.com/yunionio/dashboard/tree/master/src/plugins): 插件目录
  - [router](https://github.com/yunionio/dashboard/tree/master/src/router): 全局路由（包含scope和containers中的路由）
  - [sections](https://github.com/yunionio/dashboard/tree/master/src/sections): 全局业务组件
  - [store](https://github.com/yunionio/dashboard/tree/master/src/store): 全局状态管理
  - [styles](https://github.com/yunionio/dashboard/tree/master/src/styles): 样式
  - [tools](https://github.com/yunionio/dashboard/tree/master/src/tools): 包含国际化插件
  - [utils](https://github.com/yunionio/dashboard/tree/master/src/utils): 全局工具方法（http、表单验证、列表、echart、storage、授权、error等）
  - [views](https://github.com/yunionio/dashboard/tree/master/src/views): 页面（用户信息、工单信息、全局搜索、邮箱验证等）
- [tests](https://github.com/yunionio/dashboard/tree/master/tests): 测试文件目录
- [upload](https://github.com/yunionio/dashboard/tree/master/upload): 打包发布流程配置
- [.env.development](https://github.com/yunionio/dashboard/tree/master/.env.development): 开发环境变量
- [.env.production](https://github.com/yunionio/dashboard/tree/master/.env.production): 生产环境变量
- [.gitignore](https://github.com/yunionio/dashboard/tree/master/.gitignore): Git忽略文件
- [package.json](https://github.com/yunionio/dashboard/tree/master/package.json): npm包配置文件
- [package-lock.json](https://github.com/yunionio/dashboard/tree/master/package-lock.json): npm包版本锁定文件
- [yarn.lock](https://github.com/yunionio/dashboard/tree/master/yarn.lock): npm包版本锁定文件
- [vue.config.js](https://github.com/yunionio/dashboard/tree/master/vue.config.js): Vue配置文件
- [README.md](https://github.com/yunionio/dashboard/tree/master/README.md): 项目介绍
- [.eslintrc.js](https://github.com/yunionio/dashboard/tree/master/.eslintrc.js): ESlint配置文件
- [.travirs.yml](https://github.com/yunionio/dashboard/tree/master/.travirs.yml): Travis CI配置文件
- [babel.config.js](https://github.com/yunionio/dashboard/tree/master/babel.config.js): Babel配置文件
- [Dockerfile](https://github.com/yunionio/dashboard/tree/master/Dockerfile): 构建镜像文件
- [jest.config.js](https://github.com/yunionio/dashboard/tree/master/jest.config.js): 单元测试配合文件



