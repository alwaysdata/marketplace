#!/bin/bash

# Declare site in YAML, as documented on the documentation: https://help.alwaysdata.com/en/marketplace/build-application-script/
# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}/public/'
#     php_version: '8.3'
# requirements:
#     disk: 15

set -e

# https://docs.laminas.dev/tutorials/getting-started/skeleton-application/

echo 'Y' | COMPOSER_CACHE_DIR=/dev/null composer2 create-project -s dev laminas/laminas-mvc-skeleton default

shopt -s dotglob
mv default/* .
rmdir default

COMPOSER_CACHE_DIR=/dev/null composer2 development-disable

# Clean install environment
rm -rf .composer .subversion
