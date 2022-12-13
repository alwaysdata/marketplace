#!/bin/bash

# site:
#     type: nodejs
#     nodejs_version: '16.17'
#     working_directory: '{INSTALL_PATH}'
#     command: 'npm run start'
#     path_trim: true
#     ssl_force: true
#     environment: HOME={INSTALL_PATH}
# database:
#     type: postgresql
# requirements:
#     disk: 500

set -e

npm install strapi
./node_modules/strapi/bin/strapi.js new --dbclient=postgres --dbhost=$DATABASE_HOST --dbport=5432 --dbname=$DATABASE_NAME --dbusername=$DATABASE_USERNAME --dbpassword=$DATABASE_PASSWORD --dbforce --no-run default

cd default

sed -i  "/port: env.int('PORT', 1337),/a \ \ url: 'https://$INSTALL_URL'," config/server.js

npm run build

cd
rm -rf  .npm package.json package-lock.json node_modules
shopt -s dotglob
mv default/* .
rmdir default
