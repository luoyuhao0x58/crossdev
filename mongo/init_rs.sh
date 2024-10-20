#! /bin/bash

mongo <<EOF
use admin
db.auth("${MONGO_INITDB_ROOT_USERNAME}", "${MONGO_INITDB_ROOT_PASSWORD}")
rs.initiate()
EOF