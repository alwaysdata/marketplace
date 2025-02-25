#!/bin/bash

# Declare site in YAML, as documented on the documentation: https://help.alwaysdata.com/en/marketplace/build-application-script/
# site:
#     type: php
#     php_version: '8.3'
#     php_ini: |
#         extension={INSTALL_PATH}/imagick-8.3.so
#         extension=sodium.so
#     path: '{INSTALL_PATH_RELATIVE}/public'
#     ssl_force: true
# database:
#     type: mysql
# requirements:
#     disk: 500

set -e

# https://snipe-it.readme.io/docs/requirements

git clone https://github.com/snipe/snipe-it .
ad_install_pecl imagick

# Configuration
cat << EOF > .env
# --------------------------------------------
# REQUIRED: BASIC APP SETTINGS
# --------------------------------------------
APP_ENV=production
APP_DEBUG=false
APP_KEY=ChangeMe
APP_URL=https://$INSTALL_URL
APP_TIMEZONE='UTC'
APP_LOCALE=en
MAX_RESULTS=500

# --------------------------------------------
# REQUIRED: UPLOADED FILE STORAGE SETTINGS
# --------------------------------------------
PRIVATE_FILESYSTEM_DISK=local
PUBLIC_FILESYSTEM_DISK=local_public

# --------------------------------------------
# REQUIRED: DATABASE SETTINGS
# --------------------------------------------
DB_CONNECTION=mysql
DB_HOST=$DATABASE_HOST
DB_DATABASE=$DATABASE_NAME
DB_USERNAME=$DATABASE_USERNAME
DB_PASSWORD=$DATABASE_PASSWORD
DB_PREFIX=null
DB_CHARSET=utf8mb4
DB_COLLATION=utf8mb4_unicode_ci

# --------------------------------------------
# REQUIRED: OUTGOING MAIL SERVER SETTINGS
# --------------------------------------------
MAIL_DRIVER=smtp
MAIL_HOST=smtp-$USER.$RESELLER_DOMAIN
MAIL_PORT=25
MAIL_FROM_ADDR=$USER@$RESELLER_DOMAIN
MAIL_FROM_NAME='Snipe-IT'
MAIL_REPLYTO_ADDR=$USER@$RESELLER_DOMAIN
MAIL_REPLYTO_NAME='Snipe-IT'
MAIL_AUTO_EMBED_METHOD='attachment'

# --------------------------------------------
# REQUIRED: IMAGE LIBRARY
# This should be gd or imagick
# --------------------------------------------
IMAGE_LIB=imagick
EOF

COMPOSER_CACHE_DIR=/dev/null composer2 install
php artisan key:generate --force
