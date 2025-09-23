#!/bin/bash

# Declare site in YAML, as documented on the documentation: https://help.alwaysdata.com/en/marketplace/build-application-script/
# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}'
#     php_version: '8.3'
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

# Download & install dependancies
wget -O- --no-hsts https://releases.wikimedia.org/mediawiki/1.43/mediawiki-1.43.1.tar.gz | tar -xz --strip-components=1

COMPOSER_CACHE_DIR=/dev/null composer2 install

# Install
php maintenance/run.php install.php --dbname="$DATABASE_NAME" --installdbpass="$DATABASE_PASSWORD" --dbserver="$DATABASE_HOST" --installdbuser="$DATABASE_USERNAME" --dbuser="$DATABASE_USERNAME" --dbpass="$DATABASE_PASSWORD" --dbprefix=wiki --lang="$FORM_LANGUAGE" --pass="$FORM_ADMIN_PASSWORD" --server="https://$INSTALL_URL_HOSTNAME" --scriptpath="$INSTALL_URL_PATH" --skins=Vector "$FORM_TITLE" "$FORM_ADMIN_USERNAME"

# Handle root base URL
if [ "$INSTALL_URL_PATH" = "/" ]
then
    sed -i 's|wgScriptPath = "/"|wgScriptPath = ""|' LocalSettings.php
fi

# Clean install environment
rm -rf .composer
