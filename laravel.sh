#!/bin/bash

# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}/public/'
#     php_version: '8'

set -e

# https://laravel.com/docs/

COMPOSER_CACHE_DIR=/dev/null composer2 create-project --prefer-dist laravel/laravel default
# composer require/laravel new fails because of tty

sed -i "s|APP_URL=http://localhost|APP_URL=http://$INSTALL_URL|" default/.env

rm -rf .composer .subversion vendor composer.json composer.lock

shopt -s dotglob nullglob
mv default/* .
rmdir default
