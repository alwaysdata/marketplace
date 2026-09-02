#!/bin/bash

# Declare site in YAML, as documented here: https://help.alwaysdata.com/en/docs/development/marketplace/build-application-script/
# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}/default/public'
#     php_version: '8.3'
# database:
#     type: mysql
# requirements:
#     disk: 500
# form:
#     email:
#         type: email
#         label:
#             en: Email
#             fr: Email
#         max_length: 255
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

# https://doc.thelia.net/docs/getting-started

# Download

echo 'Y' | COMPOSER_CACHE_DIR=/dev/null composer2 create-project thelia/thelia-project default

cd default

COMPOSER_CACHE_DIR=/dev/null composer2 install

# Install
php bin/install --database_host="$DATABASE_HOST" --database_user="$DATABASE_USERNAME" --database_password="$DATABASE_PASSWORD" --database_name="$DATABASE_NAME" --with-demo --with-admin --frontoffice_theme=flexy --admin_login="$FORM_ADMIN_USERNAME" --admin_email="$FORM_EMAIL" --admin_password="$FORM_ADMIN_PASSWORD"

## Cleaning
cd
rm -rf .cache/ .config/ .local/ .subversion/
