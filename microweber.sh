#!/bin/bash

# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}'
#     php_version: '8.1'
#     php_ini: |
#         extension={INSTALL_PATH}/mcrypt-8.1.so
#         extension=intl.so
#         extension=sodium.so
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
#         max_length: 255
#         min_length: 8
set -e

ad_install_pecl mcrypt

COMPOSER_CACHE_DIR=/dev/null composer2 create-project microweber/microweber=v1.3.2 --no-interaction

cd microweber
echo "yes" | php artisan key:generate

# http://docs.microweber.com/guides/installation_cli.md
php artisan microweber:install --email=$FORM_EMAIL --username=$FORM_ADMIN_USERNAME --password=$FORM_ADMIN_PASSWORD --db-host=$DATABASE_HOST --db-name=$DATABASE_NAME --db-username=$DATABASE_USERNAME --db-password=$DATABASE_PASSWORD --db-driver=mysql --template=default --default-content

# Nettoyage
cd
rm -rf .subversion .config .local .rnd
shopt -s dotglob
mv microweber/* .
rmdir microweber
