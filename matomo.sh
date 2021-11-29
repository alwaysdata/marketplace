#!/bin/bash

# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}'
#     php_version: '8.0'
#     ssl_force: true
# database:
#     type: mysql
# requirements:
#     disk: 130
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

wget -O- https://builds.matomo.org/matomo.zip | bsdtar --strip-components=1 -xf -

# https://github.com/matomo-org/matomo/issues/15738
wget https://raw.githubusercontent.com/matomo-org/matomo/4.x-dev/composer.lock
wget https://raw.githubusercontent.com/matomo-org/matomo/4.x-dev/composer.json
COMPOSER_CACHE_DIR=/dev/null composer2 require symfony/yaml:~2.6.0
COMPOSER_CACHE_DIR=/dev/null composer2 require symfony/process:^3.4
git clone https://github.com/nodeone/extratools.git plugins/ExtraTools

php console plugin:activate ExtraTools --quiet || true
php console config:set 'ExtraTools.db_backup_path="path/tmp"'
php console matomo:install --db-username="$DATABASE_USERNAME" --db-pass="$DATABASE_PASSWORD" --db-host="$DATABASE_HOST" --db-name="$DATABASE_NAME" --first-user="$FORM_ADMIN_USERNAME" --first-user-email="$FORM_EMAIL" --first-user-pass="$FORM_ADMIN_PASSWORD" --do-not-drop-db --force || true

# https://github.com/digitalist-se/extratools/issues/25
php console site:add --name=mysite --urls="https://$USER.$RESELLER_DOMAIN"
