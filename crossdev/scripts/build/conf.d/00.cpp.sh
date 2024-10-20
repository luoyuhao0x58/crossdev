#! /bin/bash
set -uexo pipefail

wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | gpg --dearmor | sudo tee /etc/apt/keyrings/apt.llvm.org.gpg
cat <<\EOT >/tmp/apt.llvm.org.sources
Types: deb
URIs: https://apt.llvm.org/bookworm/
Suites: llvm-toolchain-bookworm llvm-toolchain-bookworm-18 llvm-toolchain-bookworm-17 llvm-toolchain-bookworm-16
Components: main
Signed-By: /etc/apt/keyrings/apt.llvm.org.gpg
EOT
sudo cp /tmp/apt.llvm.org.sources /etc/apt/sources.list.d/ && rm /tmp/apt.llvm.org.sources
sudo apt update
sudo apt -y install build-essential manpages-dev clang-18
