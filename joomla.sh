#!/bin/bash

# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}'
#     php_version: '7.4'
# database:
#     type: mysql
# form:
#     title:
#         label: Site title
#         max_length: 255

set -e

# https://downloads.joomla.org/technical-requirements
# Joomlatools console: https://www.joomlatools.com/developer/tools/console/commands/

COMPOSER_CACHE_DIR=/dev/null composer2 global require joomlatools/console

php .config/composer/vendor/bin/joomla site:download --www="$INSTALL_PATH" default
php .config/composer/vendor/bin/joomla site:install --www="$INSTALL_PATH" --mysql-login="$DATABASE_USERNAME":"$DATABASE_PASSWORD" --mysql-host="$DATABASE_HOST" --mysql-database="$DATABASE_NAME" --skip-exists-check --drop default

sed -i "s|'default'|'$FORM_TITLE'|" default/configuration.php

rm -rf .config .local .subversion

shopt -s dotglob nullglob
mv default/* .
rmdir default
