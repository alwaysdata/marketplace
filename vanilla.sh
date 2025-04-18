#!/bin/bash

# Declare site in YAML, as documented on the documentation: https://help.alwaysdata.com/en/marketplace/build-application-script/
# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}'
#     php_version: '8.2'
#     php_ini: |
#         extension=intl.so
# database:
#     type: mysql
# requirements:
#     disk: 95
# form:
#     title:
#         label:
#             en: Forum title
#             fr: Titre du forum
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
#     admin_password:
#         type: password
#         label:
#             en: Administrator password
#             fr: Mot de passe de l'administrateur
#         max_length: 255

set -e

# Download
wget -O- https://us.v-cdn.net/5018160/uploads/496PF9CMXJ9U/vanilla-2023-001.zip | bsdtar --strip-components=1 -xf -

mv .htaccess.dist .htaccess

# Install
curl -X POST -F Database-dot-Host="$DATABASE_HOST" -F Database-dot-Name="$DATABASE_NAME" -F Database-dot-User="$DATABASE_USERNAME" -F Database-dot-Password="$DATABASE_PASSWORD" -F Garden-dot-Title="$FORM_TITLE" -F Email="$FORM_EMAIL" -F Name="$FORM_ADMIN_USERNAME" -F Password="$FORM_ADMIN_PASSWORD" -F PasswordMatch="$FORM_ADMIN_PASSWORD" -F submit=Continue http://$INSTALL_URL/dashboard/setup
