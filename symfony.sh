#!/bin/bash

# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}/public/'
#     php_version: '8.3'
# requirements:
#     disk: 100

set -e

# https://symfony.com/doc/current/setup.html
COMPOSER_CACHE_DIR=/dev/null composer2 create-project symfony/skeleton default
cd default
echo "n"|COMPOSER_CACHE_DIR=/dev/null composer2 require webapp

cd
rm -rf .config .local .subversion

shopt -s dotglob
mv default/* .
rmdir default
