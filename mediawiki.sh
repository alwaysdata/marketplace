#!/bin/bash

# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}'
#     php_version: '7.4'
#     php_ini: extension=intl.so
# database:
#     type: mysql
# requirements:
#     disk: 350
# form:
#     language:
#         type: choices
#         label:
#             en: Language
#             fr: Langue
#         choices:
#             de: Deutsch
#             en: English
#             es: Español
#             fr: Français
#             it: Italiano
#     title:
#         label:
#             en: Wiki title
#             fr: Titre du wiki
#         max_length: 255
#     admin_username:
#         label:
#             en: Administrator username
#             fr: Nom d'utilisateur de l'administrateur
#         max_length: 255
#     admin_password:
#         type: password
#         label:
#             en: Administrator password
#             fr: Mot de passe de l'administrateur
#         min_length: 10
#         max_length: 255

set -e

# https://www.mediawiki.org/wiki/Compatibility

wget -O- https://releases.wikimedia.org/mediawiki/1.38/mediawiki-1.38.2.tar.gz | tar -xz --strip-components=1

COMPOSER_CACHE_DIR=/dev/null composer install
php maintenance/install.php --dbname="$DATABASE_NAME" --installdbpass="$DATABASE_PASSWORD" --dbserver="$DATABASE_HOST" --installdbuser="$DATABASE_USERNAME" --dbuser="$DATABASE_USERNAME" --dbpass="$DATABASE_PASSWORD" --dbprefix=wiki --lang="$FORM_LANGUAGE" --pass="$FORM_ADMIN_PASSWORD" --server="http://$INSTALL_URL_HOSTNAME" --scriptpath="$INSTALL_URL_PATH" --skins=Vector "$FORM_TITLE" "$FORM_ADMIN_USERNAME"

if [ "$INSTALL_URL_PATH" = "/" ]
then
    sed -i 's|\$wgScriptPath = "/";|\$wgScriptPath = "";|' LocalSettings.php
fi

rm -rf .composer
