#!/bin/bash

# Declare site in YAML, as documented on the documentation: https://help.alwaysdata.com/en/marketplace/build-application-script/
# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}/p'
#     php_version: '8.3'
# database:
#     type: mysql
# requirements:
#     disk: 15
# form:
#     language:
#         type: choices
#         label:
#             en: Language
#             fr: Langue
#         choices:
#             de: Deutsch
#             en_US: English
#             es: Español
#             fr: Français
#             it: Italiano
#     username:
#         label:
#             en: Username
#             fr: Nom d'utilisateur
#         regex: ^[ a-zA-Z0-9.@_-]+$
#         regex_text:
#             en: "It can include uppercase, lowercase, numbers, spaces, and special characters: .@_-."
#             fr: "Il peut comporter des majuscules, des minuscules, des chiffres, des espaces et les caractères spéciaux : .@_-."
#         max_length: 255
#     password:
#         type: password
#         label:
#             en: Password
#             fr: Mot de passe
#         max_length: 255

set -e

# https://freshrss.github.io/FreshRSS/en/admins/02_Prerequisites.html

# Download
wget -O- --no-hsts https://github.com/FreshRSS/FreshRSS/archive/1.26.3.tar.gz | tar -xz --strip-components=1

# Install
./cli/do-install.php --default_user "$FORM_USERNAME" --auth_type form --environment production --base_url https://$INSTALL_URL --language "$FORM_LANGUAGE" --title "Fresh RSS" --db-type mysql --db-host "$DATABASE_HOST":3306 --db-user "$DATABASE_USERNAME" --db-password "$DATABASE_PASSWORD" --db-base "$DATABASE_NAME"

# Create username
./cli/create-user.php --user "$FORM_USERNAME" --password "$FORM_PASSWORD"
