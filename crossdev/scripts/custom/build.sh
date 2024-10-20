#! /bin/bash
set -uexo pipefail

BUILD_DIR=/tmp/custom

for fname in $(ls "$BUILD_DIR/conf.d/" | sort); do
  source "$BUILD_DIR/conf.d/$fname"
done
