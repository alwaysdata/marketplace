#!/bin/bash

# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}'
#     php_version: '7.2'
# database:
#     type: mysql
# form:
#     title:
#         label: Site title
#         max_length: 255

set -e

# Joomlatools console: https://www.joomlatools.com/developer/tools/console/commands/

composer global require joomlatools/console

php .composer/vendor/bin/joomla site:download --www="$INSTALL_PATH" default
php .composer/vendor/bin/joomla site:install --www="$INSTALL_PATH" --mysql-login="$DATABASE_USERNAME":"$DATABASE_PASSWORD" --mysql-host="$DATABASE_HOST" --mysql-database="$DATABASE_NAME" --skip-exists-check --drop default

sed -i "s|'default'|'$FORM_TITLE'|" joomla-new/configuration.php

rm -rf .composer .joomlatools .subversion

shopt -s dotglob nullglob
mv default/* .
rmdir default
