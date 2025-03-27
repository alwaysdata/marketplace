#!/bin/bash

# Declare site in YAML, as documented on the documentation: https://help.alwaysdata.com/en/marketplace/build-application-script/
# site:
#     type: php
#     php_version: '8.3'
#     path: '{INSTALL_PATH_RELATIVE}'
# database:
#     type: postgresql
# requirements:
#     disk: 50

set -e

# Download
wget -O- --no-hsts https://github.com/kanboard/kanboard/archive/refs/tags/v1.2.44.tar.gz | tar -xz --strip-components=1

# Configuration
# https://docs.kanboard.org/en/latest/admin_guide/config_file.html
mv config.default.php config.php

sed -i "s|replace-me@kanboard.local|$USER@$RESELLER_DOMAIN|" config.php
sed -i "s|'DB_DRIVER', 'sqlite'|'DB_DRIVER', 'postgres'|" config.php
sed -i "s|'DB_USERNAME', 'root'|'DB_USERNAME', '$DATABASE_USERNAME'|" config.php
sed -i "s|'DB_PASSWORD', ''|'DB_PASSWORD', '$DATABASE_PASSWORD'|" config.php
sed -i "s|'DB_HOSTNAME', 'localhost'|'DB_HOSTNAME', '$DATABASE_HOST'|" config.php
sed -i "s|'DB_NAME', 'kanboard'|'DB_NAME', '$DATABASE_NAME'|" config.php

# Default credentials for first login: admin / admin
