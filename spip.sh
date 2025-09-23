#!/bin/bash

# Declare site in YAML, as documented on the documentation: https://help.alwaysdata.com/en/marketplace/build-application-script/
# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}'
#     php_version: '8.3'
#     ssl_force: true
# database:
#     type: mysql
# requirements:
#     disk: 50
# form:
#     admin_email:
#         type: email
#         label:
#             en: Administrator email
#             fr: Email de l'administrateur
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
#         min_length: 6
#         max_length: 255

set -e

# Requirements: https://www.spip.net/en_article6807.html
# https://www.spip.net/fr_article6500.html
# https://contrib.spip.net/SPIP-Cli

git clone --depth 1 https://git.spip.net/spip-contrib-outils/spip-cli.git
cd spip-cli
COMPOSER_CACHE_DIR=/dev/null composer2 install
COMPOSER_CACHE_DIR=/dev/null composer2 update

mkdir $HOME/default
cd $HOME/default

wget -O- --no-hsts https://files.spip.net/spip/archives/spip-v4.4.5.zip | bsdtar --strip-components=0 -xf -

# Install
~/spip-cli/bin/spip install --db-server "mysql" --db-host "$DATABASE_HOST" --db-login "$DATABASE_USERNAME" --db-pass "$DATABASE_PASSWORD" --db-database "$DATABASE_NAME" --admin-login "$FORM_ADMIN_USERNAME" --admin-email "$FORM_ADMIN_EMAIL" --admin-pass "$FORM_ADMIN_PASSWORD"

# Clean install environment
cd
rm -rf spip-cli .config .local
shopt -s dotglob
mv default/* .
rmdir default
