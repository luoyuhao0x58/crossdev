#! /bin/bash

cat <<\EOF >/tmp/cgit
#! /bin/bash

GIT_REPO="$1"
GIT_DIR="$2"

if [ -z "$ENABLE_GIT_MIRROR" ]; then
  git clone --depth=1 "$GIT_REPO" "$GIT_DIR"
  exit
fi

CGIT_MIRROR=${CGIT_MIRROR:-"https://mirror.ghproxy.com"}

if [ -z $GIT_DIR ]; then
  GIT_DIR=$(basename $GIT_REPO)
  GIT_DIR=${GIT_DIR%.git}
fi
git clone --depth=1 "$CGIT_MIRROR/$GIT_REPO" "$GIT_DIR"
(cd "$GIT_DIR" && git remote set-url origin "$GIT_REPO")
EOF

sudo chmod a+x /tmp/cgit
sudo cp /tmp/cgit /usr/local/bin/cgit && rm -f /tmp/cgit