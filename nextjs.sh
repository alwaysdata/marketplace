#!/bin/bash

# site:
#     type: nodejs
#     nodejs_version: '16'
#     working_directory: '{INSTALL_PATH}'
#     command: 'npx next start -H ::'
#     environment: HOME={INSTALL_PATH}
# requirements:
#     disk: 340

set -e

echo "y"|npx create-next-app project

shopt -s dotglob
mv project/* .
rmdir project

if [ "$INSTALL_URL_PATH" != "/" ]
then
echo "
module.exports = {
  basePath: '$INSTALL_URL_PATH',
}" >> next.config.js
fi

npx next build
