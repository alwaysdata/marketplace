#!/bin/bash

# Declare site in YAML, as documented on the documentation: https://help.alwaysdata.com/en/marketplace/build-application-script/
# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}/public/'
#     php_version: '8.3'
#     php_ini: |
#         extension=sqlite3.so
#         extension=pdo_sqlite.so
# requirements:
#     disk: 80

set -e

# https://laravel.com/docs/

COMPOSER_CACHE_DIR=/dev/null composer2 create-project laravel/laravel default

sed -i "s|APP_URL=http://localhost|APP_URL=http://$INSTALL_URL|" default/.env

# Clean install environment
rm -rf .config .subversion .local
shopt -s dotglob
mv default/* .
rmdir default
