#!/bin/bash

# Declare site in YAML, as documented on the documentation: https://help.alwaysdata.com/en/marketplace/build-application-script/
# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}'
#     php_version: '8.2'
# database:
#     type: mysql
# requirements:
#     disk: 100
# form:
#     title:
#         label:
#             en: Site title
#             fr: Titre du site
#         max_length: 255

set -e

# https://downloads.joomla.org/technical-requirements
# Joomlatools CLI: https://www.joomlatools.com/developer/tools/console/commands/

COMPOSER_CACHE_DIR=/dev/null composer2 global require joomlatools/console

php .config/composer/vendor/bin/joomla site:download --www="$INSTALL_PATH" default

php .config/composer/vendor/bin/joomla site:install --www="$INSTALL_PATH" --mysql-login="$DATABASE_USERNAME":"$DATABASE_PASSWORD" --mysql-host="$DATABASE_HOST" --mysql-database="$DATABASE_NAME" --skip-exists-check --drop default

sed -i "s|\/default\/|\/|" default/configuration.php
sed -i "s|name = 'default';|name = '$FORM_TITLE';|" default/configuration.php
sed -i "s|admin@example.com|$USER@$RESELLER_DOMAIN|" default/configuration.php

# Clean install environment
rm -rf .config .local .subversion .joomlatools
shopt -s dotglob
mv default/* .
rmdir default
