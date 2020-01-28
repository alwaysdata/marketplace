#!/bin/bash

# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}'
#     php_version: '7.3'
#     php_ini: extension=intl.so
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
#     title:
#         label: Wiki title
#         max_length: 255
#     admin_username:
#         label: Administrator username
#         max_length: 255
#     admin_password:
#         type: password
#         label: Administrator password
#         max_length: 255

set -e

wget -O- https://github.com/wikimedia/mediawiki/archive/1.34.0.tar.gz | tar -xz --strip-components=1

composer install
php maintenance/install.php --dbname="$DATABASE_NAME" --installdbpass="$DATABASE_PASSWORD" --dbserver="$DATABASE_HOST" --installdbuser="$DATABASE_USERNAME" --dbuser="$DATABASE_USERNAME" --dbpass="$DATABASE_PASSWORD" --dbprefix=wiki_ --lang="$FORM_LANGUAGE" --pass="$FORM_ADMIN_PASSWORD" --server="http://$INSTALL_URL_HOSTNAME" --scriptpath="$INSTALL_URL_PATH" "$FORM_TITLE" "$FORM_ADMIN_USERNAME"

if [ "$INSTALL_URL_PATH" = "/" ]
then
    sed -i 's|\$wgScriptPath = "/";|\$wgScriptPath = "";|' LocalSettings.php
fi

# Install the default skin (no skin is installed by default):
# https://www.mediawiki.org/wiki/Skin:Vector
git clone https://gerrit.wikimedia.org/r/mediawiki/skins/Vector skins/Vector
sed -i "/monobook/a wfLoadSkin( 'Vector' );" LocalSettings.php

rm -rf .composer
