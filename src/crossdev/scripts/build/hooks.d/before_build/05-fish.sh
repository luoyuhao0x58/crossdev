#! /usr/bin/bash
set -uexo pipefail

source /etc/os-release
fish_version=4

echo "deb http://download.opensuse.org/repositories/shells:/fish:/release:/${fish_version}/Debian_${VERSION_ID}/ /" | sudo tee /etc/apt/sources.list.d/shells:fish:release:${fish_version}.list
curl -fsSL https://download.opensuse.org/repositories/shells:fish:release:${fish_version}/Debian_${VERSION_ID}/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/shells_fish_release_${fish_version}.gpg >/dev/null
sudo apt update -y
sudo apt install -y fish
