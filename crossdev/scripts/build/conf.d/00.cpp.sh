#! /bin/bash
set -uexo pipefail

sudo wget https://apt.llvm.org/llvm.sh
sudo chmod +x llvm.sh
sudo ./llvm.sh 18 && sudo rm llvm.sh
sudo apt -y install build-essential manpages-dev
