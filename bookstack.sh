#!/bin/bash

# Declare site in YAML, as documented on the documentation: https://help.alwaysdata.com/en/marketplace/build-application-script/
# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}/public'
#     php_version: '8.4'
# database:
#     type: mysql
# requirements:
#     disk: 100

set -e

# https://www.bookstackapp.com/docs/admin/installation/

# Download and install dependancies
git clone https://github.com/BookStackApp/BookStack.git --branch release --depth 1 --single-branch
cd BookStack

COMPOSER_CACHE_DIR=/dev/null composer2 install --no-dev

# Configuration
sed -i "s|APP_URL=https://example.com|APP_URL=https://$INSTALL_URL|" .env.example
sed -i "s|DB_HOST=localhost|DB_HOST=$DATABASE_HOST|" .env.example
sed -i "s|DB_DATABASE=database_database|DB_DATABASE=$DATABASE_NAME|" .env.example
sed -i "s|DB_USERNAME=database_username|DB_USERNAME=$DATABASE_USERNAME|" .env.example
sed -i "s|DB_PASSWORD=database_user_password|DB_PASSWORD=$DATABASE_PASSWORD|" .env.example

mv .env.example .env

php artisan key:generate --force
php artisan migrate --force

# Clean install environment
cd ..
rm -rf .config .local
shopt -s dotglob
mv BookStack/* .
rmdir BookStack

# Default credentials for first login: admin@admin.com / password
