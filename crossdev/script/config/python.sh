#! /bin/bash
set -uexo pipefail

VERSIONS=$1
GIT_REPO=https://github.com/pyenv/pyenv.git

# Python构建环境依赖
sudo apt-get install -y make build-essential libssl-dev zlib1g-dev \
    libbz2-dev libreadline-dev libsqlite3-dev llvm \
    libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

# 安装pyenv
git clone --depth=1 "https://ghproxy.com/$GIT_REPO" ~/.pyenv
(cd ~/.pyenv && git remote set-url origin "$GIT_REPO")
mkdir ~/.pyenv/cache/
(cd ~/.pyenv && src/configure && make -C src)

# 配置pyenv
sed -Ei -e '/^([^#]|$)/ {a \
export PYENV_ROOT="$HOME/.pyenv"
a \
export PATH="$PYENV_ROOT/bin:$PATH"
a \
' -e ':a' -e '$!{n;ba};}' ~/.profile
echo 'eval "$(pyenv init --path)"' >>~/.profile
cat <<\EOT >> ~/.bashrc

if command -v pyenv >/dev/null 2>&1; then
    eval "$(pyenv init -)"
fi
EOT

function pyinstall() {
    v=$1
    echo "Install Python $v from Taobao Mirror:"
    curl -L https://npmmirror.com/mirrors/python/$v/Python-$v.tar.xz -o ~/.pyenv/cache/Python-$v.tar.xz
    pyenv install $v
}

# 安装python各版本
source ~/.profile
for VERSION in $(echo $VERSIONS | xargs -d',')
do
    pyinstall $VERSION
done
pyenv rehash
pyenv global $VERSION

# 安装poetry
python -m pip config set global.index-url https://mirrors.ustc.edu.cn/pypi/web/simple
python -m pip install pipx
python -m pipx install poetry
source ~/.profile
poetry config virtualenvs.in-project true
