#!/bin/bash

# Declare site in YAML, as documented on the documentation: https://help.alwaysdata.com/en/marketplace/build-application-script/
# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}'
#     php_version: '8.2'
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

# https://shaarli.readthedocs.io/en/latest/Server-configuration.html

wget -O- --no-hsts https://github.com/shaarli/Shaarli/releases/download/v0.15.0/shaarli-v0.15.0-full.tar.gz | tar -xz --strip-components=1

curl -X POST -F setlogin="$FORM_USERNAME" -F setpassword="$FORM_PASSWORD" -F title="$FORM_TITLE" -F language="$FORM_LANGUAGE" -F Save=Install http://$INSTALL_URL/install
