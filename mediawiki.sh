#!/bin/bash

# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}'
#     php_version: '7.4'
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
#         min_length: 10
#         max_length: 255

set -e

# https://www.mediawiki.org/wiki/Compatibility

wget -O- https://releases.wikimedia.org/mediawiki/1.35/mediawiki-1.35.2.tar.gz | tar -xz --strip-components=1

COMPOSER_CACHE_DIR=/dev/null composer install
php maintenance/install.php --dbname="$DATABASE_NAME" --installdbpass="$DATABASE_PASSWORD" --dbserver="$DATABASE_HOST" --installdbuser="$DATABASE_USERNAME" --dbuser="$DATABASE_USERNAME" --dbpass="$DATABASE_PASSWORD" --dbprefix=wiki --lang="$FORM_LANGUAGE" --pass="$FORM_ADMIN_PASSWORD" --server="http://$INSTALL_URL_HOSTNAME" --scriptpath="$INSTALL_URL_PATH" --skins=Vector "$FORM_TITLE" "$FORM_ADMIN_USERNAME"

if [ "$INSTALL_URL_PATH" = "/" ]
then
    sed -i 's|\$wgScriptPath = "/";|\$wgScriptPath = "";|' LocalSettings.php
fi

# Temporary fix for https://phabricator.wikimedia.org/T235554
sed -i '/Content-Encoding: identity/d' includes/MediaWiki.php

rm -rf .composer
