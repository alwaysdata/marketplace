#!/bin/bash

# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}'
#     php_version: '7.4'
# database:
#     type: mysql
# requirements:
#     disk: 50

set -e

COMPOSER_CACHE_DIR=/dev/null composer2 create-project backdrop/backdrop default

sed -i "s|user:pass@localhost/database_name|$DATABASE_USERNAME:$DATABASE_PASSWORD@$DATABASE_HOST/$DATABASE_NAME|" default/settings.php

rm -rf .config .local .subversion
shopt -s dotglob
mv default/* .
rmdir default

# After is GUI (site, admin credentials)
