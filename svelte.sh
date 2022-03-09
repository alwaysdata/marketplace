#!/bin/bash

# site:
#     type: nodejs
#     nodejs_version: '16'
#     working_directory: '{INSTALL_PATH}/svelte-app'
#     command: 'npm run dev'
#     environment: HOME='{INSTALL_PATH}'
# requirements:
#     disk: 40

set -e

echo "y"|npx degit sveltejs/template svelte-app
cd svelte-app
npm install
