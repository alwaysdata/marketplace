#!/bin/bash

# site:
#     type: nodejs
#     nodejs_version: '16'
#     working_directory: '{INSTALL_PATH}'
#     command: 'npm run dev'
#     environment: HOME={INSTALL_PATH}
# requirements:
#     disk: 30

set -e

echo "y"|npx degit sveltejs/template svelte-app
cd svelte-app
npm install

cd ..

rm -rf  .npm
shopt -s dotglob
mv svelte-app/* .
rmdir svelte-app
