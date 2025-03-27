#!/bin/bash

# Declare site in YAML, as documented on the documentation: https://help.alwaysdata.com/en/marketplace/build-application-script/
# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}'
#     php_version: '8.3'
# database:
#     type: mysql
# requirements:
#     disk: 200
# form:
#     title:
#         label:
#             en: Title
#             fr: Titre
#         max_length: 255
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
#         regex: ^[ a-zA-Z0-9.@_-]+$
#         regex_text:
#             en: "It can include uppercase, lowercase, numbers, spaces, and special characters: .@_-."
#             fr: "Il peut comporter des majuscules, des minuscules, des chiffres, des espaces et les caractères spéciaux : .@_-."
#         max_length: 255
#     admin_password:
#         type: password
#         label:
#             en: Administrator password
#             fr: Mot de passe de l'administrateur
#         max_length: 255

set -e

# https://woo.com/document/server-requirements/

# Use WordPress command-line interface http://wp-cli.org
wget --no-hsts https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

# Temporarily add WP_SITEURL in wp-config.php because of https://github.com/wp-cli/core-command/issues/51
php -d sys_temp_dir=/home/$USER/admin/tmp wp-cli.phar core download --path="$INSTALL_PATH"
php wp-cli.phar config create --dbname="$DATABASE_NAME" --dbuser="$DATABASE_USERNAME" --dbpass="$DATABASE_PASSWORD" --dbhost="$DATABASE_HOST" --path="$INSTALL_PATH" --extra-php <<PHP
define( 'WP_SITEURL', 'http://$INSTALL_URL' );
PHP

# Install WordPress
php wp-cli.phar core install --url="$INSTALL_URL" --title="$FORM_TITLE" --admin_user="$FORM_ADMIN_USERNAME" --admin_password="$FORM_ADMIN_PASSWORD" --admin_email="$FORM_EMAIL" --path="$INSTALL_PATH"

# Install WooCommerce
php wp-cli.phar plugin install woocommerce --activate --force
php wp-cli.phar language plugin update --all

# Clean install environment
sed -i '/WP_SITEURL/d' wp-config.php
rm -rf .wp-cli wp-cli.phar

# WAF WordPress specific profile: https://help.alwaysdata.com/en/sites/waf/#available-profiles
