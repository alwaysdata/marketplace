#!/bin/bash

# Declare site in YAML, as documented on the documentation: https://help.alwaysdata.com/en/marketplace/build-application-script/
# site:
#     type: user_program
#     working_directory: '{INSTALL_PATH_RELATIVE}'
#     command: './forgejo web'
#     path_trim: true
#     ssl_force: true
# database:
#     type: postgresql
# requirements:
#     disk: 110

set -e

# Download
wget --no-hsts -O forgejo https://codeberg.org/forgejo/forgejo/releases/download/v12.0.2/forgejo-12.0.2-linux-amd64

chmod +x  forgejo

# Configuration
mkdir -p custom/conf
cat << EOF > custom/conf/app.ini
# More options https://forgejo.org/docs/latest/admin/config-cheat-sheet/

[server]
DOMAIN = $INSTALL_URL
HTTP_ADDR = "::"
HTTP_PORT = $PORT
SSH_DOMAIN = ssh-$USER.$RESELLER_DOMAIN
ROOT_URL = https://$INSTALL_URL/

[database]
DB_TYPE = postgres
HOST = $DATABASE_HOST
NAME = $DATABASE_NAME
USER = $DATABASE_USERNAME
PASSWD = $DATABASE_PASSWORD
EOF
