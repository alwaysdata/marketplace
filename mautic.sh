#!/bin/bash

# Declare site in YAML, as documented on the documentation: https://help.alwaysdata.com/en/marketplace/build-application-script/
# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}'
#     php_version: '8.3'
#     php_ini: |
#         memory_limit = 4096M
#         extension = imap.so
#         extension = intl.so
#         extension = sockets.so
#         extension = {INSTALL_PATH}/redis-8.3.so
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
#         max_length: 255
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
#         regex: ^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[*-+_!@#$%^&.,?])[A-Za-z\d*-+_!@#$%^&.,?]{6,}$
#         regex_text:
#             en: "It must be at least 6 characters; including at least one uppercase, one lowercase, one digit, and one of these special characters: *-+_!@#$%^&.,?"
#             fr: "Il doit comporter au moins 6 caractères ; dont au moins une majuscule, une minuscule, un chiffre et un de ces caractères spéciaux : *-+_!@#$%^&.,?."

set -e

# https://docs.mautic.org/en/6.x/getting_started/how_to_install_mautic.html#

ad_install_pecl redis

COMPOSER_CACHE_DIR=/dev/null composer2 create-project mautic/core

cd core

# Install
php bin/console mautic:install --db_driver="pdo_mysql" --db_host="$DATABASE_HOST" --db_port="3306" --db_name="$DATABASE_NAME" --db_user="$DATABASE_USERNAME" --db_password="$DATABASE_PASSWORD" --admin_username="$FORM_ADMIN_USERNAME" --admin_email="$FORM_EMAIL" --admin_password="$FORM_ADMIN_PASSWORD" https://$INSTALL_URL

# Clean install environment
cd
rm -rf .config .local .subversion vendor
shopt -s dotglob
mv core/* .
rmdir core
