#!/bin/bash

# site:
#     type: nodejs
#     nodejs_version: '14'
#     working_directory: '{INSTALL_PATH}'
#     command: '{INSTALL_PATH}/node_modules/yarn/bin/yarn start'
#     environment: |
#        MININOTE_PORT=PORT
#        HOME='{INSTALL_PATH}'
# requirements:
#     disk: 100

set -e

git clone https://github.com/muety/mininote .
npm install yarn

~/node_modules/yarn/bin/yarn
cd webapp && ~/node_modules/yarn/bin/yarn && ~/node_modules/yarn/bin/yarn build
