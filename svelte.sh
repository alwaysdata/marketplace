#!/bin/bash

# site:
#     type: nodejs
#     nodejs_version: '16'
#     working_directory: '{INSTALL_PATH}'
#     command: 'npm run start'
#     environment: HOME={INSTALL_PATH}
# requirements:
#     disk: 50

set -e

echo "y"|npx degit sveltejs/template svelte-app

shopt -s dotglob
mv svelte-app/* .
rmdir svelte-app

npm install

npm run build
