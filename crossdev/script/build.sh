#! /bin/bash
set -uexo pipefail

# 设置登录信息
sudo cp $CONFIG_PATH/ascii-art.txt /etc/motd
cat $CONFIG_PATH/fbi-warning.txt | sudo tee -a /etc/motd

cat <<\EOT > /etc/tmux.conf
bind '"' split-window -c "#{pane_current_path}"
bind % split-window -h -c "#{pane_current_path}"
bind c new-window -c "#{pane_current_path}"
EOT

# 配合MAC的用户组ID默认值
groupmod -g 28 dialout  && groupmod -g 20 staff

# 配置用户
if [ ! -z $UID ] && [ ! -z $GID ] && [ ! -z $USER_NAME ] && [ ! -z $GROUP_NAME ] && [ -f "$AUTH_KEY_PATH" ]; then
    if grep "^$GROUP_NAME:" /etc/group ; then
        groupmod -g $GID $GROUP_NAME
    else
        groupadd -g $GID $GROUP_NAME
    fi
    if [[ $USER_HOME != /home/* ]]; then
        DIR=$(dirname $USER_HOME)
        rm -rf /home && mkdir $DIR && ln -sf $DIR /home
    fi
    useradd -d $USER_HOME -s /bin/bash -g $GROUP_NAME -G sudo -N -m -u $UID \
        -p `< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c8` $USER_NAME
    mkdir -p $USER_HOME/.ssh && cp $AUTH_KEY_PATH $USER_HOME/.ssh/authorized_keys
    chown -R "$USER_NAME:$GROUP_NAME" "$USER_HOME" && chmod 700 "$USER_HOME/.ssh" && chmod 600 $USER_HOME/.ssh/*
fi

sudo --preserve-env=GIT_USER_NAME --preserve-env=GIT_USER_MAIL -u $USER_NAME -g $GROUP_NAME /bin/bash -uexo pipefail $CONFIG_PATH/git.sh
sudo -u $USER_NAME -g $GROUP_NAME /bin/bash -uexo pipefail $CONFIG_PATH/docker.sh

for CONFIG in $(echo $CONFIGS | xargs -d';')
do
    cfg_type=$(echo $CONFIG | cut -d ':' -f 1)
    sudo --preserve-env=CONFIG -u $USER_NAME -g $GROUP_NAME /bin/bash -uexo pipefail "$CONFIG_PATH/$cfg_type.sh" $(echo $CONFIG | cut -d ':' -f 2- | sed 's/:/ /')
done

sudo --preserve-env=CONFIGS -u $USER_NAME -g $GROUP_NAME /bin/bash -uexo pipefail $CONFIG_PATH/ohmybash.sh