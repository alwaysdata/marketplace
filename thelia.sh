#!/bin/bash

# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}/web'
#     php_version: '8.3'
#     php_ini: extension=intl.so
# database:
#     type: mysql
# requirements:
#     disk: 200
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
#     admin_firstname:
#         label:
#             en: Administrator firstname
#             fr: Prénom de l'administrateur
#         max_length: 255
#     admin_lastname:
#         label:
#             en: Administrator lastname
#             fr: Nom de l'administrateur
#         max_length: 255
#     admin_password:
#         type: password
#         label:
#             en: Administrator password
#             fr: Mot de passe de l'administrateur
#         max_length: 255

set -e

# https://github.com/thelia/thelia

COMPOSER_CACHE_DIR=/dev/null composer2 create-project thelia/thelia-project default

cd default

php Thelia thelia:install --db_host "$DATABASE_HOST" --db_username "$DATABASE_USERNAME" --db_password "$DATABASE_PASSWORD" --db_name "$DATABASE_NAME"
php Thelia admin:create -q --login_name "$FORM_ADMIN_USERNAME" --first_name "$FORM_ADMIN_FIRSTNAME" --last_name "$FORM_ADMIN_LASTNAME" --email "$FORM_EMAIL" --password "$FORM_ADMIN_PASSWORD"

cd ..

rm -rf .composer .subversion .local

shopt -s dotglob
mv default/* .
rmdir default
