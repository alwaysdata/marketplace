#!/bin/bash

# Declare site in YAML, as documented on the documentation: https://help.alwaysdata.com/en/marketplace/build-application-script/
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

# Download
wget --no-hsts -O forgejo https://codeberg.org/forgejo/forgejo/releases/download/v1.21.10-0/forgejo-1.21.10-0-linux-amd64

chmod +x  forgejo

# Configuration
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
