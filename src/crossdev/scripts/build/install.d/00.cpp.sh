#! /bin/bash
set -uexo pipefail

set +u
VERSION=18
if [ -z "$STABLE_NETWORK" ]; then
  LLVM_MIRROR=https://mirrors.zju.edu.cn/llvm-apt
  sudo wget -4 "${LLVM_MIRROR}/llvm.sh"
  sudo chmod +x llvm.sh
  sudo ./llvm.sh $VERSION -m "$LLVM_MIRROR"
else
  sudo wget https://apt.llvm.org/llvm.sh
  sudo chmod +x llvm.sh
  sudo ./llvm.sh $VERSION
fi
set -u
sudo rm llvm.sh

sudo apt -y install build-essential manpages-dev
