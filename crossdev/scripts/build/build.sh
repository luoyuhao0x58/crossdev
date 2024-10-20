#! /bin/bash
set -uexo pipefail

BUILD_DIR=/tmp/build

sudo apt -y update

# before build
for fname in $(ls "$BUILD_DIR/hooks.d/before_build" | sort); do
  source "$BUILD_DIR/hooks.d/before_build/$fname"
done

# build programming language environment
CONFIGS="cpp:latest;$CONFIGS"
declare -A configs
for CONFIG in $(echo $CONFIGS | xargs -d';'); do
  type=$(echo $CONFIG | cut -d ':' -f 1)
  versions=$(echo $CONFIG | cut -d ':' -f 2- | sed 's/:/ /')
  configs[$type]=$versions
done
for fname in $(ls "$BUILD_DIR/conf.d/" | sort); do
  type=$(echo $fname | cut -d '.' -f 2)
  set +u
  versions="${configs[$type]}"
  set -u
  if [ ! -z "${versions}" ]; then
    /bin/bash -uexo pipefail "$BUILD_DIR/conf.d/$fname" $(echo ${versions} | xargs -d',')
  fi
done

# after build
for fname in $(ls "$BUILD_DIR/hooks.d/after_build" | sort); do
  source "$BUILD_DIR/hooks.d/after_build/$fname"
done
