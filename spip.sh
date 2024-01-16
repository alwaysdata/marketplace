#!/bin/bash

# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}'
#     php_version: '8.2'
#     php_ini: |
#         extension=sodium.so
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

# https://contrib.spip.net/SPIP-Cli
git clone --depth 1 https://git.spip.net/spip-contrib-outils/spip-cli.git
cd spip-cli
COMPOSER_CACHE_DIR=/dev/null composer2 install
COMPOSER_CACHE_DIR=/dev/null composer2 update

mkdir $HOME/default
cd $HOME/default

wget -O- --no-hsts https://files.spip.net/spip/archives/spip-v4.2.8.zip | bsdtar --strip-components=0 -xf -

cat << EOF > config/mes_options.php
<?php
if (!defined("_ECRIRE_INC_VERSION")) return;
\$GLOBALS['mysql_rappel_nom_base'] = false; /* echec de test_rappel_nom_base_mysql a l'installation. */
defined('_MYSQL_SET_SQL_MODE') || define('_MYSQL_SET_SQL_MODE',true);
define('_MYSQL_ENGINE', 'InnoDB');
?>
EOF

~/spip-cli/bin/spip install --db-server "mysql" --db-host "$DATABASE_HOST" --db-login "$DATABASE_USERNAME" --db-pass "$DATABASE_PASSWORD" --db-database "$DATABASE_NAME" --admin-login "$FORM_ADMIN_USERNAME" --admin-email "$FORM_ADMIN_EMAIL" --admin-pass "$FORM_ADMIN_PASSWORD"

# Cleaning
cd
rm -rf spip-cli .config .local
shopt -s dotglob
mv default/* .
rmdir default
