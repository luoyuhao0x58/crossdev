#! /bin/bash
set -uexo pipefail

git clone https://github.com/ohmybash/oh-my-bash.git ~/.oh-my-bash

cat <<\EOT >> ~/.bashrc

# oh my bash
export OSH=~/.oh-my-bash
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
  git
)
[ "$SSH_TTY" ] && plugins+=(tmux-autoattach)
EOT

for CONFIG in $(echo $CONFIGS | xargs -d';')
do
    cfg_type=$(echo $CONFIG | cut -d ':' -f 1)
    if [ "$cfg_type" == "python" ]; then
        echo 'completions+=(pip pip3)' >> ~/.bashrc
    fi
done

echo 'source "$OSH/oh-my-bash.sh"' >> ~/.bashrc