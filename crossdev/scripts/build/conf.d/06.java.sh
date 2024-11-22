#! /bin/bash
set -uexo pipefail

VERSIONS=$@

cgit https://github.com/jenv/jenv.git ~/.jenv
echo 'export PATH="$HOME/.jenv/bin:$PATH"' >>~/.profile
echo 'eval "$(jenv init -)"' >>~/.profile

cat <<'EOF' >"$HOME/install_jvm.sh"
VERSIONS=$@
jenv enable-plugin export

JAVA_ROOT_PATH=/opt/java/jvm
sudo mkdir -p $JAVA_ROOT_PATH
function jinstall() {
  v=$1
  echo "Install Java SDK $v from Huawei Mirror:"
  m=$(uname -m)
  if [[ "$m" == 'x86_64' ]]; then
    m=x64
  fi
  fpath="/tmp/java.tar.gz"
  curl -L "https://repo.huaweicloud.com/openjdk/$v/openjdk-${v}_linux-${m}_bin.tar.gz" -o "$fpath"
  home=$(sudo tar xvf "$fpath" -C "${JAVA_ROOT_PATH}/" | sed -e 's@/.*@@' | uniq)
  jenv add "$JAVA_ROOT_PATH/$home" && rm -rf "$fpath"
}

for VERSION in $VERSIONS; do
  jinstall $VERSION
done
jenv global $VERSION

EOF

(bash -l "$HOME/install_jvm.sh" $VERSIONS)
rm -rf "$HOME/install_jvm.sh"