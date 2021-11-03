#!/bin/bash

# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}'
#     php_version: '7.4'
#     php_ini: |
#         extension=intl.so
#         extension=sockets.so
# database:
#     type: mysql
# requirements:
#     disk: 470
# form:
#     admin_firstname:
#         label:
#             en: Administrator first name
#             fr: Prénom de l'administrateur
#         max_length: 40
#     admin_lastname:
#         label:
#             en: Administrator last name
#             fr: Nom de l'administrateur
#         max_length: 40
#     email:
#         type: email
#         label:
#             en: Email
#             fr: Email
#     admin_username:
#         label:
#             en: Administrator username
#             fr: Nom d'utilisateur de l'administrateur
#         max_length: 40
#     admin_password:
#         type: password
#         label:
#             en: Administrator password
#             fr: Mot de passe de l'administrateur
#         min_length: 7
#         regex: ^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z]{8,}$

set -e

COMPOSER_CACHE_DIR=/dev/null composer create-project magento/community-edition community-edition 2.3.7-p2

# Magento CLI: http://devdocs.magento.com/guides/v2.3/install-gde/install/cli/install-cli-install.html

php community-edition/bin/magento setup:install --admin-firstname="$FORM_ADMIN_FIRSTNAME" --admin-lastname="$FORM_ADMIN_LASTNAME" --admin-email="$FORM_EMAIL" --admin-user="$FORM_ADMIN_USERNAME" --admin-password="$FORM_ADMIN_PASSWORD" --db-host="$DATABASE_HOST" --db-name="$DATABASE_NAME" --db-user="$DATABASE_USERNAME" --db-password="$DATABASE_PASSWORD" --backend-frontname=admin

sed -i "s|    #RewriteBase.*|    RewriteBase $INSTALL_URL_PATH|" community-edition/.htaccess
sed -i "s|    #RewriteBase.*|    RewriteBase $INSTALL_URL_PATH|" community-edition/pub/.htaccess
sed -i "s|    #RewriteBase.*|    RewriteBase $INSTALL_URL_PATH/pub/static/|" community-edition/pub/static/.htaccess

rm -rf .composer

shopt -s dotglob
mv community-edition/* .
rmdir community-edition

# Magento 2.4 requires Elasticsearch which is not compliant with the Public Cloud.
