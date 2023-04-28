#! /bin/bash
set -uexo pipefail

# 安装依赖
sudo apt-get -y install \
  ca-certificates \
  curl \
  gnupg \
  lsb-release

curl -fsSL https://mirrors.ustc.edu.cn/docker-ce/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://mirrors.ustc.edu.cn/docker-ce/linux/debian \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null

sudo apt-get update
sudo apt-get -y install docker-ce-cli

COMPOSE_VERSION=2.17.3
sudo curl -SL "https://ghproxy.com/https://github.com/docker/compose/releases/download/v${COMPOSE_VERSION}/docker-compose-linux-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod a+x /usr/local/bin/docker-compose

sudo groupadd -g 997 docker
sudo usermod -aG docker $(id -nu)
