#!/bin/bash

# site:
#     type: nodejs
#     working_directory: '{INSTALL_PATH}'
#     command: 'node server'
#     nodejs_version: '14'
# database:
#     type: postgresql
# form:
#     email:
#         type: email
#         label: Email
#     admin_password:
#         type: password
#         label: Administrator password
#         min_length: 8
#         max_length: 255
set -e

# https://docs.requarks.io/install/linux

wget https://github.com/Requarks/wiki/releases/download/2.5.219/wiki-js.tar.gz

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
