#!/bin/bash

# site:
#     type: nodejs
#     nodejs_version: '16'
#     working_directory: '{INSTALL_PATH}/strapi'
#     command: 'npm run start'
#     path_trim: true
#     ssl_force: true
#     environment: HOME='{INSTALL_PATH}'
# requirements:
#     disk: 100

set -e

echo "y"|npx create-strapi-app strapi --quickstart --no-run

sed -i  "/port: env.int('PORT', 1337),/a \ \ url: 'https://$INSTALL_URL'," strapi/config/server.js
