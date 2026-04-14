#!/bin/bash

# Declare site in YAML, as documented on the documentation: https://help.alwaysdata.com/en/marketplace/build-application-script/
# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}/htdocs'
#     php_version: '8.4'
# database:
#     type: mysql
# requirements:
#     disk: 280
# form:
#     username:
#         label:
#             en: Username
#             fr: Nom d'utilisateur
#         max_length: 255
#     password:
#         type: password
#         label:
#             en: Password
#             fr: Mot de passe
#         max_length: 255

set -e

# https://wiki.dolibarr.org/index.php?title=Prerequisites

wget -O- https://downloads.sourceforge.net/project/dolibarr/Dolibarr%20ERP-CRM/23.0.2/dolibarr-23.0.2.zip | bsdtar --strip-components=1 -xf -

mkdir documents
cp htdocs/install/install.forced.sample.php htdocs/install/install.forced.php 
sed -i "s|force_install_database = getenv('DOLI_DATABASE', true) ?: 'dolibarr';|force_install_database = getenv('DOLI_DATABASE', true) ?: '$DATABASE_NAME';|" htdocs/install/install.forced.php
sed -i "s|force_install_dbserver = getenv('DOLI_DB_SERVER', true) ?: 'localhost';|force_install_dbserver = getenv('DOLI_DB_SERVER', true) ?: '$DATABASE_HOST';|" htdocs/install/install.forced.php
sed -i "s|force_install_databaselogin = 'root';|force_install_databaselogin = '$DATABASE_USERNAME';|" htdocs/install/install.forced.php
sed -i "s|force_install_databasepass = getenv('DOLI_DB_PASSWORD', true) ?: '';|force_install_databasepass = getenv('DOLI_DB_PASSWORD', true) ?: '$DATABASE_PASSWORD';|" htdocs/install/install.forced.php
sed -i "s|force_install_databaserootlogin = 'root';|force_install_databaserootlogin = '$DATABASE_USERNAME';|" htdocs/install/install.forced.php
sed -i "s|force_install_databaserootpass = getenv('DOLI_ROOT_PASSWORD', true) ?: '';|force_install_databaserootpass = getenv('DOLI_ROOT_PASSWORD', true) ?: '$DATABASE_PASSWORD';|" htdocs/install/install.forced.php
sed -i "s|force_install_dolibarrlogin = 'admin';|force_install_dolibarrlogin = '$FORM_USERNAME';|" htdocs/install/install.forced.php
sed -i "s|force_install_dolibarrpassword = '';|force_install_dolibarrpassword = '$FORM_PASSWORD';|" htdocs/install/install.forced.php
sed -i "s|force_install_createdatabase = true;|force_install_createdatabase = false;|" htdocs/install/install.forced.php
