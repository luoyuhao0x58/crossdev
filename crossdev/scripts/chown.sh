#! /bin/bash
set -exo pipefail

NEED_CHANGE_USER_HOME=$(sudo -u $BUILDER bash -c 'echo ~')

if [ ! -z "$UID" ] && [ ! -z "$USER_NAME" ] && [ ! -z "$USER_HOME" ]; then

  GROUP_NAME=${GROUP_NAME:-staff}
  GID=${GID:-$(grep $GROUP_NAME /etc/group | cut -f 3 -d ':')}
  if grep "^$GROUP_NAME:x:$GID:" /etc/group; then
    echo "Group $GROUP_NAME exists..."
  else
    groupadd -g $GID $GROUP_NAME
  fi

  chown -R "$UID:$GID" "$NEED_CHANGE_USER_HOME"
  if [ ! -d "$(dirname $USER_HOME)" ]; then
    mkdir -p "$(dirname $USER_HOME)"
  fi
  mv "$NEED_CHANGE_USER_HOME" "$USER_HOME"

  useradd -d $USER_HOME -s /bin/bash -g $GROUP_NAME -G sudo -N -m -u $UID \
    -p $(tr </dev/urandom -dc _A-Z-a-z-0-9 | head -c8) $USER_NAME
  sudo usermod -aG docker $USER_NAME
  usermod -d /tmp "$BUILDER"

  SUB="s|^${NEED_CHANGE_USER_HOME}|${USER_HOME}|"
  while read fname; do
    if [[ "$(readlink $fname)" == "${NEED_CHANGE_USER_HOME}"* ]]; then
      rpath=$(echo $(readlink $fname) | sed $SUB)
      ln -sf "$rpath" "$fname"
    fi
  done <<<"$(find $USER_HOME -type l)"
  ln -s "$USER_HOME" "$NEED_CHANGE_USER_HOME"
  chown "$UID:$GID" "$NEED_CHANGE_USER_HOME"
fi
