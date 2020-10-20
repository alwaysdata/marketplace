#!/bin/bash

# site:
#     type: nodejs
#     working_directory: '{INSTALL_PATH}'
#     command: 'node server'
#     nodejs_version: '14'
# database:
#     type: postgresql

set -e

## Buster IPv6 detection
if [ $(head -c1 /etc/debian_version) -eq 8 ]
then
    export IP='0.0.0.0'
else
    export IP=''
fi

# https://docs.requarks.io/install/linux

wget https://github.com/Requarks/wiki/releases/download/2.5.159/wiki-js.tar.gz

tar xzf wiki-js.tar.gz -C .
rm wiki-js.tar.gz

cat << EOF > config.yml
### https://docs.requarks.io/install/config
#

port: $PORT
bindIP: '$IP'

db:
  type: postgres
  host: $DATABASE_HOST
  port: 5432
  user: $DATABASE_USERNAME
  pass: $DATABASE_PASSWORD
  db: $DATABASE_NAME
EOF
