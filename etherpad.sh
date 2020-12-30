#!/bin/bash

# site:
#     type: nodejs
#     nodejs_version: '15'
#     working_directory: '{INSTALL_PATH}'
#     command: 'bin/run.sh'
# database:
#     type: mysql

set -e

wget -O- https://github.com/ether/etherpad-lite/archive/1.8.7.tar.gz | tar -xz --strip-components=1

cp settings.json.template settings.json

cat << EOF > credentials.json
{
"ip": "$(test $(head -c1 /etc/debian_version) == 8 && echo '0.0.0.0' || echo '')",
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
