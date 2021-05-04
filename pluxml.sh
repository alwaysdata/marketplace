#!/bin/bash

# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}'
#     php_version: '7.4'
# form:
#     language:
#         type: choices
#         label: Language
#         initial: en
#         choices:
#             de: German
#             en: English
#             es: Spanish
#             fr: French
#             it: Italian
#     admin_name:
#         label: Administrator name
#         max_length: 255
#     admin_username:
#         label: Administrator username
#         max_length: 255
#     email:
#         type: email
#         label: Email
#     admin_password:
#         type: password
#         label: Administrator password
#         max_length: 255
#         min_length: 8
set -e

wget https://www.pluxml.org/download/pluxml-latest.zip
unzip pluxml-latest.zip
rm pluxml-latest.zip

shopt -s dotglob nullglob
mv PluXml/* .
rmdir PluXml

curl -X POST -F default_lang="$FORM_LANGUAGE" -F data=1 -F name="$FORM_ADMIN_NAME" -F login="$FORM_ADMIN_USERNAME" -F pwd="$FORM_ADMIN_PASSWORD" -F pwd2="$FORM_ADMIN_PASSWORD" -F email="$FORM_EMAIL" -F timezone="Europe\/Paris" -F install=Installer http://$INSTALL_URL/install.php

