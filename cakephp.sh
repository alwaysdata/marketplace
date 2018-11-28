#!/bin/bash

# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}'
#     php_version: '7.2'
#     php_ini: extension=intl.so

set -e

# https://book.cakephp.org/3.0/en/installation.html

echo 'Y' | composer create-project cakephp/app default

sed -i "1i \ \ \ \ RewriteBase $INSTALL_URL_PATH" default/.htaccess
sed -i "1i \ \ \ \ RewriteBase $INSTALL_URL_PATH" default/webroot/.htaccess

rm -rf .composer

shopt -s dotglob nullglob
mv default/* .
rmdir default
