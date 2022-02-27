#! /bin/bash
set -uexo pipefail

VERSIONS=$1

# Python构建环境依赖
sudo apt-get install -y make build-essential libssl-dev zlib1g-dev \
    libbz2-dev libreadline-dev libsqlite3-dev llvm \
    libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

# 安装pyenv
git clone https://github.com/pyenv/pyenv.git ~/.pyenv
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

# 安装python各版本
source ~/.profile
for VERSION in $(echo $VERSIONS | xargs -d',')
do
    pyenv install $VERSION
done
pyenv rehash
pyenv global $VERSION

# 安装poetry
curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python -
source ~/.profile
poetry config virtualenvs.in-project true
