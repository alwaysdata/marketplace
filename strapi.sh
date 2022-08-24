#!/bin/bash

# site:
#     type: nodejs
#     nodejs_version: '16'
#     working_directory: '{INSTALL_PATH}'
#     command: 'npm run start'
#     path_trim: true
#     ssl_force: true
#     environment: HOME={INSTALL_PATH}
# requirements:
#     disk: 500

set -e

echo "y"|npx --ignore-existing create-strapi-app strapi --quickstart --no-run

cd strapi

sed -i  "/port: env.int('PORT', 1337),/a \ \ url: 'https://$INSTALL_URL'," config/server.js

cat << EOF |sed -i "/module.exports = ({ env }) => ({/r /dev/stdin" config/admin.js
  apiToken: {
    salt: env('API_TOKEN_SALT', '$(date +%s | sha256sum | base64 | head -c 32 ; echo)'),
  },
EOF

npm run build

cd ..
rm -rf  .npm
shopt -s dotglob
mv strapi/* .
rmdir strapi
