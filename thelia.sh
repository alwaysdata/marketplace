#!/bin/bash

# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}'
#     php_version: '7.3'
#     php_ini: |
#         extension=intl.so
#         extension=calendar.so
# database:
#     type: mysql
# form:
#     email:
#         type: email
#         label: Email
#     admin_username:
#         label: Administrator username
#         max_length: 255
#     admin_firstname:
#         label: Administrator firstname
#         max_length: 255
#     admin_lastname:
#         label: Administrator lastname
#         max_length: 255
#     admin_password:
#         type: password
#         label: Administrator password
#         max_length: 255

set -e

composer create-project thelia/thelia default 2.4.0

cd default

php Thelia thelia:install --db_host "$DATABASE_HOST" --db_username "$DATABASE_USERNAME" --db_password "$DATABASE_PASSWORD" --db_name "$DATABASE_NAME"
php Thelia admin:create -q --login_name "$FORM_ADMIN_USERNAME" --first_name "$FORM_ADMIN_FIRSTNAME" --last_name "$FORM_ADMIN_LASTNAME" --email "$FORM_EMAIL" --password "$FORM_ADMIN_PASSWORD"

cd ..

rm -rf .composer .subversion

shopt -s dotglob nullglob
mv default/* .
rmdir default
