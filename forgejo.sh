#!/bin/bash

# site:
#     type: user_program
#     working_directory: '{INSTALL_PATH}'
#     command: './forgejo web'
#     path_trim: true
# database:
#     type: postgresql
# requirements:
#     disk: 110

set -e

wget -O forgejo https://codeberg.org/forgejo/forgejo/releases/download/v1.20.6-0/forgejo-1.20.6-0-linux-amd64

chmod +x  forgejo

# https://forgejo.org/docs/latest/admin/config-cheat-sheet/
mkdir -p custom/conf
cat << EOF > custom/conf/app.ini
[server]
DOMAIN = $INSTALL_URL
HTTP_ADDR = "::"
HTTP_PORT = $PORT

[database]
DB_TYPE = postgres
HOST = $DATABASE_HOST
NAME = $DATABASE_NAME
USER = $DATABASE_USERNAME
PASSWD = $DATABASE_PASSWORD
EOF

rm .wget-hsts

# After is GUI
