#!/bin/bash

# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}'
#     php_version: '8.1'
#     ssl_force: true
# database:
#     type: mysql
# requirements:
#     disk: 140
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

wget -O- https://builds.matomo.org/matomo-4.6.2.zip | bsdtar --strip-components=1 -xf -

git clone --depth 1 https://github.com/nodeone/extratools.git plugins/ExtraTools

php console plugin:activate ExtraTools --quiet || true
php console config:set 'ExtraTools.db_backup_path="path/tmp"'
php console matomo:install --db-username="$DATABASE_USERNAME" --db-pass="$DATABASE_PASSWORD" --db-host="$DATABASE_HOST" --db-name="$DATABASE_NAME" --first-user="$FORM_ADMIN_USERNAME" --first-user-email="$FORM_EMAIL" --first-user-pass="$FORM_ADMIN_PASSWORD" --do-not-drop-db --force || true

php console site:add --name=mysite --urls="https://$USER.$RESELLER_DOMAIN"

# The plugin console does not activate ExtraTools in newer version than 4.6.2. We install it in 4.6.2 then upgrade it in the last version.
wget -O- https://builds.matomo.org/matomo-4.15.1.zip | bsdtar --strip-components=1 -xf -

# To perform the upgrade we need to first go on the website.
wget -q --timeout=10 https://$INSTALL_URL/index.php?module=CoreUpdater&action=
sleep 10

php console core:update --yes
