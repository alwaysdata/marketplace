#!/bin/bash

# Declare site in YAML, as documented on the documentation: https://help.alwaysdata.com/en/marketplace/build-application-script/
# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}'
#     php_version: '8.1'
#     php_ini: extension=intl.so
#     ssl_force: true
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

# https://devdocs.prestashop-project.org/8/basics/installation/system-requirements/
# https://devdocs.prestashop-project.org/8/basics/installation/advanced/install-from-cli/

# Download
wget -O- --no-hsts https://github.com/PrestaShop/PrestaShop/releases/download/8.2.0/prestashop_8.2.0.zip | bsdtar --strip-components=0 -xf -

unzip -o prestashop.zip
rm prestashop.zip

# Install
php install/index_cli.php --domain="$INSTALL_URL_HOSTNAME" --base_uri="$INSTALL_URL_PATH" --db_name="$DATABASE_NAME" --db_user="$DATABASE_USERNAME" --db_password="$DATABASE_PASSWORD" --db_server="$DATABASE_HOST" --name="$FORM_SHOP_NAME" --firstname="$FORM_ADMIN_FIRSTNAME" --lastname="$FORM_ADMIN_LASTNAME" --password="$FORM_ADMIN_PASSWORD" --email="$FORM_EMAIL" --newsletter=0 --ssl=1

# Clean install environment
rm -rf install

# `/usr/sbin/sendmail` is not functional. Choose to set your “own SMTP parameters” and simply provide the SMTP hostname of your account (given in the menu *Emails > Addresses* of your alwaysdata admin interface).
