#!/bin/bash

# Declare site in YAML, as documented on the documentation: https://help.alwaysdata.com/en/marketplace/build-application-script/
# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}'
#     php_version: '8.1'
#     ssl_force: true
# database:
#     type: mysql
# requirements:
#     disk: 100
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

# Download
wget -O- --no-hsts https://builds.matomo.org/matomo-5.2.2.zip | bsdtar --strip-components=1 -xf -

# https://plugins.matomo.org/ExtraTools#documentation
cd plugins
wget -O- --no-hsts https://github.com/digitalist-se/extratools/archive/refs/tags/5.1.2.zip | bsdtar --strip-components=0 -xf -
mv Matomo-Plugin-ExtraTools-5.1.2 ExtraTools
cd

php console plugin:activate ExtraTools --quiet || true
php console config:set 'ExtraTools.db_backup_path="path/tmp"'

# Install
php console matomo:install --db-username="$DATABASE_USERNAME" --db-pass="$DATABASE_PASSWORD" --db-host="$DATABASE_HOST" --db-name="$DATABASE_NAME" --first-user="$FORM_ADMIN_USERNAME" --first-user-email="$FORM_EMAIL" --first-user-pass="$FORM_ADMIN_PASSWORD" --do-not-drop-db --force || true

php console site:add --name=mysite --urls="https://$USER.$RESELLER_DOMAIN" ||true
