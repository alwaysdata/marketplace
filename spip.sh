#!/bin/bash

# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}'
#     php_version: '7.4'
#     ssl_force: true
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
#     admin_username:
#         label:
#             en: Administrator usernam
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

# https://contrib.spip.net/SPIP-Cli
git clone https://git.spip.net/spip-contrib-outils/spip-cli.git spip-cli
cd spip-cli
COMPOSER_CACHE_DIR=/dev/null composer2 install
COMPOSER_CACHE_DIR=/dev/null composer2 update

~/spip-cli/bin/spip dl -d $HOME/default -R last

cd $HOME/default

# https://git.spip.net/spip/spip/issues/4277 => https://git.spip.net/spip/spip/pulls/29/files
sed -i "/ENGINE=MyISAM/d" ecrire/req/mysql.php

~/spip-cli/bin/spip install --db-server "mysql" --db-host "$DATABASE_HOST" --db-login "$DATABASE_USERNAME" --db-pass "$DATABASE_PASSWORD" --db-database "$DATABASE_NAME" --admin-login "$FORM_ADMIN_USERNAME" --admin-email "$FORM_ADMIN_EMAIL" --admin-pass "$FORM_ADMIN_PASSWORD" --adresse-site "$INSTALL_URL"

# Cleaning
cd
rm -rf spip-cli .config .local
shopt -s dotglob
mv default/* .
rmdir default
