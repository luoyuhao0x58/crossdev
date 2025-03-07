#! /usr/bin/bash
set -uexo pipefail

# 构建前端开发环境
VERSIONS=$@
NVM_REPO=https://github.com/nvm-sh/nvm.git

# 安装nvm
export NVM_DIR="$HOME/.nvm" && (
  gitclone "$NVM_REPO" "$NVM_DIR"
  cd "$NVM_DIR"
  git checkout $(git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1))
) && \. "$NVM_DIR/nvm.sh"

# 配置nvm
cat <<EOT >>~/.bashrc

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
EOT

# 安装node
source ~/.bashrc
REGISTRY_MIRROR=https://registry.npmmirror.com
export NVM_NODEJS_ORG_MIRROR=https://mirrors.ustc.edu.cn/node
for VERSION in $VERSIONS; do
  nvm install $VERSION
done
nvm use $VERSION
nvm alias default $VERSION
npm config set registry "$REGISTRY_MIRROR"
npm install -g yarn
npm cache clean --force
nvm cache clear
