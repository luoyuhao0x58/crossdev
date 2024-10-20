#! /bin/bash
set -uexo pipefail

# for python mysqlclient lib
sudo apt-get install -y python3-dev default-libmysqlclient-dev build-essential pkg-config

sudo apt-get install -y default-mysql-client