#!/bin/bash

# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}/public/'
#     php_version: '8'

set -e

# https://symfony.com/doc/current/setup.html
COMPOSER_CACHE_DIR=/dev/null composer2 create-project symfony/website-skeleton default

rm -rf .composer

shopt -s dotglob nullglob
mv default/* .
rmdir default
