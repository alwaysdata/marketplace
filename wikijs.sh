#!/bin/bash

# site:
#     type: nodejs
#     working_directory: '{INSTALL_PATH}'
#     command: 'node server'
#     nodejs_version: '16'
# database:
#     type: postgresql
# requirements:
#     disk: 370

set -e

# https://docs.requarks.io/install/linux

wget https://github.com/Requarks/wiki/releases/download/2.5.268/wiki-js.tar.gz

tar xzf wiki-js.tar.gz -C .
rm wiki-js.tar.gz

cat << EOF > config.yml
### https://docs.requarks.io/install/config
#

port: $PORT
bindIP: ''

db:
  type: postgres
  host: $DATABASE_HOST
  port: 5432
  user: $DATABASE_USERNAME
  pass: $DATABASE_PASSWORD
  db: $DATABASE_NAME
EOF

# The rest is GUI
