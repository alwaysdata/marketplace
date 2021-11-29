#!/bin/bash

# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}'
#     php_version: '8.0'
# database:
#     type: mysql
# requirements:
#     disk: 11
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
#     title:
#         label:
#             en: Feed title
#             fr: Titre du flux
#         max_length: 255
#     username:
#         label:
#             en: Username
#             fr: Nom d'utilisateur
#         regex: ^[ a-zA-Z0-9.@_-]+$
#         max_length: 255
#     password:
#         type: password
#         label:
#             en: Password
#             fr: Mot de passe
#         max_length: 255

set -e

# https://freshrss.github.io/FreshRSS/en/admins/02_Prerequisites.html

wget -O- https://github.com/FreshRSS/FreshRSS/archive/1.18.1.tar.gz | tar -xz --strip-components=1

./cli/do-install.php --default_user admin --auth_type form --environment production --base_url https://$INSTALL_URL --language "$FORM_LANGUAGE" --title "$FORM_TITLE" --db-type mysql --db-host "$DATABASE_HOST":3306 --db-user "$DATABASE_USERNAME" --db-password "$DATABASE_PASSWORD" --db-base "$DATABASE_NAME"

./cli/create-user.php --user "$FORM_USERNAME" --password "$FORM_PASSWORD"
