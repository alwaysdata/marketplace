#!/bin/bash

# Declare site in YAML, as documented on the documentation: https://help.alwaysdata.com/en/marketplace/build-application-script/
# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}/web'
#     php_version: '8.3'
#     vhost_additional_directives: |
#         <IfModule mod_brotli.c>
#         BrotliCompressionQuality 5
#         </IfModule>
# database:
#     type: mysql
# requirements:
#     disk: 250
# form:
#     email:
#         type: email
#         label:
#             en: Email
#             fr: Email
#         max_length: 255
#     admin_username:
#         label:
#             en: Administrator username
#             fr: Nom d'utilisateur de l'administrateur
#         max_length: 255
#     admin_firstname:
#         label:
#             en: Administrator firstname
#             fr: Prénom de l'administrateur
#         max_length: 255
#     admin_lastname:
#         label:
#             en: Administrator lastname
#             fr: Nom de l'administrateur
#         max_length: 255
#     admin_password:
#         type: password
#         label:
#             en: Administrator password
#             fr: Mot de passe de l'administrateur
#         max_length: 255

set -e

# https://github.com/thelia/thelia-project?tab=readme-ov-file#compatibility

# Download
COMPOSER_CACHE_DIR=/dev/null composer2 create-project thelia/thelia-project --no-install default

cd default

COMPOSER_CACHE_DIR=/dev/null composer2 config --no-plugins allow-plugins.symfony/runtime true
echo "n"|COMPOSER_CACHE_DIR=/dev/null composer2 install

# Install
php Thelia thelia:install --db_host "$DATABASE_HOST" --db_username "$DATABASE_USERNAME" --db_password "$DATABASE_PASSWORD" --db_name "$DATABASE_NAME"

# Create admin user
php Thelia admin:create -q --login_name "$FORM_ADMIN_USERNAME" --first_name "$FORM_ADMIN_FIRSTNAME" --last_name "$FORM_ADMIN_LASTNAME" --email "$FORM_EMAIL" --password "$FORM_ADMIN_PASSWORD"

# BrotliCompressionQuality n'est pas autorisé dans un .htaccess: https://httpd.apache.org/docs/current/en/mod/mod_brotli.html#brotlicompressionquality
sed -i '/BrotliCompressionQuality 5/d' web/.htaccess

# Clean install environment
cd ..
rm -rf .config .subversion .local

shopt -s dotglob
mv default/* .
rmdir default
