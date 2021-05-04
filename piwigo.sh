#!/bin/bash

# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}'
#     php_version: '7.4'
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
#     email:
#         type: email
#         label: Email
#     username:
#         label: Username
#         max_length: 255
#     password:
#         type: password
#         label: Password
#         max_length: 255
#         min_length: 8

set -e

wget -O- https://github.com/Piwigo/Piwigo/archive/refs/tags/11.4.0.tar.gz| tar -xz --strip-components=1

curl -X POST -F language="$FORM_LANGUAGE" -F dbhost="$DATABASE_HOST" -F dbuser="$DATABASE_USERNAME" -F dbpasswd="$DATABASE_PASSWORD" -F dbname="$DATABASE_NAME" -F admin_name="$FORM_USERNAME" -F admin_pass1="$FORM_PASSWORD" -F admin_pass2="$FORM_PASSWORD" -F admin_mail="$FORM_EMAIL" -F newsletter_subscribe=none -F send_credentials_by_mail=checked -F install=Start\ installation http://$INSTALL_URL/install.php 
