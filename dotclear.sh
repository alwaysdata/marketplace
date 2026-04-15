#!/bin/bash

# Declare site in YAML, as documented on the documentation: https://help.alwaysdata.com/en/marketplace/build-application-script/
# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}'
#     php_version: '8.5'
#     ssl_force: true
# database:
#     type: mysql
# form:
#     admin_username:
#         label:
#             en: Administrator username
#             fr: Nom d'utilisateur de l'administrateur
#         min_length: 2
#         max_length: 255
#     admin_email:
#         type: email
#         label:
#             en: Administrator email
#             fr: Email de l'administrateur
#         max_length: 255
#     admin_password:
#         type: password
#         label:
#             en: Administrator password
#             fr: Mot de passe de l'administrateur
#         min_length: 5
#         max_length: 255
# requirements:
#     disk: 30

set -e

# https://dotclear.org/documentation/2.0/admin/install

# Download
wget -O- --no-hsts http://download.dotclear.org/latest.tar.gz | tar -xz --strip-components=2

# Configuration
cp inc/config.php.in inc/config.php

sed -i "s|'DC_DBDRIVER', ''|'DC_DBDRIVER', 'mysqli'|" inc/config.php
sed -i "s|'DC_DBHOST', ''|'DC_DBHOST', '$DATABASE_HOST'|" inc/config.php
sed -i "s|'DC_DBUSER', ''|'DC_DBUSER', '$DATABASE_USERNAME'|" inc/config.php
sed -i "s|'DC_DBPASSWORD', ''|'DC_DBPASSWORD', '$DATABASE_PASSWORD'|" inc/config.php
sed -i "s|'DC_DBNAME', ''|'DC_DBNAME', '$DATABASE_NAME'|" inc/config.php
sed -i "s|'DC_MASTER_KEY', ''|'DC_MASTER_KEY', '$(date | sha256sum -b | sed 's/ .*//')'|" inc/config.php
sed -i "s|'DC_ADMIN_URL', ''|'DC_ADMIN_URL', 'https://$INSTALL_URL/admin'|" inc/config.php
sed -i "s|'DC_ADMIN_MAILFROM', ''|'DC_ADMIN_MAILFROM', '$USER@$RESELLER_DOMAIN'|" inc/config.php

# Install

php admin/install/index.php -n --uemail="$FORM_ADMIN_EMAIL" --ulogin="$FORM_ADMIN_USERNAME" --upassword=$FORM_ADMIN_PASSWORD -ufirstname="" --ulastname="" --blogurl=https://$INSTALL_URL
