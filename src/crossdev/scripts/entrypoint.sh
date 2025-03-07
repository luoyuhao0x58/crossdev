#! /usr/bin/bash
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

# config git options
if [ ! -z "$CROSSDEV_GIT_AUTHOR_NAME" ]; then
  git config --global user.name "$CROSSDEV_GIT_AUTHOR_NAME"
fi
if [ ! -z "$CROSSDEV_GIT_AUTHOR_EMAIL" ]; then
  git config --global user.email "$CROSSDEV_GIT_AUTHOR_EMAIL"
fi
if [ ! -z "$CROSSDEV_GIT_SIGNINGKEY" ]; then
  git config --global user.signingkey "$CROSSDEV_GIT_SIGNINGKEY"
  git config --global commit.gpgsign true
fi

exec sudo /usr/bin/supervisord -nc /etc/supervisor/supervisord.conf
