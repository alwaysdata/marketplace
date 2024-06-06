#!/bin/bash

# Declare site in YAML, as documented on the documentation: https://help.alwaysdata.com/en/marketplace/build-application-script/
# site:
#     type: nodejs
#     nodejs_version: '20'
#     working_directory: '{INSTALL_PATH}'
#     command: 'node ./app.js'
#     path_trim: true
#     ssl_force: true
# requirements:
#     disk: 440

set -e

VERSION=24.6.0

# https://github.com/actualbudget/actual-server#running

# Download and install
git clone -b v$VERSION --depth 1 https://github.com/actualbudget/actual-server.git $INSTALL_PATH

npm install yarn
$HOME/node_modules/yarn/bin/yarn install

#Configuration
cat << EOF > config.json
{
    "mode": "production",
    "port": $PORT,
    "hostname": "::",
    "serverFiles": "$INSTALL_PATH/server-files",
    "userFiles": "$INSTALL_PATH/user-files"
}
EOF
