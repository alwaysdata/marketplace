#!/bin/bash

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

wget -O- https://sourceforge.net/projects/phplist/files/phplist/3.6.14/phplist-3.6.14.tgz | tar -xz --strip-components=0

sed -i "s|database_host = 'localhost';|database_host = '$DATABASE_HOST';|" phplist-3.6.14/public_html/lists/config/config.php
sed -i "s|database_name = 'phplistdb';|database_name = '$DATABASE_NAME';|" phplist-3.6.14/public_html/lists/config/config.php
sed -i "s|database_user = 'phplist';|database_user = '$DATABASE_USERNAME';|" phplist-3.6.14/public_html/lists/config/config.php
sed -i "s|database_password = 'phplist';|database_password = '$DATABASE_PASSWORD';|" phplist-3.6.14/public_html/lists/config/config.php
sed -i "s|define('PHPMAILERHOST', 'localhost');|//define('PHPMAILERHOST', 'localhost');|" phplist-3.6.14/public_html/lists/config/config.php
sed -i "s|define('PHPMAILERPORT',2500);|//define('PHPMAILERPORT',2500);|" phplist-3.6.14/public_html/lists/config/config.php
sed -i "s|define('PHPMAILER_SECURE',false);|//define('PHPMAILER_SECURE',false);|" phplist-3.6.14/public_html/lists/config/config.php
sed -i "s|listbounces@yourdomain|$USER@$RESELLER_DOMAIN|" phplist-3.6.14/public_html/lists/config/config.php
sed -i "s|/var/mail/listbounces|$INSTALL_PATH/var/mail/listbounces|" phplist-3.6.14/public_html/lists/config/config.php
echo "\$pageroot = '$INSTALL_URL_PATH';" >> phplist-3.6.14/public_html/lists/config/config.php

if [ "$INSTALL_URL_PATH" = "/" ]
then
sed -i "s|\$pageroot = '/';|\$pageroot = '';|" phplist-3.6.14/public_html/lists/config/config.php
fi

ADMIN_PASSWORD="$FORM_ADMIN_PASSWORD" ADMIN_EMAIL="$FORM_ADMIN_EMAIL" php phplist-3.6.14/public_html/lists/admin/index.php -p initialise -c $INSTALL_PATH/phplist-3.6.14/public_html/lists/config/config.php

shopt -s dotglob
mv phplist-3.6.14/public_html/lists/* .
rm -rf  .wget-hsts phplist-3.6.14

# default username: admin
