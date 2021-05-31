#!/bin/bash

# site:
#     type: nodejs
#     nodejs_version: '14'
#     working_directory: '{INSTALL_PATH}/encryptic'
#     command: '~{INSTALL_PATH_RELATIVE}/.npm-packages/bin/gulp'
#     path_trim: true

set -e

npm install -g yarn
npm install -g gulp


git clone https://github.com/encryptic-team/encryptic.git

cd encryptic

sed -i 's|"optionalDependencies": {}|"optionalDependencies": {},|' package.json
sed -i '/"optionalDependencies": {},/a"resolutions": {"graceful-fs": "^4.2.4"}' package.json
sed -i "s|\$.minimist.port \|\| 9000|$PORT|" gulps/serve.js
sed -i "/$PORT;/a \ \ \ \ \ \ \ \ \ \ \ \ const ip = \"::\";" gulps/serve.js
    
$HOME/.npm-packages/bin/yarn
