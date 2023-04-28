#! /bin/bash
set -uexo pipefail

BUILD_DIR=/tmp/build

# use for mount vscode remote ssh volume
mkdir ~/.vscode-server

# configure ssh
mkdir -p ~/.ssh && touch ~/.ssh/authorized_keys
chmod 700 ~/.ssh && chmod 600 ~/.ssh/*

# speed up git
sudo mv /tmp/build/cgit.sh /usr/local/bin/cgit

sudo apt -y update

# install docker
source /tmp/build/docker.sh

# build tools
CONFIGS="cpp:latest;$CONFIGS"
declare -A configs
for CONFIG in $(echo $CONFIGS | xargs -d';'); do
  type=$(echo $CONFIG | cut -d ':' -f 1)
  versions=$(echo $CONFIG | cut -d ':' -f 2- | sed 's/:/ /')
  configs[$type]=$versions
done
for fname in $(ls "$BUILD_DIR/conf.d/" | sort); do
  type=$(echo $fname | cut -d '.' -f 2)
  set +u
  versions="${configs[$type]}"
  set -u
  if [ ! -z "${versions}" ]; then
    /bin/bash -uexo pipefail "$BUILD_DIR/conf.d/$fname" $(echo ${versions} | xargs -d',')
  fi
done

# configure gnupg
rm -rf ~/.gnupg && mkdir ~/.gnupg
printf 'pinentry-program /usr/bin/pinentry\ndefault-cache-ttl 604800\nmax-cache-ttl 604800\n' >~/.gnupg/gpg-agent.conf
chmod 700 ~/.gnupg && chmod 600 ~/.gnupg/gpg-agent.conf

source "$BUILD_DIR/ohmybash.sh"
