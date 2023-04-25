#! /bin/bash
set -uexo pipefail

GIT_REPO=https://github.com/ohmybash/oh-my-bash.git
git clone --depth=1 "https://ghproxy.com/$GIT_REPO" ~/.oh-my-bash
(cd ~/.oh-my-bash && git remote set-url origin "$GIT_REPO")

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
    elif [ "$cfg_type" == "frontend" ]; then
        echo 'completions+=(nvm npm)' >> ~/.bashrc
    fi
done

echo 'source "$OSH/oh-my-bash.sh"' >> ~/.bashrc