#!/bin/bash

# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}'
#     php_version: '7.4'
#     php_ini: extension=intl.so
# database:
#     type: mysql
# requirements:
#     disk: 440
# form:
#     language:
#         type: choices
#         label:
#             en: Language
#             fr: Langue
#         choices:
#             de: Deutsch
#             en: English
#             es: Español
#             fr: Français
#             it: Italiano
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

wget -O- https://github.com/PrestaShop/PrestaShop/releases/download/1.7.8.2/prestashop_1.7.8.2.zip | bsdtar --strip-components=0 -xf -
unzip -o prestashop.zip
rm prestashop.zip

php install/index_cli.php --domain="$INSTALL_URL_HOSTNAME" --base_uri="$INSTALL_URL_PATH" --language="$FORM_LANGUAGES" --db_name="$DATABASE_NAME" --db_user="$DATABASE_USERNAME" --db_password="$DATABASE_PASSWORD" --db_server="$DATABASE_HOST" --name="$FORM_SHOP_NAME" --firstname="$FORM_ADMIN_FIRSTNAME" --lastname="$FORM_ADMIN_LASTNAME" --password="$FORM_ADMIN_PASSWORD" --email="$FORM_EMAIL" --newsletter=0

rm -rf install
