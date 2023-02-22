#!/bin/bash

# site:
#     type: nodejs
#     nodejs_version: '18'
#     working_directory: '{INSTALL_PATH}'
#     command: 'npx next start -H ::'
#     environment: HOME={INSTALL_PATH}
# requirements:
#     disk: 340

set -e

npm install yarn
$HOME/node_modules/yarn/bin/yarn create next-app --experimental-app --typescript --eslint --src-dir project

cd project

if [ "$INSTALL_URL_PATH" != "/" ]
then
echo "
module.exports = {
  basePath: '$INSTALL_URL_PATH',
}" >> next.config.js
fi

npx next build

cd
rm -rf .yarn* package* .npm node_modules .config .cache

shopt -s dotglob
mv project/* .
rmdir project
