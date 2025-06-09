#!/bin/bash

# Declare site in YAML, as documented on the documentation: https://help.alwaysdata.com/en/marketplace/build-application-script/
# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}/public'
#     php_version: '8.3'
# database:
#     type: mysql
# requirements:
#     disk: 80

set -e

# Download
wget -O- --no-hsts https://github.com/Leantime/leantime/releases/download/v3.5.5/Leantime-v3.5.5.tar.gz | tar -xz --strip-components=1

# Configuration
cp config/sample.env config/.env

sed -i "s|LEAN_DB_HOST = 'localhost'|LEAN_DB_HOST = '$DATABASE_HOST'|" config/.env
sed -i "s|LEAN_DB_USER = ''|LEAN_DB_USER = '$DATABASE_USERNAME'|" config/.env
sed -i "s|LEAN_DB_PASSWORD = ''|LEAN_DB_PASSWORD = '$DATABASE_PASSWORD'|" config/.env
sed -i "s|LEAN_DB_DATABASE = ''|LEAN_DB_DATABASE = '$DATABASE_NAME'|" config/.env

# Handle addresses with subdirectories bases URL
if [ "$INSTALL_URL_PATH" != "/" ]
then
	sed -i "s|#RewriteBase /leantime/|RewriteBase $INSTALL_URL_PATH|" public/.htaccess
	sed -i "s|LEAN_APP_URL = ''|LEAN_APP_URL = '$INSTALL_URL_PATH'|" config/.env
fi
