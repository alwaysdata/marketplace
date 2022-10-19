#!/bin/bash

# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}'
#     php_version: '8.1'
#     php_ini: |
#         extension=intl.so
#         extension=gmp.so
#         memory_limit=512M
# database:
#     type: mysql
# requirements:
#     disk: 550
# form:
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

# https://docs.nextcloud.com/server/latest/admin_manual/configuration_server/occ_command.html?highlight=occ#command-line-installation-label

wget -O - https://download.nextcloud.com/server/releases/latest.zip | bsdtar --strip-components=1 -xf -

php occ maintenance:install --database="mysql" --database-host="$DATABASE_HOST" --database-name="$DATABASE_NAME" --database-user="$DATABASE_USERNAME" --database-pass="$DATABASE_PASSWORD" --admin-user="$FORM_ADMIN_USERNAME" --admin-pass="$FORM_ADMIN_PASSWORD"
php occ config:system:set trusted_domains 0 --value="$INSTALL_URL_HOSTNAME"
php occ config:system:set overwrite.cli.url --value="http://$INSTALL_URL"
