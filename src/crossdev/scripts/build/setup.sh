#! /usr/bin/bash
set -uexo pipefail

sudo apt -y update

# before build
for fname in $(ls "$BUILD_DIR/scripts/build/hooks.d/before_build" | sort); do
  source "$BUILD_DIR/scripts/build/hooks.d/before_build/$fname"
done

# build programming language environment
CONFIGS="cpp:latest;$CROSSDEV_BUILD_CONFIGS"
declare -A configs
for CONFIG in $(echo $CONFIGS | xargs -d';'); do
  type=$(echo $CONFIG | cut -d ':' -f 1)
  versions=$(echo $CONFIG | cut -d ':' -f 2- | sed 's/:/ /')
  configs[$type]=$versions
done
for fname in $(ls "$BUILD_DIR/scripts/build/install.d/" | sort); do
  type=$(echo $fname | cut -d '.' -f 2)
  set +u
  versions="${configs[$type]}"
  set -u
  if [ ! -z "${versions}" ]; then
    /usr/bin/bash -uexo pipefail "$BUILD_DIR/scripts/build/install.d/$fname" $(echo ${versions} | xargs -d',')
  fi
done

# after build
for fname in $(ls "$BUILD_DIR/scripts/build/hooks.d/after_build" | sort); do
  source "$BUILD_DIR/scripts/build/hooks.d/after_build/$fname"
done
