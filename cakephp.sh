#!/bin/bash

# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}'
#     php_version: '8'
#     php_ini: extension=intl.so

set -e

# https://book.cakephp.org/4/en/installation.html

echo 'Y' | COMPOSER_CACHE_DIR=/dev/null composer2 create-project cakephp/app default

sed -i "1i \ \ \ \ RewriteBase $INSTALL_URL_PATH" default/.htaccess
sed -i "1i \ \ \ \ RewriteBase $INSTALL_URL_PATH" default/webroot/.htaccess

rm -rf .composer

shopt -s dotglob
mv default/* .
rmdir default
