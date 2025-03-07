#! /usr/bin/bash
set +u -exo pipefail

VERSIONS=$@
GEM_MIRROR=https://mirrors.aliyun.com/rubygems/

gpg --keyserver keyserver.ubuntu.com --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
gitclone https://github.com/rvm/rvm.git /tmp/rvm
sed "s|DEFAULT_SOURCES=(github.com/rvm/rvm bitbucket.org/mpapis/rvm)|DEFAULT_SOURCES=(bitbucket.org/mpapis/rvm)|" /tmp/rvm/binscripts/rvm-installer | bash -s stable
echo "ruby_url=https://cache.ruby-china.com/pub/ruby" >>~/.rvm/user/db

source ~/.bash_profile

for VERSION in $VERSIONS; do
  rvm install $VERSION
done
rvm use $VERSION --default
gem sources --remove "$(gem sources | tail -n 1)"
gem sources -a "$GEM_MIRROR"
