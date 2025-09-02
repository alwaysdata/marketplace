#!/bin/bash

# Declare site in YAML, as documented on the documentation: https://help.alwaysdata.com/en/marketplace/build-application-script/
# site:
#     type: nodejs
#     nodejs_version: '22'
#     working_directory: '{INSTALL_PATH_RELATIVE}'
#     command: 'pnpm run prod'
#     environment: |
#         NODE_ENV=production
#         HOME={INSTALL_PATH}
# database:
#     type: mysql
# requirements:
#     disk: 1000

set -e

# https://github.com/ether/etherpad-lite#installation

npm install pnpm

wget -O- --no-hsts https://github.com/ether/etherpad-lite/archive/2.5.0.tar.gz | tar -xz --strip-components=1

cp settings.json.template settings.json

cat << EOF > credentials.json
{
"ip": "",
"port" : $PORT,

"dbType" : "mysql",
"dbSettings" : {
    "user"    : "$DATABASE_USERNAME",
    "host"    : "$DATABASE_HOST",
    "port"    : 3306,
    "password": "$DATABASE_PASSWORD",
    "database": "$DATABASE_NAME",
    "carset" : "utf8mb4"
  },
}
EOF
pnpm i
pnpm run build:etherpad
