#! /bin/bash
set -uexo pipefail

VERSIONS=$@

# install python dependence
sudo apt-get install -y make build-essential libssl-dev zlib1g-dev \
  libbz2-dev libreadline-dev libsqlite3-dev llvm \
  libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

export PYTHON_CONFIGURE_OPTS='--disable-gil --enable-experimental-jit'

# install pyenv
GIT_REPO=https://github.com/pyenv/pyenv.git
cgit "$GIT_REPO" ~/.pyenv
mkdir ~/.pyenv/cache/
(cd ~/.pyenv && src/configure && make -C src)

# configure pyenv
sed -Ei -e '/^([^#]|$)/ {a \
export PYENV_ROOT="$HOME/.pyenv"
a \
export PATH="$PYENV_ROOT/bin:$PATH"
a \
' -e ':a' -e '$!{n;ba};}' ~/.profile
echo 'eval "$(pyenv init --path)"' >>~/.profile

cat <<\EOT >>~/.bashrc

if command -v pyenv >/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi
EOT

cat <<\EOT >~/.pyenv/bin/pyinstall
#! /bin/bash
PY_MIRROR=${PY_MIRROR:-"https://npmmirror.com/mirrors"}
function fn() {
  v=$1
  echo "Install Python $v from Taobao Mirror:"
  curl -L "$PY_MIRROR/python/$v/Python-$v.tar.xz" -o ~/.pyenv/cache/Python-$v.tar.xz
  pyenv install $v
}
fn $1
EOT
chmod a+x ~/.pyenv/bin/pyinstall

# install python
source ~/.profile
for VERSION in $VERSIONS; do
  pyinstall $VERSION
done
pyenv rehash
pyenv global $VERSION

# install poetry
PYPI_MIRROR=${PYPI_MIRROR:-"https://mirrors.ustc.edu.cn/pypi/web/simple"}
python -m pip config set global.index-url "$PYPI_MIRROR"
python -m pip install pipx
python -m pipx install poetry

# configure poetry
source ~/.profile
poetry config virtualenvs.in-project true

# clear
python -m pip cache purge
rm -rf ~/.pyenv/cache/*
