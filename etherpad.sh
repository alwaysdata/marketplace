#!/bin/bash

# site:
#     type: nodejs
#     nodejs_version: '18'
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

wget -O- https://github.com/ether/etherpad-lite/archive/1.8.18.tar.gz | tar -xz --strip-components=1

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
