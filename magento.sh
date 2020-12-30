#!/bin/bash

# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}'
#     php_version: '7.3'
#     php_ini: |
#         extension=intl.so
#         extension=sockets.so
# database:
#     type: mysql
# form:
#     admin_firstname:
#         label: Administrator first name
#         max_length: 40
#     admin_lastname:
#         label: Administrator last name
#         max_length: 40
#     email:
#         type: email
#         label: Email
#     admin_username:
#         label: Administrator username
#         max_length: 40
#     admin_password:
#         type: password
#         label: Administrator password
#         min_length: 7
#         regex: ^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z]{8,}$

set -e

COMPOSER_CACHE_DIR=/dev/null composer create-project magento/community-edition community-edition 2.3.6

# Magento CLI: http://devdocs.magento.com/guides/v2.3/install-gde/install/cli/install-cli-install.html

php community-edition/bin/magento setup:install --admin-firstname="$FORM_ADMIN_FIRSTNAME" --admin-lastname="$FORM_ADMIN_LASTNAME" --admin-email="$FORM_EMAIL" --admin-user="$FORM_ADMIN_USERNAME" --admin-password="$FORM_ADMIN_PASSWORD" --db-host="$DATABASE_HOST" --db-name="$DATABASE_NAME" --db-user="$DATABASE_USERNAME" --db-password="$DATABASE_PASSWORD" --backend-frontname=admin

sed -i "s|    #RewriteBase.*|    RewriteBase $INSTALL_URL_PATH|" community-edition/.htaccess
sed -i "s|    #RewriteBase.*|    RewriteBase $INSTALL_URL_PATH|" community-edition/pub/.htaccess
sed -i "s|    #RewriteBase.*|    RewriteBase $INSTALL_URL_PATH/pub/static/|" community-edition/pub/static/.htaccess

rm -rf .composer

shopt -s dotglob nullglob
mv community-edition/* .
rmdir community-edition
