#!/bin/bash

# Declare site in YAML, as documented on the documentation: https://help.alwaysdata.com/en/marketplace/build-application-script/
# site:
#     type: nodejs
#     nodejs_version: '20'
#     working_directory: '{INSTALL_PATH}'
#     command: 'npx directus start'
#     environment: |
#         'HOME={INSTALL_PATH}'
#         'PYTHON_VERSION=3.11'
# database:
#     type: mysql
# requirements:
#     disk: 550
# form:
#     admin_email:
#         type: email
#         label:
#             en: Administrator email
#             fr: Email de l'administrateur
#     admin_password:
#         type: password
#         label:
#             en: Administrator password
#             fr: Mot de passe de l'administrateur

set -e

export PYTHON_VERSION=3.11

# https://docs.directus.io/self-hosted/cli.html

# Install Directus & dependancies
npm init -y
sed -i '/\"scripts\": {/a\ \ \ \ \"start\": \"directus start\",' package.json
npm install directus

# Configuration
# https://docs.directus.io/configuration/config-options/
# https://github.com/directus/directus/blob/main/api/example.env
cat << EOF > .env
##################

HOST="::"
PORT=$PORT
PUBLIC_URL="http://$INSTALL_URL"
LOG_LEVEL="info"
LOG_STYLE="pretty"

##################

# Database


## MariaDB
DB_CLIENT="mysql"
DB_HOST="$DATABASE_HOST"
DB_PORT=3306
DB_DATABASE="$DATABASE_NAME"
DB_USER="$DATABASE_USERNAME"
DB_PASSWORD="$DATABASE_PASSWORD"

##################

# Security

KEY="$(echo $RANDOM | md5sum | sed 's/ .*//')"
SECRET="$(echo $RANDOM | md5sum | sed 's/ .*//')"

##################

# File Storage

STORAGE_LOCATIONS="local"
# CSV of names

STORAGE_LOCAL_DRIVER="local"
STORAGE_LOCAL_ROOT="./uploads"

##################

# Extensions

EXTENSIONS_PATH="./extensions"

##################

# Email

EMAIL_FROM="$USER@$RESELLER_DOMAIN "
EMAIL_TRANSPORT="sendmail"

## Email (Sendmail Transport)
EMAIL_SENDMAIL_NEW_LINE="unix"
EMAIL_SENDMAIL_PATH="/usr/sbin/sendmail"
EOF

mkdir uploads

export ADMIN_EMAIL=$FORM_ADMIN_EMAIL
export ADMIN_PASSWORD=$FORM_ADMIN_PASSWORD
npx directus bootstrap
