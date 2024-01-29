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

wget --no-hsts -O forgejo https://codeberg.org/forgejo/forgejo/releases/download/v1.21.4-0/forgejo-1.21.4-0-linux-amd64

chmod +x  forgejo

mkdir -p custom/conf
cat << EOF > custom/conf/app.ini
# More options https://forgejo.org/docs/latest/admin/config-cheat-sheet/

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

# First access to the website redirects to a graphical interface to set the instance and create the first administrator.
