#! /bin/bash
set -uexo pipefail

source /etc/os-release

cat <<EOT >/etc/apt/sources.list
deb http://$APT_MIRROR/debian/ $VERSION_CODENAME main contrib non-free
deb-src http://$APT_MIRROR/debian/ $VERSION_CODENAME main contrib non-free

deb http://$APT_MIRROR/debian/ $VERSION_CODENAME-updates main contrib non-free
deb-src http://$APT_MIRROR/debian/ $VERSION_CODENAME-updates main contrib non-free

deb http://$APT_MIRROR/debian-security $VERSION_CODENAME-security main contrib non-free
deb-src http://$APT_MIRROR/debian-security $VERSION_CODENAME-security main contrib non-free
EOT

apt-get update -y
apt-get install -y apt-transport-https ca-certificates

cat <<EOT >/etc/apt/sources.list
deb https://$APT_MIRROR/debian/ $VERSION_CODENAME main contrib non-free
deb-src https://$APT_MIRROR/debian/ $VERSION_CODENAME main contrib non-free

deb https://$APT_MIRROR/debian/ $VERSION_CODENAME-updates main contrib non-free
deb-src https://$APT_MIRROR/debian/ $VERSION_CODENAME-updates main contrib non-free

deb https://$APT_MIRROR/debian-security $VERSION_CODENAME-security main contrib non-free
deb-src https://$APT_MIRROR/debian-security $VERSION_CODENAME-security main contrib non-free
EOT

apt-get update -y
apt-get upgrade -y
apt-get install -y tzdata locales \
  sudo software-properties-common psmisc net-tools iputils-ping lsof dnsutils \
  inotify-tools less vim-nox zip unzip unrar p7zip-full screen \
  openssh-server man-db manpages-dev source-highlight git \
  tree tmux jq curl wget telnet file netcat-openbsd sysstat

# configure localisation
echo "${LANG} UTF-8" >/etc/locale.gen
echo "${LANG}" >>/etc/default/locale
printf "\nexport LANG=${LANG}\n" >>/etc/profile
ln -fs /usr/share/zoneinfo/$TZ /etc/localtime
dpkg-reconfigure locales tzdata

# configure sudo
sed -i 's/^%sudo.*/%sudo ALL=(ALL:ALL) NOPASSWD:ALL/' /etc/sudoers

# configure git
git config --system core.quotepath false
git config --system color.ui auto
git config --system pull.ff only
git config --system pull.rebase true
git config --system init.defaultbranch master
git config --system credential.helper store

useradd -d $BUILDER_HOME -s /bin/bash -g staff -G sudo -N -m -u $BUILDER_ID \
  -p $(tr </dev/urandom -dc _A-Z-a-z-0-9 | head -c8) $BUILDER
