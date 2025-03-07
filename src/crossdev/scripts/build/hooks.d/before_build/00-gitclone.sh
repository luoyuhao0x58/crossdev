#! /usr/bin/bash
set -uexo pipefail

cat <<'EOF' >/tmp/gitclone
#! /usr/bin/bash

GIT_MIRROR=${GIT_MIRROR:-"https://gh.llkk.cc"}
GIT_REPO="$1"
GIT_DIR="$2"

if [ -z $GIT_DIR ]; then
  GIT_DIR=$(basename $GIT_REPO)
  GIT_DIR=${GIT_DIR%.git}
fi

if [ -z "$STABLE_NETWORK" ]; then
  git clone --depth=1 "$GIT_MIRROR/$GIT_REPO" "$GIT_DIR"
  (cd "$GIT_DIR" && git remote set-url origin "$GIT_REPO")
  exit
else
  exec git clone --depth=1 "$GIT_REPO" "$GIT_DIR"
fi
EOF

sudo chmod a+x /tmp/gitclone
sudo mv /tmp/gitclone /usr/local/bin/gitclone
