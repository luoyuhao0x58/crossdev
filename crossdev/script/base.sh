#! /bin/bash
set -uexo pipefail

source /etc/os-release

cat <<EOT > /etc/apt/sources.list
deb http://mirrors.163.com/debian/ $VERSION_CODENAME main contrib non-free
deb-src http://mirrors.163.com/debian/ $VERSION_CODENAME main contrib non-free

deb http://mirrors.163.com/debian/ $VERSION_CODENAME-updates main contrib non-free
deb-src http://mirrors.163.com/debian/ $VERSION_CODENAME-updates main contrib non-free

deb http://mirrors.163.com/debian-security $VERSION_CODENAME-security main contrib non-free
deb-src http://mirrors.163.com/debian-security $VERSION_CODENAME-security main contrib non-free
EOT

apt-get update -y
apt-get install -y apt-transport-https ca-certificates

cat <<EOT > /etc/apt/sources.list
deb https://mirrors.163.com/debian/ $VERSION_CODENAME main contrib non-free
deb-src https://mirrors.163.com/debian/ $VERSION_CODENAME main contrib non-free

deb https://mirrors.163.com/debian/ $VERSION_CODENAME-updates main contrib non-free
deb-src https://mirrors.163.com/debian/ $VERSION_CODENAME-updates main contrib non-free

deb https://mirrors.163.com/debian-security $VERSION_CODENAME-security main contrib non-free
deb-src https://mirrors.163.com/debian-security $VERSION_CODENAME-security main contrib non-free
EOT

apt-get update -y
apt-get upgrade -y
apt-get install -y tzdata locales snapd \
  sudo software-properties-common psmisc net-tools iputils-ping lsof dnsutils \
  inotify-tools gnupg2 less vim-tiny zip unzip openssh-server \
  man-db manpages-dev source-highlight git subversion \
  tree tmux jq curl wget httpie telnet file