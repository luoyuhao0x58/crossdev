#! /bin/bash

CGIT_MIRROR=${CGIT_MIRROR:-"https://ghproxy.com"}

GIT_REPO="$1"
GIT_DIR="$2"
if [ -z $GIT_DIR ]; then
  GIT_DIR=$(basename $GIT_REPO)
  GIT_DIR=${GIT_DIR%.git}
fi
git clone --depth=1 "$CGIT_MIRROR/$GIT_REPO" "$GIT_DIR"
(cd "$GIT_DIR" && git remote set-url origin "$GIT_REPO")
