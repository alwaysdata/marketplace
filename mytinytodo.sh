#!/bin/bash

# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}'
#     php_version: '8'
# database:
#     type: mysql
# form:
#     language:
#         type: choices
#         label: Language
#         initial: en
#         choices:
#             de: German
#             en: English
#             es: Spanish
#             fr: French
#             it: Italian

set -e

wget -O- https://github.com/maxpozdeev/mytinytodo/releases/download/v1.6.5/mytinytodo-v1.6.5.zip | bsdtar --strip-components=1 -xf -

sed -i "s|\['db'\] = '';|\['db'\] = 'mysql';|" db/config.php
sed -i "s|localhost|$DATABASE_HOST|" db/config.php
sed -i "s|\['mysql.db'\] = \"mytinytodo\";|\['mysql.db'\] = '$DATABASE_NAME';|" db/config.php
sed -i "s|\['mysql.user'\] = \"user\"|\['mysql.user'\] = '$DATABASE_USERNAME';|" db/config.php
sed -i "s|\['mysql.password'\] = \"\";|\['mysql.password'\] = '$DATABASE_PASSWORD';|" db/config.php
sed -i "s|\['lang'\] = \"en\"|\['lang'\] = \"$FORM_LANGUAGE\"|" db/config.php
sed -i "s|\['timezone'\] = 'UTC'|\['timezone'\] = 'Europe/Paris'|" db/config.php

curl -X POST -F installdb=mysql -F mysql_host='$DATABASE_HOST' -F mysql-db='$DATABASE_NAME' -F mysql_user='$DATABASE_USERNAME' -F mysql_password='$DATABASE_PASSWORD' -F submit=Next https://$INSTALL_URL/setup.php
curl -X POST -F install=Install https://$INSTALL_URL/setup.php
  
rm setup.php
