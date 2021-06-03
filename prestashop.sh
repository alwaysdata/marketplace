#!/bin/bash

# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}'
#     php_version: '7.2'
#     php_ini: extension=intl.so
# database:
#     type: mysql
# form:
#     language:
#         type: choices
#         label: Language
#         initial: en
#         choices:
#             de: German
#             en: English
#             es: Spanish
#             fr: French
#             it: Italian
#     shop_name:
#         label: Shop name
#         max_length: 255
#     email:
#         type: email
#         label: Email
#     admin_firstname:
#         label: Administrator first name
#         max_length: 255
#     admin_lastname:
#         label: Administrator last name
#         max_length: 255
#     admin_password:
#         type: password
#         label: Administrator password
#         max_length: 255
#         min_length: 8

set -e

# http://doc.prestashop.com/display/PS17/What+you+need+to+get+started

COMPOSER_CACHE_DIR=/dev/null composer2 create-project prestashop/prestashop default

php default/install-dev/index_cli.php --domain="$INSTALL_URL_HOSTNAME" --base_uri="$INSTALL_URL_PATH" --langage="$FORM_LANGUAGES" --db_name="$DATABASE_NAME" --db_user="$DATABASE_USERNAME" --db_password="$DATABASE_PASSWORD" --db_server="$DATABASE_HOST" --name="$FORM_SHOP_NAME" --firstname="$FORM_ADMIN_FIRSTNAME" --lastname="$FORM_ADMIN_LASTNAME" --password="$FORM_ADMIN_PASSWORD" --email="$FORM_EMAIL" --newsletter=0

rm -rf default/install .composer .subversion composer.json composer.lock vendor

shopt -s dotglob
mv default/* .
rmdir default
