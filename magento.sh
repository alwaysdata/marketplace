#!/bin/bash

# Declare site in YAML, as documented on the documentation: https://help.alwaysdata.com/en/marketplace/build-application-script/
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
#         max_length: 255
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
#         min_length: 8
#         max_length: 255
#         regex: ^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z]{8,}$
#         regex_text: "Il doit comporter au moins 8 caractères ; dont au moins une majuscule, une minuscule et un chiffre."

set -e

# Download
COMPOSER_CACHE_DIR=/dev/null composer2 create-project magento/community-edition community-edition 2.3.7-p4 --no-install

cd community-edition

COMPOSER_CACHE_DIR=/dev/null composer2 config --no-plugins allow-plugins.laminas/laminas-dependency-plugin true
COMPOSER_CACHE_DIR=/dev/null composer2 config --no-plugins allow-plugins.magento/magento-composer-installer true
COMPOSER_CACHE_DIR=/dev/null composer2 config --no-plugins allow-plugins.dealerdirect/phpcodesniffer-composer-installer true

COMPOSER_CACHE_DIR=/dev/null composer2 install -n

# Install
# CLI: http://devdocs.magento.com/guides/v2.3/install-gde/install/cli/install-cli-install.html
php bin/magento setup:install --admin-firstname="$FORM_ADMIN_FIRSTNAME" --admin-lastname="$FORM_ADMIN_LASTNAME" --admin-email="$FORM_EMAIL" --admin-user="$FORM_ADMIN_USERNAME" --admin-password="$FORM_ADMIN_PASSWORD" --db-host="$DATABASE_HOST" --db-name="$DATABASE_NAME" --db-user="$DATABASE_USERNAME" --db-password="$DATABASE_PASSWORD" --backend-frontname=admin

# Handle base URL
sed -i "s|    #RewriteBase.*|    RewriteBase $INSTALL_URL_PATH|" .htaccess
sed -i "s|    #RewriteBase.*|    RewriteBase $INSTALL_URL_PATH|" pub/.htaccess
sed -i "s|    #RewriteBase.*|    RewriteBase $INSTALL_URL_PATH/pub/static/|" pub/static/.htaccess

# Clean install environment
cd
rm -rf .config .local .subversion
shopt -s dotglob
mv community-edition/* .
rmdir community-edition

# Magento 2.4 requires Elasticsearch - https://devdocs.magento.com/guides/v2.4/install-gde/system-requirements.html - which is not compliant with the Public Cloud.
