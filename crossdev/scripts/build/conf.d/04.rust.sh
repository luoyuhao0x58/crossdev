#! /bin/bash
set -uexo pipefail

VERSIONS=$@

export RUSTUP_DIST_SERVER=https://mirrors.ustc.edu.cn/rust-static
export RUSTUP_UPDATE_ROOT=https://mirrors.ustc.edu.cn/rust-static/rustup

curl -sSfL https://mirrors.ustc.edu.cn/misc/rustup-install.sh | bash -s -- -y

PF_PATH=~/.profile
echo "RUSTUP_DIST_SERVER='${RUSTUP_DIST_SERVER}'" >>"$PF_PATH"
echo "RUSTUP_UPDATE_ROOT='${RUSTUP_UPDATE_ROOT}'" >>"$PF_PATH"
echo 'export PATH="$HOME/.cargo/bin:$PATH"' >>"$PF_PATH"

mkdir -p ~/.cargo
echo '[source.crates-io]
replace-with = 'ustc'

[source.ustc]
registry = "sparse+https://mirrors.ustc.edu.cn/crates.io-index/"
' >~/.cargo/config

set +u
source "$PF_PATH"
set -u

for VERSION in $VERSIONS; do
  rustup install $VERSION
done
rustup default $VERSION
