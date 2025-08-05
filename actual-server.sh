#!/bin/bash

# Declare site in YAML, as documented on the documentation: https://help.alwaysdata.com/en/marketplace/build-application-script/
# site:
#     type: nodejs
#     nodejs_version: '22'
#     working_directory: '{INSTALL_PATH_RELATIVE}'
#     command: 'yarn start:server'
#     environment: |
#         HOME={INSTALL_PATH}
#     path_trim: true
#     ssl_force: true
# requirements:
#     disk: 2300

set -e

# https://actualbudget.org/docs/actual-server-repo-move/
# https://actualbudget.org/docs/install/build-from-source

# Download and install
git clone -b v25.8.0 --depth 1 https://github.com/actualbudget/actual .

yarn install

# Configuration
cat << EOF > packages/sync-server/config.json
{
    "port": $PORT,
    "hostname": "::",
    "serverFiles": "$INSTALL_PATH/packages/sync-server/server-files",
    "userFiles": "$INSTALL_PATH/packages/sync-server/user-files"
}
EOF

yarn build:server
