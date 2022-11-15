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

npx create-strapi-app strapi --dbclient=postgres --dbhost=$DATABASE_HOST --dbport=5432 --dbname=$DATABASE_NAME --dbusername=$DATABASE_USERNAME --dbpassword=$DATABASE_PASSWORD --dbforce

cd strapi

sed -i  "/port: env.int('PORT', 1337),/a \ \ url: 'https://$INSTALL_URL'," config/server.js

cat << EOF |sed -i "/module.exports = ({ env }) => ({/r /dev/stdin" config/admin.js
  apiToken: {
    salt: env('API_TOKEN_SALT', '$(date +%s | sha256sum | base64 | head -c 32 ; echo)'),
  },
EOF

npm run build

cd
rm -rf  .npm
shopt -s dotglob
mv strapi/* .
rmdir strapi
