#!/bin/bash

# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}'
#     php_version: '7.3'
# database:
#     type: mysql
# form:
#     language:
#         type: choices
#         label: Language
#         initial: en_US
#         choices:
#             de_DE: German
#             en_US: English
#             es_ES: Spanish
#             fr_FR: French
#             it_IT: Italian
#     title:
#         label: Blog title
#         max_length: 255
#     email:
#         type: email
#         label: Email
#     admin_username:
#         label: Administrator username
#         regex: ^[ a-zA-Z0-9.@_-]+$
#         max_length: 255
#     admin_password:
#         type: password
#         label: Administrator password
#         max_length: 255

set -e

# We use http://wp-cli.org
wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

php wp-cli.phar core download --locale="$FORM_LANGUAGE" --path="$INSTALL_PATH"
php wp-cli.phar config create --dbname="$DATABASE_NAME" --dbuser="$DATABASE_USERNAME" --dbpass="$DATABASE_PASSWORD" --dbhost="$DATABASE_HOST" --path="$INSTALL_PATH"
php wp-cli.phar core install --url="$INSTALL_URL" --title="$FORM_TITLE" --admin_user="$FORM_ADMIN_USERNAME" --admin_password="$FORM_ADMIN_PASSWORD" --admin_email="$FORM_EMAIL" --path="$INSTALL_PATH"
    
rm -rf .wp-cli wp-cli.phar
