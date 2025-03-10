#! /bin/bash
set -uexo pipefail

VERSIONS=$@

# install python dependence
# llvm installed by 00.cpp.sh
sudo apt-get install -y make build-essential libssl-dev zlib1g-dev \
  libbz2-dev libreadline-dev libsqlite3-dev \
  libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev \
  libbluetooth-dev uuid-dev

arch="$(dpkg-architecture --query DEB_BUILD_ARCH)"
export CC=clang-18
export PYTHON_CFLAGS='-march=native -mtune=native'
BASE_PYTHON_CONFIGURE_OPTS="--enable-loadable-sqlite-extensions --enable-optimizations --enable-option-checking=fatal --with-lto --with-ensurepip --enable-shared"

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

cat <<\EOF >>~/.bashrc

if command -v pyenv >/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi
EOF

cat <<\EOF >~/.pyenv/bin/pyinstall
#! /bin/bash
PY_MIRROR=${PY_MIRROR:-"https://npmmirror.com/mirrors"}
function fn() {
  v=$1
  echo "Install Python $v from Taobao Mirror:"
  curl -L "$PY_MIRROR/python/$v/Python-$v.tar.xz" -o ~/.pyenv/cache/Python-$v.tar.xz
  export PYTHON_CONFIGURE_OPTS="$BASE_PYTHON_CONFIGURE_OPTS"
  if [[ "$v" > "3.13" ]]; then
      export PYTHON_CONFIGURE_OPTS="$PYTHON_CONFIGURE_OPTS --disable-gil"
      if [[ "$arch" == "amd64" ]]; then
        export PYTHON_CONFIGURE_OPTS="$PYTHON_CONFIGURE_OPTS --enable-experimental-jit"
      fi
  fi
  pyenv install $v
}
fn $1
EOF
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
