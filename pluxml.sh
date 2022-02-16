#!/bin/bash

# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}'
#     php_version: '8.0'
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
#     admin_password:
#         type: password
#         label:
#             en: Administrator password
#             fr: Mot de passe de l'administrateur
#         max_length: 255
#         min_length: 8
set -e

wget -O- https://www.pluxml.org/download/pluxml-latest.zip | bsdtar --strip-components=1 -xf -

curl -X POST -F default_lang="$FORM_LANGUAGE" -F data=1 -F name="$FORM_ADMIN_NAME" -F login="$FORM_ADMIN_USERNAME" -F pwd="$FORM_ADMIN_PASSWORD" -F pwd2="$FORM_ADMIN_PASSWORD" -F email="$FORM_EMAIL" -F timezone="Europe\/Paris" -F install=Installer http://$INSTALL_URL/install.php
