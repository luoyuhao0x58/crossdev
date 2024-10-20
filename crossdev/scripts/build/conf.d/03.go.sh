#! /bin/bash
set -uexo pipefail

VERSIONS=$@

PF_PATH=~/.profile
GOPROXY=https://proxy.golang.com.cn,direct
cgit https://github.com/syndbg/goenv.git ~/.goenv
echo "export GOPROXY=$GOPROXY" >>"$PF_PATH"
echo 'export GOENV_ROOT="$HOME/.goenv"' >>"$PF_PATH"
echo 'export PATH="$GOENV_ROOT/bin:$PATH"' >>"$PF_PATH"
echo 'eval "$(goenv init -)"' >>"$PF_PATH"
echo 'export PATH="$GOROOT/bin:$PATH:$GOPATH/bin"' >>"$PF_PATH"

set +u
source "$PF_PATH"
set -u

sed -i 's|https://go.dev/dl|https://mirrors.ustc.edu.cn/golang|' ~/.goenv/plugins/go-build/bin/go-build
for VERSION in $VERSIONS; do
  goenv install $VERSION
done
goenv global $VERSION