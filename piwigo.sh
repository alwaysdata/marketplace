#!/bin/bash

# Declare site in YAML, as documented on the documentation: https://help.alwaysdata.com/en/marketplace/build-application-script/
# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}'
#     php_version: '8.3'
# database:
#     type: mysql
# requirements:
#     disk: 40
# form:
#     email:
#         type: email
#         label:
#             en: Email
#             fr: Email
#         max_length: 255
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
#         min_length: 8

set -e

# https://piwigo.org/guides/install/requirements

wget -O- --no-hsts https://github.com/Piwigo/Piwigo/archive/refs/tags/15.6.0.tar.gz| tar -xz --strip-components=1

curl -X POST -F language="en_US" -F dbhost="$DATABASE_HOST" -F dbuser="$DATABASE_USERNAME" -F dbpasswd="$DATABASE_PASSWORD" -F dbname="$DATABASE_NAME" -F admin_name="$FORM_USERNAME" -F admin_pass1="$FORM_PASSWORD" -F admin_pass2="$FORM_PASSWORD" -F admin_mail="$FORM_EMAIL" -F newsletter_subscribe=none -F send_credentials_by_mail=checked -F install=Start\ installation http://$INSTALL_URL/install.php
