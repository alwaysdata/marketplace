#!/bin/bash

# Declare site in YAML, as documented on the documentation: https://help.alwaysdata.com/en/marketplace/build-application-script/
# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}'
#     php_version: '8.3'
# requirements:
#     disk: 45

set -e

# https://learn.getgrav.org/17/basics/requirements
COMPOSER_CACHE_DIR=/dev/null composer2 create-project getgrav/grav default

# Clean install environment
rm -rf .composer .config .local .subversion
shopt -s dotglob
mv default/* .
rmdir default
