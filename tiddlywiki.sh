#!/bin/bash

# site:
#     type: nodejs
#     working_directory: '{INSTALL_PATH}'
#     nodejs_version: '10'
#     command: '.npm-packages/bin/tiddlywiki ~{INSTALL_PATH_RELATIVE} --listen host=0.0.0.0 port=$PORT credentials=users.csv "readers=(authenticated)" "writers={FORM_USERNAME}"'
#     path_trim: true
#     ssl_force: true
# form:
#     username:
#         label: Administrator Username
#         max_length: 255
#     password:
#         type: password
#         label: Administrator Password
#         max_length: 255

set -e

npm install -g tiddlywiki

tiddlywiki . --init server

cat << EOF > users.csv
username,password
$FORM_USERNAME,$FORM_PASSWORD
EOF

if [ "$INSTALL_URL_PATH" != "/" ]
then
  mkdir tiddlers
  cat << EOF > tiddlers/\$__config_tiddlyweb_host.tid
title: $:/config/tiddlyweb/host

\$protocol\$//\$host\$$INSTALL_URL_PATH/
EOF
fi
