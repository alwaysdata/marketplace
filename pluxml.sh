#!/bin/bash

# Declare site in YAML, as documented on the documentation: https://help.alwaysdata.com/en/marketplace/build-application-script/
# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}'
#     php_version: '8.4'
# requirements:
#     disk: 5
# form:
#     language:
#         type: choices
#         label:
#             en: Language
#             fr: Langue
#         choices:
#             de: Deutsch
#             en: English
#             es: Español
#             fr: Français
#             it: Italiano
#     admin_name:
#         label:
#             en: Administrator name
#             fr: Nom de l'administrateur
#         max_length: 255
#     admin_username:
#         label:
#             en: Administrator username
#             fr: Nom d'utilisateur de l'administrateur
#         max_length: 255
#     email:
#         type: email
#         label:
#             en: Email
#             fr: Email
#         max_length: 255
#     admin_password:
#         type: password
#         label:
#             en: Administrator password
#             fr: Mot de passe de l'administrateur
#         max_length: 255
#         min_length: 8

set -e

# https://wiki.pluxml.org/docs/install/install.html

wget -O- --no-hsts https://www.pluxml.org/download/pluxml-latest.zip | bsdtar --strip-components=1 -xf -

curl -X POST -F default_lang="$FORM_LANGUAGE" -F data=1 -F name="$FORM_ADMIN_NAME" -F login="$FORM_ADMIN_USERNAME" -F pwd="$FORM_ADMIN_PASSWORD" -F pwd2="$FORM_ADMIN_PASSWORD" -F email="$FORM_EMAIL" -F timezone="Europe\/Paris" -F install=Installer http://$INSTALL_URL/install.php
