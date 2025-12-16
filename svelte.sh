#!/bin/bash

# Declare site in YAML, as documented on the documentation: https://help.alwaysdata.com/en/marketplace/build-application-script/
# site:
#     type: nodejs
#     nodejs_version: '24'
#     working_directory: '{INSTALL_PATH_RELATIVE}'
#     command: 'npm run start'
#     environment: HOME={INSTALL_PATH}
# requirements:
#     disk: 50

set -e

# https://svelte.dev/docs/introduction

# Download & move the app at the install root
echo "y"|npx degit sveltejs/template svelte-app

shopt -s dotglob
mv svelte-app/* .
rmdir svelte-app

# Install
npm install

npm run build
