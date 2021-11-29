#!/bin/bash

# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}/public/'
#     php_version: '8.0'
# requirements:
#     disk: 80

set -e

# https://symfony.com/doc/current/setup.html
COMPOSER_CACHE_DIR=/dev/null composer2 create-project symfony/website-skeleton default

rm -rf .composer

shopt -s dotglob
mv default/* .
rmdir default
