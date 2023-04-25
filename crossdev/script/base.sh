#! /bin/bash
set -uexo pipefail

source /etc/os-release

MIRROR='mirrors.ustc.edu.cn'

# 因三方镜像仓库经常有同步问题，默认用回官方。

cat <<EOT > /etc/apt/sources.list
deb http://$MIRROR/debian/ $VERSION_CODENAME main contrib non-free
deb-src http://$MIRROR/debian/ $VERSION_CODENAME main contrib non-free

deb http://$MIRROR/debian/ $VERSION_CODENAME-updates main contrib non-free
deb-src http://$MIRROR/debian/ $VERSION_CODENAME-updates main contrib non-free

deb http://$MIRROR/debian-security $VERSION_CODENAME-security main contrib non-free
deb-src http://$MIRROR/debian-security $VERSION_CODENAME-security main contrib non-free
EOT

apt-get update -y
apt-get install -y apt-transport-https ca-certificates

cat <<EOT > /etc/apt/sources.list
deb https://$MIRROR/debian/ $VERSION_CODENAME main contrib non-free
deb-src https://$MIRROR/debian/ $VERSION_CODENAME main contrib non-free

deb https://$MIRROR/debian/ $VERSION_CODENAME-updates main contrib non-free
deb-src https://$MIRROR/debian/ $VERSION_CODENAME-updates main contrib non-free

deb https://$MIRROR/debian-security $VERSION_CODENAME-security main contrib non-free
deb-src https://$MIRROR/debian-security $VERSION_CODENAME-security main contrib non-free
EOT

apt-get update -y
apt-get upgrade -y
apt-get install -y tzdata locales snapd \
  sudo software-properties-common psmisc net-tools iputils-ping lsof dnsutils \
  inotify-tools gnupg2 less vim-tiny zip unzip openssh-server \
  man-db manpages-dev source-highlight git subversion \
  tree tmux jq curl wget httpie telnet file gpa pinentry-tty \
  python3 python3-venv python3-pip
