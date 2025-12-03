#!/bin/bash

# Declare site in YAML, as documented on the documentation: https://help.alwaysdata.com/en/marketplace/build-application-script/
# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}/public/'
#     php_version: '8.4'
# requirements:
#     disk: 100

set -e

# https://symfony.com/doc/current/setup.html
COMPOSER_CACHE_DIR=/dev/null composer2 create-project symfony/skeleton default
cd default
echo "n"|COMPOSER_CACHE_DIR=/dev/null composer2 require webapp

# Clean install environment
cd
rm -rf .config .local .subversion

shopt -s dotglob
mv default/* .
rmdir default
