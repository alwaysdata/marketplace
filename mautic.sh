#!/bin/bash

# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}'
#     php_version: '8.0'
#     php_ini: |
#         memory_limit = 4096M
#         extension = imap.so
#         extension = intl.so
#         extension = sockets.so
#         zend.assertions = -1
#     ssl_force: true
# database:
#     type: mysql
# requirements:
#     disk: 400
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
#         min_length: 6
#         max_length: 255

set -e

COMPOSER_CACHE_DIR=/dev/null composer2 create-project mautic/core

cd core

php bin/console mautic:install --db_driver="pdo_mysql" --db_host="$DATABASE_HOST" --db_port="3306" --db_name="$DATABASE_NAME" --db_user="$DATABASE_USERNAME" --db_password="$DATABASE_PASSWORD" --admin_username="$FORM_ADMIN_USERNAME" --admin_email="$FORM_EMAIL" --admin_password="$FORM_ADMIN_PASSWORD" https://$INSTALL_URL

cd
rm -rf .wget-hsts .config .local .subversion vendor
shopt -s dotglob
mv core/* .
rmdir core
