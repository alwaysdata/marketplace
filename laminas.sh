#!/bin/bash

# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}/public/'
#     php_version: '8.0'
# requirements:
#     disk: 15

set -e

# https://docs.laminas.dev/tutorials/getting-started/skeleton-application/

echo 'Y' | COMPOSER_CACHE_DIR=/dev/null composer2 create-project -s dev laminas/laminas-mvc-skeleton default

shopt -s dotglob
mv default/* .
rmdir default

COMPOSER_CACHE_DIR=/dev/null composer2 development-disable

rm -rf .composer .subversion
