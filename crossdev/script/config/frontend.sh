#! /bin/bash
set -uexo pipefail

# 构建前端开发环境
VERSIONS=$1
GIT_REPO=https://github.com/nvm-sh/nvm.git
MPM_MIRROR=https://npmmirror.com/mirrors/npm/
NODE_MIRROR=https://npmmirror.com/mirrors/node/

# 安装nvm
export NVM_DIR="$HOME/.nvm" && (
  git clone --depth=1 "https://ghproxy.com/$GIT_REPO" "$NVM_DIR"
  cd "$NVM_DIR"
  git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)`
  git remote set-url origin "$GIT_REPO"
) && \. "$NVM_DIR/nvm.sh"

# 配置nvm
cat <<EOT >> ~/.bashrc

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
EOT

# 安装node
source ~/.bashrc
# nvm npm_mirror "$MPM_MIRROR"
# nvm node_mirror "$NODE_MIRROR"
for VERSION in $(echo $VERSIONS | xargs -d',')
do
    nvm install $VERSION
done
nvm use $VERSION
npm install -g yarn