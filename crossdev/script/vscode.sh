#! /bin/bash
set -uexo pipefail

if [ -z "$VSCODE_VERSION" ]; then
    exit
fi

VSCODE_SERVER="https://update.code.visualstudio.com/commit:${VSCODE_VERSION}/server-linux-$(dpkg --print-architecture)/stable"
wget --tries=1 --connect-timeout=7 --dns-timeout=7 -nv -O ~/vscode-server.tar.gz $VSCODE_SERVER
mkdir -vp ~/.vscode-server/bin/${VSCODE_VERSION}
tar --no-same-owner -xzv --strip-components=1 -C ~/.vscode-server/bin/"${VSCODE_VERSION}" -f ~/vscode-server.tar.gz
rm -rf ~/vscode-server.tar.gz