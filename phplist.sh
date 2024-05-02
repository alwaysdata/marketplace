#!/bin/bash

# Declare site in YAML, as documented on the documentation: https://help.alwaysdata.com/en/marketplace/build-application-script/
# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}'
#     php_version: '8.3'
#     php_ini: extension=imap.so
# database:
#     type: mysql
# requirements:
#     disk: 120
# form:
#     admin_email:
#         type: email
#         label:
#             en: Administrator email
#             fr: Email de l'administrateur
#     admin_password:
#         type: password
#         label:
#             en: Administrator password
#             fr: Mot de passe de l'administrateur

set -e

# https://www.phplist.org/manual/books/phplist-manual/page/installing-phplist-manually

# Download
wget -O- --no-hsts https://sourceforge.net/projects/phplist/files/phplist/3.6.15/phplist-3.6.15.tgz | tar -xz --strip-components=0

# Configuration
sed -i "s|database_host = 'localhost';|database_host = '$DATABASE_HOST';|" phplist-3.6.15/public_html/lists/config/config.php
sed -i "s|database_name = 'phplistdb';|database_name = '$DATABASE_NAME';|" phplist-3.6.15/public_html/lists/config/config.php
sed -i "s|database_user = 'phplist';|database_user = '$DATABASE_USERNAME';|" phplist-3.6.15/public_html/lists/config/config.php
sed -i "s|database_password = 'phplist';|database_password = '$DATABASE_PASSWORD';|" phplist-3.6.15/public_html/lists/config/config.php
sed -i "s|define('PHPMAILERHOST', 'localhost');|//define('PHPMAILERHOST', 'localhost');|" phplist-3.6.15/public_html/lists/config/config.php
sed -i "s|define('PHPMAILERPORT',2500);|//define('PHPMAILERPORT',2500);|" phplist-3.6.15/public_html/lists/config/config.php
sed -i "s|define('PHPMAILER_SECURE',false);|//define('PHPMAILER_SECURE',false);|" phplist-3.6.15/public_html/lists/config/config.php
sed -i "s|listbounces@yourdomain|$USER@$RESELLER_DOMAIN|" phplist-3.6.15/public_html/lists/config/config.php
sed -i "s|/var/mail/listbounces|$INSTALL_PATH/var/mail/listbounces|" phplist-3.6.15/public_html/lists/config/config.php
echo "\$pageroot = '$INSTALL_URL_PATH';" >> phplist-3.6.15/public_html/lists/config/config.php

# Handle root base URL
if [ "$INSTALL_URL_PATH" = "/" ]
then
sed -i "s|\$pageroot = '/';|\$pageroot = '';|" phplist-3.6.15/public_html/lists/config/config.php
fi

# Create admin user
ADMIN_PASSWORD="$FORM_ADMIN_PASSWORD" ADMIN_EMAIL="$FORM_ADMIN_EMAIL" php phplist-3.6.15/public_html/lists/admin/index.php -p initialise -c $INSTALL_PATH/phplist-3.6.15/public_html/lists/config/config.php

# Clean install environment
shopt -s dotglob
mv phplist-3.6.15/public_html/lists/* .
rm -rf phplist-3.6.15

# Default username: admin
