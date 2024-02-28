#!/bin/bash

# Declare site in YAML, as documented on the documentation: https://help.alwaysdata.com/en/marketplace/build-application-script/
# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}'
#     php_version: '8.3'
# database:
#     type: mysql
# requirements:
#     disk: 80

set -e

# Download
wget -O- --no-hsts https://github.com/Leantime/leantime/releases/download/v3.0.7/Leantime-v3.0.7.tar.gz | tar -xz --strip-components=1

# Configuration
cp config/configuration.sample.php config/configuration.php

sed -i "s|dbHost = 'localhost'|dbHost = '$DATABASE_HOST'|" config/configuration.php
sed -i "s|dbUser = ''|dbUser = '$DATABASE_USERNAME'|" config/configuration.php
sed -i "s|dbPassword = ''|dbPassword = '$DATABASE_PASSWORD'|" config/configuration.php
sed -i "s|dbDatabase = ''|dbDatabase = '$DATABASE_NAME'|" config/configuration.php

# Handle addresses with subdirectories bases URL
if [ "$INSTALL_URL_PATH" != "/" ]
then
	sed -i "s|#RewriteBase /leantime/|RewriteBase $INSTALL_URL_PATH|" public/.htaccess
	sed -i "s|appUrl = \"\"|appUrl = \"$INSTALL_URL_PATH\"|" config/configuration.php
fi
