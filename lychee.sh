#!/bin/bash

# Declare site in YAML, as documented on the documentation: https://help.alwaysdata.com/en/marketplace/build-application-script/
# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}/public'
#     php_version: '8.5'
#     php_ini: |
#         extension={INSTALL_PATH}/imagick-8.5.so
#         max_execution_time=200
#         zend.assertions=-1
#         extension = ldap.so
#     ssl: true
# database:
#     type: mysql
# requirements:
#     disk: 70

set -e

# https://lycheeorg.dev/docs/#server-requirements
ad_install_pecl imagick

# Download
wget -O- --no-hsts https://github.com/LycheeOrg/Lychee/releases/download/v7.5.0/Lychee.zip | bsdtar --strip-components=1 -xf -

# Configuration
sed -i "s|http://localhost|https://$INSTALL_URL|" .env.example
sed -i "s|DB_CONNECTION=sqlite|DB_CONNECTION=mysql|" .env.example
sed -i "s|DB_HOST=|DB_HOST=$DATABASE_HOST|" .env.example
sed -i "s|#DB_DATABASE=|DB_DATABASE=$DATABASE_NAME|" .env.example
sed -i "s|DB_USERNAME=|DB_USERNAME=$DATABASE_USERNAME|" .env.example
sed -i "s|DB_PASSWORD=|DB_PASSWORD=$DATABASE_PASSWORD|" .env.example

mv .env.example .env

php artisan key:generate

# Install
curl http://$INSTALL_URL/install/migrate
