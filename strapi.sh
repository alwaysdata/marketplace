#!/bin/bash

# Declare site in YAML, as documented on the documentation: https://help.alwaysdata.com/en/marketplace/build-application-script/
# site:
#     type: nodejs
#     nodejs_version: '20'
#     working_directory: '{INSTALL_PATH_RELATIVE}'
#     command: 'npm run start'
#     path_trim: true
#     ssl_force: true
#     environment: HOME={INSTALL_PATH}
# database:
#     type: postgresql
# requirements:
#     disk: 500

set -e

# https://docs.strapi.io/dev-docs/installation/cli

npm install create-strapi-app
npx create-strapi-app default  --dbclient=postgres --dbhost=$DATABASE_HOST --dbport=5432 --dbname=$DATABASE_NAME --dbusername=$DATABASE_USERNAME --dbpassword=$DATABASE_PASSWORD --dbforce --no-run --skip-cloud

cd default

sed -i  "/port: env.int('PORT', 1337),/a \ \ url: 'https://$INSTALL_URL'," config/server.js

npm run build

# Clean install environment
cd
rm -rf  .npm package.json package-lock.json node_modules
shopt -s dotglob
mv default/* .
rmdir default
