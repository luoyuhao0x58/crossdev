#! /usr/bin/bash
set -uexo pipefail

REPO=https://github.com/ohmybash/oh-my-bash.git
gitclone $REPO ~/.oh-my-bash

cat <<'EOF' >>~/.bashrc

# oh my bash
export OSH=~/.oh-my-bash
DISABLE_UPDATE_PROMPT=true
DISABLE_AUTO_UPDATE=true
OMB_USE_SUDO=false
completions=(
  git
  ssh
  tmux
  system
  docker
  docker-compose
)
aliases=(
  general
)
plugins=(
  sudo git
)
[ "$SSH_TTY" ] && plugins+=(tmux-autoattach)
EOF

for CONFIG in $(echo $CROSSDEV_BUILD_CONFIGS | xargs -d';'); do
  cfg_type=$(echo $CONFIG | cut -d ':' -f 1)
  if [ "$cfg_type" == "python" ]; then
    echo 'completions+=(pip pip3)' >>~/.bashrc
  elif [ "$cfg_type" == "frontend" ]; then
    echo 'completions+=(nvm npm)' >>~/.bashrc
  fi
done

echo 'source "$OSH/oh-my-bash.sh"' >>~/.bashrc
