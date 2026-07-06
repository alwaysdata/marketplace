#!/bin/bash

# Declare site in YAML, as documented here: https://help.alwaysdata.com/en/docs/development/marketplace/build-application-script/
# site:
#     type: nodejs
#     nodejs_version: '22'
#     working_directory: '{INSTALL_PATH_RELATIVE}'
#     command: 'yarn start'
#     environment: HOME={INSTALL_PATH}
#     ssl_force: true
# requirements:
#     disk: 800

set -e

wget -O- --no-hsts https://github.com/muety/mininote/archive/refs/tags/1.0.4.tar.gz |tar -xz --strip-components=1
yarn
cd webapp && yarn && yarn build
