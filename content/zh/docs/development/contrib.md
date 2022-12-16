---
title: "提交贡献代码"
weight: 2
edition: ce
description: >
  介绍 github 发起 pull requests 和提交代码的流程
---

## Fork 仓库

访问 https://github.com/yunionio/cloudpods ，将仓库 fork 到自己的 github 用户下。

## Clone 源码

clone 自己 fork 的仓库，并设置 upstream 为源仓库。

```bash
$ git clone https://github.com/<your_name>/cloudpods
$ cd cloudpods
$ git remote add upstream https://github.com/yunionio/cloudpods
```

## 提交代码流程

### 1. 从 master checkout 出 feature 或者 bugfix 分支

```bash
# checkout 新分支
$ git fetch upstream --tags

# 下面假设新的分支名为 'feature/implement-x'
# 分支名应该有语义性，描述这次开发要实现或者修复什么
$ git checkout -b feature/implement-x upstream/master
```

### 2. 在新的分支上进行开发

所有的代码修改，都在新的分支上进行。

如果不熟悉 git 相关的操作，可参考这个文档先学习 git 的基本操作：[Git-Tutorials](https://github.com/twtrubiks/Git-Tutorials)。

### 3. 开发完成后，进行提交PR前的准备操作

```bash
# 同步远程 upstream master 代码
$ git fetch upstream         

# 有冲突则解决冲突
$ git rebase upstream/master 

# push 分支到自己的 repo
$ git push origin feature/implement-x 
```

### 4. 在GitHub的Web界面完成提交PR的流程

![](../images/submitPR.png)

- 提完 PR 后请求相关开发人员 review，并设置Labels来表明提交的代码属于哪一个模块或者哪几个模块

![](../images/reviewer_label.png)

- 或者通过添加评论的方式来完成上一步；评论 "/cc" 并 @ 相关人员完成设置reviewer，评论/area 并填写label完成设置Labels

![](../images/robot_review_label.png)

​	所有Label都可以在issues——Labels下查询到，带area/前缀的Label均可以使用评论"/area"的形式添加

### 5. cherry-pick 代码

如果是 bugfix 或者需要合并到之前 release 分支的 feature PR，需要额外使用脚本将此PR cherry-pick 到对应的 release 分支

```bash
# 自行下载安装 github 的 cli 工具：https://github.com/github/hub
# macOS 使用: brew install hub
# Debian: sudo apt install hub
# 二进制安装: https://github.com/github/hub/releases

# 设置github的用户名
# 可已把该环境变量放到 ~/.bashrc 里面，如果使用的 zsh 则放到 ~/.zshrc 里面
$ export GITHUB_USER=<your_username>

# 使用脚本自动 cherry-pick PR 到 release 分支
# 比如现在有一个提交的PR的编号为18，要把它合并到 release/3.4
$ ./scripts/cherry_pick_pull.sh upstream/release/3.4 18
 
# cherry pick 可能会出现冲突，冲突时开另外一个 terminal，解决好冲突，再输入 'y' 进行提交
$ git add xxx # 解决完冲突后
$ git am --continue
# 回到执行 cherry-pick 脚本的 terminal 输入 'y' 即可
```

去 upstream 的 [PR 页面](https://github.com/yunionio/cloudpods/pulls), 就能看到自动生成的 cherry-pick PR，上面操作的PR的标题前缀就应该为：`Automated cherry pick of #18`，然后重复 PR review 流程合并到 release


{{% alert title="注意" %}}
提交 git 代码后需要书写 commit 内容，规范请参考: [Git 提交内容规范](../git-convention)。
{{% /alert %}}

## 开发效率提升推荐配置

上述的提 PR 流程使用到了很多命令行操作，特别是在执行 `./scripts/cherry_pick_pull.sh` 脚本的时候会输入很多字符。以及每次执行该脚本都需要输入 github 的 token。重复执行这些操作会让人觉得浪费时间。

下面提供一些配置和工具，可以提升一些命令行下的开发效率，请根据自己的实际需要选择配置。

### 避免每次输入 github 认证信息

每次 push 代码或者执行 cherry_pick_pull.sh 脚本的时候，都需要输入 github 账号和 token，可以配置 git credential cache 缓存输入的认证信息。

```bash
# tells Git to keep your password cached in memory for a particular amount of minutes
$ git config --global credential.helper "cache --timeout=86400"
```

另外如果想实现 github 自动登陆，可以创建 `~/.netrc` 文件，里面配置 github 用户名和 token。

```bash
$ cat ~/.netrc
machine github.com
login $github_user
password $github_token
```

### 提升命令重复输入效率

在 shell 里面重复输入命令，可以通过'上键'或者'Ctrl-p' 输入上一条执行过的命令。

另外一个好用的功能是输入 'Ctrl-r' 就会进入 shell 的已输入命令查找模式，然后在这个模式里面输入之前命令的关键字，就可以进行查找。如果不匹配重复按 'Ctrl-r' 就会继续找，找到想要的命令后，按下 'Enter' 就可以重复输入之前输入的命令。合理的使用 'Ctrl-r' 可以极大的提升重复相关命令的输入效率。

另外推荐安装一个不错的命令行模糊查找工具(command-line fuzzy finder)，叫做 [fzf](https://github.com/junegunn/fzf) ，参考该文档安装 [fzf installation](https://github.com/junegunn/fzf#installation)。安装配置完该工具后，再使用 'Ctrl-r' ，就会进入一个命令行模糊查找的模式，比 shell 自带的 'Ctrl-r' 命令查找要好用。

另外关于命令行下的使用思想，非常建议阅读这篇文章：[The Art of Command Line](https://github.com/jlevy/the-art-of-command-line)。

### 美化 shell

在 linux 和 macOS 系统自带的 shell 默认是 bash，进入 git 代码仓库，$PS1 是没有显示 git branch 等信息的，可以使用下面的方式美化系统的 shell，提供更舒适的命令行操作体验。

下面提供2种方式美化 shell ，请根据自己需要选择其一就行：

1. bash + [oh-my-bash](https://github.com/ohmybash/oh-my-bash) 的方式
    - 系统自带 bash，所以只需要参考 [oh-my-bash 安装文档](https://github.com/ohmybash/oh-my-bash#getting-started)配置即可。

2. zsh + [ohmyzsh](https://github.com/ohmyzsh/ohmyzsh)：这种方式需要安装 zsh 和 ohmyzsh 插件，zsh 和 bash 类似都是 shell ，但提供更丰富的特性，结合 ohmyzsh 插件使用是很多开发者的选择
    - zsh 安装参考文档: [安装 zsh](https://github.com/ohmyzsh/ohmyzsh/wiki/Installing-ZSH)
    - ohmyzsh 插件安装参考: [安装 ohmyzsh](https://github.com/ohmyzsh/ohmyzsh#basic-installation)
    - 另外需要注意的是 zsh 的默认配置文件在 `~/.zshrc`，如果之前在 `~/.bashrc` 里面加了一些环境变量，需要迁移到 `~/.zshrc` 里面。
