#!/bin/bash

# Declare site in YAML, as documented on the documentation: https://help.alwaysdata.com/en/marketplace/build-application-script/
# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}'
#     php_version: '8.1'
# database:
#     type: mysql
# requirements:
#     disk: 50

set -e

# https://docs.backdropcms.org/documentation/system-requirements

# Download
COMPOSER_CACHE_DIR=/dev/null composer2 create-project backdrop/backdrop default --no-plugins

# Configuration
sed -i "s|user:pass@localhost/database_name|$DATABASE_USERNAME:$DATABASE_PASSWORD@$DATABASE_HOST/$DATABASE_NAME|" default/settings.php

# Clean the install environment
rm -rf .config .local .subversion
shopt -s dotglob
mv default/* .
rmdir default
