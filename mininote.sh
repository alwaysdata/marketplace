#!/bin/bash

# site:
#     type: nodejs
#     nodejs_version: '18'
#     working_directory: '{INSTALL_PATH}'
#     command: '{INSTALL_PATH}/node_modules/yarn/bin/yarn start'
#     environment: HOME={INSTALL_PATH}
# requirements:
#     disk: 1000

set -e

git clone https://github.com/muety/mininote .
npm install yarn

~/node_modules/yarn/bin/yarn
cd webapp && ~/node_modules/yarn/bin/yarn && ~/node_modules/yarn/bin/yarn build
