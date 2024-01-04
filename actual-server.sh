#!/bin/bash

# site:
#     type: nodejs
#     nodejs_version: '20'
#     working_directory: '{INSTALL_PATH}'
#     command: 'node ~{INSTALL_PATH_RELATIVE}/app.js'
#     path_trim: true
# requirements:
#     disk: 440

set -e

VERSION=23.12.1

# https://github.com/actualbudget/actual-server#running

git clone -b v$VERSION --depth 1 https://github.com/actualbudget/actual-server.git $INSTALL_PATH

npm install yarn
$HOME/node_modules/yarn/bin/yarn install
cat << EOF > config.json
{
    "mode": "production",
    "port": $PORT,
    "hostname": "::",
    "serverFiles": "$INSTALL_PATH/server-files",
    "userFiles": "$INSTALL_PATH/user-files"
}
EOF
