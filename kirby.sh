#!/bin/bash

# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}'
#     php_version: '8.0'
# requirements:
#     disk: 20

set -e

COMPOSER_CACHE_DIR=/dev/null composer2 create-project getkirby/starterkit default

rm -rf .config .local .subversion
shopt -s dotglob
mv default/* .
rmdir default
