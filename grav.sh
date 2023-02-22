#!/bin/bash

# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}'
#     php_version: '8.2'
# requirements:
#     disk: 45

set -e

COMPOSER_CACHE_DIR=/dev/null composer2 create-project getgrav/grav default
rm -rf .composer .config .local .subversion

shopt -s dotglob
mv default/* .
rmdir default
