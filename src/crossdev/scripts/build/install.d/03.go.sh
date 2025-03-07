#! /usr/bin/bash
set -uexo pipefail

VERSIONS=$@

gitclone https://github.com/go-nv/goenv.git ~/.goenv

cat <<'EOF' >>~/.profile

export GOPROXY=https://proxy.golang.com.cn,direct
export GOENV_ROOT="$HOME/.goenv"
export PATH="$GOENV_ROOT/bin:$PATH"
eval "$(goenv init -)"
export PATH="$GOROOT/bin:$PATH:$GOPATH/bin"
EOF

set +u
source ~/.profile
set -u

GO_BUILD_MIRROR_URL='https://mirrors.ustc.edu.cn/golang'
sed -i "s|https://go.dev/dl|$GO_BUILD_MIRROR_URL|" ~/.goenv/plugins/go-build/bin/go-build
for VERSION in $VERSIONS; do
  goenv install $VERSION
done
goenv global $VERSION
