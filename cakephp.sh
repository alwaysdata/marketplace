#!/bin/bash

# Declare site in YAML, as documented on the documentation: https://help.alwaysdata.com/en/marketplace/build-application-script/
# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}'
#     php_version: '8.3'
# requirements:
#     disk: 50

set -e

# https://book.cakephp.org/5/en/installation.html

echo 'Y' | COMPOSER_CACHE_DIR=/dev/null composer2 create-project cakephp/app default

sed -i "1i \ \ \ \ RewriteBase $INSTALL_URL_PATH" default/.htaccess
sed -i "1i \ \ \ \ RewriteBase $INSTALL_URL_PATH" default/webroot/.htaccess

cd default

COMPOSER_CACHE_DIR=/dev/null composer2 require cakephp/cakephp

cd

# Clean install environment
rm -rf .composer
shopt -s dotglob
mv default/* .
rmdir default
