#!/bin/bash

# Declare site in YAML, as documented on the documentation: https://help.alwaysdata.com/en/marketplace/build-application-script/
# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}'
#     php_version: '8.3'
# requirements:
#     disk: 20

set -e

# https://getkirby.com/docs/reference/system/requirements

COMPOSER_CACHE_DIR=/dev/null composer2 create-project getkirby/starterkit default

# Clean install environment
rm -rf .config .local .subversion
shopt -s dotglob
mv default/* .
rmdir default
