#!/bin/bash

# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}'
#     php_version: '8.3'
# database:
#     type: mysql
# requirements:
#     disk: 80

set -e

# https://leantime.io/

wget -O- --no-hsts https://github.com/Leantime/leantime/releases/download/v3.0.3/Leantime-v3.0.3.tar.gz | tar -xz --strip-components=1

cp config/configuration.sample.php config/configuration.php

sed -i "s|dbHost = 'localhost'|dbHost = '$DATABASE_HOST'|" config/configuration.php
sed -i "s|dbUser = ''|dbUser = '$DATABASE_USERNAME'|" config/configuration.php
sed -i "s|dbPassword = ''|dbPassword = '$DATABASE_PASSWORD'|" config/configuration.php
sed -i "s|dbDatabase = ''|dbDatabase = '$DATABASE_NAME'|" config/configuration.php

if [ "$INSTALL_URL_PATH" != "/" ]
then
	sed -i "s|#RewriteBase /leantime/|RewriteBase $INSTALL_URL_PATH|" public/.htaccess
	sed -i "s|appUrl = \"\"|appUrl = \"$INSTALL_URL_PATH\"|" config/configuration.php
fi

# First access to the website redirects to a graphical interface to create login username
