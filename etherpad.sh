#!/bin/bash

# Declare site in YAML, as documented on the documentation: https://help.alwaysdata.com/en/marketplace/build-application-script/
# site:
#     type: nodejs
#     nodejs_version: '20'
#     working_directory: '{INSTALL_PATH}'
#     command: 'node src/node/server.js'
#     environment: |
#         NODE_ENV=production
#         HOME={INSTALL_PATH}
# database:
#     type: mysql
# requirements:
#     disk: 270

set -e

# https://github.com/ether/etherpad-lite#installation

wget -O- --no-hsts https://github.com/ether/etherpad-lite/archive/1.9.7.tar.gz | tar -xz --strip-components=1

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

./src/bin/installDeps.sh
