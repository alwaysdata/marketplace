#!/bin/bash

# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}'
#     php_version: '7.4'
#     php_ini: extension=intl.so
# database:
#     type: mysql
# requirements:
#     disk: 380
# form:
#     shop_name:
#         label:
#             en: Shop name
#             fr: Nom de la boutique
#         max_length: 255
#     email:
#         type: email
#         label:
#             en: Email
#             fr: Email
#     admin_firstname:
#         label:
#             en: Administrator first name
#             fr: Prénom de l'administrateur
#         max_length: 255
#         regex: ^[a-zA-Z0-9.'`* _-]+$
#     admin_lastname:
#         label:
#             en: Administrator last name
#             fr: Nom de l'administrateur
#         max_length: 255
#         regex: ^[a-zA-Z0-9.'`* _-]+$
#     admin_password:
#         type: password
#         label:
#             en: Administrator password
#             fr: Mot de passe de l'administrateur
#         max_length: 255
#         min_length: 8

set -e

# https://doc.prestashop.com/display/PS17/Installing+PrestaShop+using+the+command-line+script

wget -O- https://www.prestashop.com/en/system/files/ps_releases/prestashop_1.7.8.6.zip | bsdtar --strip-components=0 -xf -

unzip -o prestashop.zip
rm prestashop.zip

php install/index_cli.php --domain="$INSTALL_URL_HOSTNAME" --base_uri="$INSTALL_URL_PATH" --db_name="$DATABASE_NAME" --db_user="$DATABASE_USERNAME" --db_password="$DATABASE_PASSWORD" --db_server="$DATABASE_HOST" --name="$FORM_SHOP_NAME" --firstname="$FORM_ADMIN_FIRSTNAME" --lastname="$FORM_ADMIN_LASTNAME" --password="$FORM_ADMIN_PASSWORD" --email="$FORM_EMAIL" --newsletter=0

rm -rf install
