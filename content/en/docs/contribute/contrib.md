---
title: "Code contribution"
weight: 2
description: >
  How to initiate a pull request on GitHub to contribute codes
---

## How to make a Pull Request?

- Checkout a branch from master, either for a new feature or a bugfix

```bash
# checkout new branch
$ git fetch upstream --tags
$ git checkout -b feature/implement-x upstream/master
```

- Coding on the new branch
- After coding is done, do the following to prepare for Pull Request

```bash
$ git fetch upstream         # fetch most up-to-date upstream master
$ git rebase upstream/master # resolv possible conflicts
$ git push origin feature/implement-x # push your local branch to github
```

- Submit Pull Request on GitHub

![](../images/submitPR.png)

- Request reviews, set labels to indicate the impact components of the codes

![](../images/reviewer_label.png)

- You may use comments to appoint reviwers and set labels. Use '/cc' and @<userid> to appoint reviwers, use '/area' to indicate the impact components of the codes.

![](../images/robot_review_label.png)

​	Available labels are listed under issues——Labels, any label prefixed with area can be used for '/area' command.

- If the codes need to be merged into release branch, you should create new cherry-pick PRs to the target release branch.

```bash
# Donwload github command line tool: https://github.com/github/hub
# For OSX, please execute: brew install hub
# For Debian, please execute: sudo apt install hub
# For other OS, please install binaries: https://github.com/github/hub/releases

# Setup username of github
$ export GITHUB_USER=<your_username>

# Use the following scripts to cherry-pick PR to release branch
# For exmaple, to cherry-pick the PR with ID #8 to release/2.8.0
$ ./scripts/cherry_pick_pull.sh upstream/release/2.8.0 8
 
# the cherry pick may have conflicts, please open a new terminal to resolve the conflicts, then input 'Y' to continue the cherry-pick process
$ git add xxx # resolve conflicts
$ git am --continue
# go back to the terminal of cherry-pick, and input 'Y' to continue the cherry-pick process
```

Go to the Pull Requests of upstream [PR](https://github.com/yunionio/yunioncloud/pulls), you will find the cherry-pick PR，the title of the chery-pick PR should look like: `Automated cherry pick of #8: ...`, then procedure the reviwer process and merge the PR to the release branch.


{{% alert title="attention" %}}
Git commit should follow [Git Commit Convention](../git-convention)。
{{% /alert %}}
