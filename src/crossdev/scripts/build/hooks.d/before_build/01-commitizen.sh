#! /usr/bin/bash
set -uexo pipefail

sudo apt-get install -y python3-pip pipx

# set default mirror
PYPI_MIRROR=${PYPI_MIRROR:-"https://mirrors.aliyun.com/pypi/web/simple"}
python3 -m pip config set global.index-url "$PYPI_MIRROR"

pipx ensurepath
pipx install commitizen
