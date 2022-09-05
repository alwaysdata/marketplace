#!/bin/bash

# site:
#     type: php
#     php_version: '8.1'
#     path: '{INSTALL_PATH_RELATIVE}'
# database:
#     type: postgresql
# requirements:
#     disk: 50

set -e

wget -O- https://github.com/kanboard/kanboard/archive/refs/tags/v1.2.23.tar.gz | tar -xz --strip-components=1

# https://docs.kanboard.org/en/latest/admin_guide/config_file.html
mv config.default.php config.php

sed -i "s|replace-me@kanboard.local|$USER@$RESELLER_DOMAIN|" config.php
sed -i "s|'DB_DRIVER', 'sqlite'|'DB_DRIVER', 'postgres'|" config.php
sed -i "s|'DB_USERNAME', 'root'|'DB_USERNAME', '$DATABASE_USERNAME'|" config.php
sed -i "s|'DB_PASSWORD', ''|'DB_PASSWORD', '$DATABASE_PASSWORD'|" config.php
sed -i "s|'DB_HOSTNAME', 'localhost'|'DB_HOSTNAME', '$DATABASE_HOST'|" config.php
sed -i "s|'DB_NAME', 'kanboard'|'DB_NAME', '$DATABASE_NAME'|" config.php

rm .wget-hsts

# default credentials: admin / admin
