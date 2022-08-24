#!/bin/bash

# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}'
#     php_version: '7.4'
# database:
#     type: mysql
# requirements:
#     disk: 105
# form:
#     language:
#         type: choices
#         label:
#             en: Language
#             fr: Langue
#         choices:
#             de_DE: Deutsch
#             en_US: English
#             es_ES: Español
#             fr_FR: Français
#             it_IT: Italiano
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
#     admin_username:
#         label:
#             en: Administrator username
#             fr: Nom d'utilisateur de l'administrateur
#         regex: ^[ a-zA-Z0-9.@_-]+$
#         max_length: 255
#     admin_password:
#         type: password
#         label:
#             en: Administrator password
#             fr: Mot de passe de l'administrateur
#         max_length: 255

set -e

# We use http://wp-cli.org
wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

# Temporarily add WP_SITEURL in wp-config.php because of https://github.com/wp-cli/core-command/issues/51
php -d sys_temp_dir=/tmp wp-cli.phar core download --locale="$FORM_LANGUAGE" --path="$INSTALL_PATH"
php wp-cli.phar config create --dbname="$DATABASE_NAME" --dbuser="$DATABASE_USERNAME" --dbpass="$DATABASE_PASSWORD" --dbhost="$DATABASE_HOST" --path="$INSTALL_PATH" --extra-php <<PHP
define( 'WP_SITEURL', 'http://$INSTALL_URL' );
PHP
php wp-cli.phar core install --url="$INSTALL_URL" --title="$FORM_TITLE" --admin_user="$FORM_ADMIN_USERNAME" --admin_password="$FORM_ADMIN_PASSWORD" --admin_email="$FORM_EMAIL" --path="$INSTALL_PATH"

php wp-cli.phar plugin install woocommerce --activate --force
php wp-cli.phar language plugin update --all

sed -i '/WP_SITEURL/d' wp-config.php
rm -rf .wp-cli wp-cli.phar
