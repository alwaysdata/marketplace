#!/bin/bash

# Declare site in YAML, as documented on the documentation: https://help.alwaysdata.com/en/marketplace/build-application-script/
# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}'
#     php_version: '8.4'
# database:
#     type: mysql
# requirements:
#     disk: 120
# form:
#     title:
#         label:
#             en: Site title
#             fr: Titre du site
#         max_length: 255
#     admin_email:
#         type: email
#         label:
#             en: Administrator email
#             fr: Email de l'administrateur
#         max_length: 255
#     admin_name:
#         label:
#             en: Administrator name
#             fr: Nom de l'administrateur
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
#         min_length: 12
#         max_length: 255

set -e

# https://manual.joomla.org/docs/next/get-started/technical-requirements/
# Joomlatools CLI: https://www.joomlatools.com/developer/tools/console/commands/
# https://docs-core.sandbox.joomla.org/user-manual/command-line-interface/command-line-interface-joomla-cli-installation

COMPOSER_CACHE_DIR=/dev/null composer2 global require joomlatools/console

php .config/composer/vendor/bin/joomla site:download --www="$INSTALL_PATH" default

cd default

 php installation/joomla.php install --site-name="$FORM_TITLE" --admin-user="$FORM_ADMIN_NAME" --admin-username="$FORM_ADMIN_USERNAME" --admin-password="$FORM_ADMIN_PASSWORD" --admin-email=$FORM_ADMIN_EMAIL --db-type=mysqli --db-host=$DATABASE_HOST --db-user=$DATABASE_USERNAME --db-pass="$DATABASE_PASSWORD" --db-name=$DATABASE_NAME

sed -i "s|\/default\/|\/|" configuration.php

# Clean install environment
cd
rm -rf .config .local .subversion .joomlatools
shopt -s dotglob
mv default/* .
rmdir default
