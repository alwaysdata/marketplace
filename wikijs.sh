#!/bin/bash

# Declare site in YAML, as documented on the documentation: https://help.alwaysdata.com/en/marketplace/build-application-script/
# site:
#     type: nodejs
#     working_directory: '{INSTALL_PATH}'
#     command: 'node server'
#     nodejs_version: '20'
# database:
#     type: postgresql
# requirements:
#     disk: 420

set -e

# https://docs.requarks.io/install/linux
# https://docs.requarks.io/install/requirements#nodejs

# Download
wget --no-hsts https://github.com/Requarks/wiki/releases/download/v2.5.300/wiki-js.tar.gz

tar xzf wiki-js.tar.gz -C .
rm wiki-js.tar.gz

# Configuration
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
