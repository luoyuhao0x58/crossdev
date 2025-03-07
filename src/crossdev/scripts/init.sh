#! /usr/bin/bash
set -uexo pipefail

APT_MIRROR='mirrors.ustc.edu.cn'
sed -i "s/deb.debian.org/${APT_MIRROR}/g" /etc/apt/sources.list.d/debian.sources
apt-get update -y
apt-get install -y apt-transport-https ca-certificates apt-utils tzdata locales
sed -i "s/http/https/g" /etc/apt/sources.list.d/debian.sources

# configure localisation
echo "${LANG} UTF-8" >/etc/locale.gen
echo "LANG='${LANG}'" >>/etc/default/locale
printf "\nexport LANG=${LANG}\n" >>/etc/profile
ln -fs /usr/share/zoneinfo/$TZ /etc/localtime
dpkg-reconfigure locales tzdata

apt-get update -y
apt-get upgrade -y
apt-get install -y \
  sudo software-properties-common psmisc inotify-tools sysstat \
  netcat-openbsd net-tools iputils-ping lsof dnsutils \
  screen tmux zip unzip unrar-free p7zip-full \
  man-db manpages-dev source-highlight git subversion \
  openssh-server less vim-nox emacs-nox rsync tree jq curl wget telnet file

# configure sudo
sed -i 's/^%sudo.*/%sudo ALL=(ALL:ALL) NOPASSWD:ALL/' /etc/sudoers

# configure git
git config --system core.quotepath false
git config --system color.ui auto
git config --system pull.ff only
git config --system pull.rebase true
git config --system init.defaultbranch main
git config --system credential.helper store

useradd -d $CROSSDEV_USER_HOME -s /bin/bash -g staff -G sudo -N -m -u $CROSSDEV_USER_ID \
  -p $(tr </dev/urandom -dc _A-Z-a-z-0-9 | head -c8) $CROSSDEV_USER_NAME

# copy configure files
rsync -a --ignore-times ./conf/ /
