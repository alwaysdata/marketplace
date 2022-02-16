#!/bin/bash

# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}'
#     php_version: '8.1'
#     php_ini: |
#         extension={INSTALL_PATH}/mcrypt.so
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
#         max_length: 255
#         min_length: 8
set -e

ad_install_pecl mcrypt

COMPOSER_CACHE_DIR=/dev/null composer2 create-project microweber/microweber --no-interaction

cd microweber
echo "yes" | php artisan key:generate

# http://docs.microweber.com/guides/installation_cli.md
php artisan microweber:install $FORM_EMAIL $FORM_ADMIN_USERNAME $FORM_ADMIN_PASSWORD $DATABASE_HOST $DATABASE_NAME $DATABASE_USERNAME $DATABASE_PASSWORD mysql -t default -d 1

# Nettoyage
cd
rm -rf .subversion .config .local .rnd
shopt -s dotglob
mv microweber/* .
rmdir microweber
