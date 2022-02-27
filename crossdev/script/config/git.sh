#! /bin/bash
set -uexo pipefail

# 配置Git
if [ ! -z "$GIT_USER_NAME" ] && [ ! -z $GIT_USER_MAIL ]; then
    git config --global user.name "${GIT_USER_NAME}"
    git config --global user.email ${GIT_USER_MAIL}
    git config --global core.quotepath false
    git config --global color.ui auto
    git config --global pull.ff only
    git config --global init.defaultbranch master
else
    exit 1
fi