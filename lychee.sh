#!/bin/bash

# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}/public'
#     php_version: '8.2'
#     php_ini: extension=intl.so
# database:
#     type: mysql
# requirements:
#     disk: 70

set -e

wget -O- https://github.com/LycheeOrg/Lychee/releases/download/v4.11.1/Lychee.zip | bsdtar --strip-components=1 -xf -

sed -i "s|http://localhost|http://$INSTALL_URL|" .env.example
sed -i "s|DB_CONNECTION=sqlite|DB_CONNECTION=mysql|" .env.example
sed -i "s|DB_HOST=|DB_HOST=$DATABASE_HOST|" .env.example
sed -i "s|#DB_DATABASE=|DB_DATABASE=$DATABASE_NAME|" .env.example
sed -i "s|DB_USERNAME=|DB_USERNAME=$DATABASE_USERNAME|" .env.example
sed -i "s|DB_PASSWORD=|DB_PASSWORD=$DATABASE_PASSWORD|" .env.example

mv .env.example .env

php artisan key:generate
curl http://$INSTALL_URL/install/migrate

rm .wget-hsts
