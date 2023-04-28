#! /bin/bash
set -exo pipefail

keys=($(grep 'HostKey ' /etc/ssh/sshd_config | cut -d' ' -f2))

for key in ${keys[@]}; do
  if [ ! -f "$key" ]; then
    t=$(echo "$key" | cut -d'_' -f3)
    if [[ $t == "rsa" ]]; then
      sudo ssh-keygen -q -N "" -t $t -b 4096 -f $key
    else
      sudo ssh-keygen -q -N "" -t $t -f $key
    fi
    echo "Generated $key"
  fi
done

if [ ! -z "$GIT_AUTHOR_NAME" ]; then
  git config --global user.name "$GIT_AUTHOR_NAME"
fi
if [ ! -z "$GIT_AUTHOR_EMAIL" ]; then
  git config --global user.email "$GIT_AUTHOR_EMAIL"
fi
if [ ! -z "$GIT_SIGNINGKEY" ]; then
  git config --global user.signingkey "$GIT_SIGNINGKEY"
  git config --global commit.gpgsign true
fi

exec sudo /usr/sbin/sshd -D