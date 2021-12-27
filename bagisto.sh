#!/bin/bash

# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}/bagisto/public'
#     php_version: '8.0'
#     php_ini: |
#         memory_limit=4096M
#         extension=intl.so
#         max_execution_time=360
# database:
#     type: mysql
# requirements:
#     disk: 190

set -e

COMPOSER_CACHE_DIR=/dev/null composer2 create-project bagisto/bagisto

sed -i "s|APP_URL=http://localhost|APP_URL=http://$INSTALL_URL|" bagisto/.env
sed -i "s|DB_HOST=127.0.0.1|DB_HOST=$DATABASE_HOST|" bagisto/.env
sed -i "s|DB_DATABASE=|DB_DATABASE=$DATABASE_NAME|" bagisto/.env
sed -i "s|DB_USERNAME=|DB_USERNAME=$DATABASE_USERNAME|" bagisto/.env
sed -i "s|DB_PASSWORD=|DB_PASSWORD=$DATABASE_PASSWORD|" bagisto/.env

cd bagisto
php artisan bagisto:install

# default credentials: admin@example.com / admin123
