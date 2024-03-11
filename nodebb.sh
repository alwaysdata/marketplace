#!/bin/bash

# Declare site in YAML, as documented on the documentation: https://help.alwaysdata.com/en/marketplace/build-application-script/
# site:
#     type: nodejs
#     nodejs_version: '20'
#     working_directory: '{INSTALL_PATH}'
#     command: 'node app.js'
#     environment: |
#         NODE_ENV=production
#         HOME='{INSTALL_PATH}'
# database:
#      type: postgresql
# requirements:
#     disk: 750
# form:
#     email:
#         type: email
#         label:
#             en: Email
#             fr: Email
#     admin_username:
#         label:
#             en: Administrator username
#             fr: Nom d'utilisateur de l'administrateur
#         max_length: 255
#     admin_password:
#         type: password
#         label:
#             en: Administrator password
#             fr: Mot de passe de l'administrateur
#         max_length: 255
set -e

# https://docs.nodebb.org/installing/os/ubuntu/#installing-nodebb

# Download
wget -O- --no-hsts https://github.com/NodeBB/NodeBB/archive/refs/tags/v3.7.0.tar.gz|tar -xz --strip-components=1

# Configuration
cat << EOF > config.json
{
    "url": "http://$INSTALL_URL",
    "port": "$PORT",
    "bind_address": "::",
    "secret": "$(openssl rand -base64 32)",
    "database": "postgres",
    "postgres": {
        "host": "$DATABASE_HOST",
        "port": "5432",
        "username": "$DATABASE_USERNAME",
        "password": "$DATABASE_PASSWORD",
        "database": "$DATABASE_NAME",
        "ssl": "false"
    }
}
EOF

# Install
export NODEBB_ADMIN_USERNAME="$FORM_ADMIN_USERNAME"
export NODEBB_ADMIN_EMAIL="$FORM_EMAIL"
export NODEBB_ADMIN_PASSWORD="$FORM_ADMIN_PASSWORD"

./nodebb setup
