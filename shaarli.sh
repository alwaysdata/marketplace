#!/bin/bash

# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}'
#     php_version: '8.0'
# requirements:
#     disk: 20
# form:
#     title:
#         label:
#             en: Title
#             fr: Titre
#         max_length: 255
#     language:
#         type: choices
#         label:
#             en: Language
#             fr: Langue
#         choices:
#             de: Deutsch
#             en: English
#             fr: Français
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

wget -O- https://github.com/shaarli/Shaarli/releases/download/v0.12.2/shaarli-v0.12.2-full.tar.gz | tar -xz --strip-components=1

curl -X POST -F setlogin="$FORM_USERNAME" -F setpassword="$FORM_PASSWORD" -F title="$FORM_TITLE" -F language="$FORM_LANGUAGE" -F Save=Install http://$INSTALL_URL/install
