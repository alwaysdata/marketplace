#!/bin/bash

# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}'
#     php_version: '8.3'
# requirements:
#     disk: 30
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
#     title:
#         label:
#             en: Wiki title
#             fr: Titre du wiki
#         max_length: 255
#     email:
#         type: email
#         label:
#             en: Email
#             fr: Email
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
#     admin_password:
#         type: password
#         label:
#             en: Administrator password
#             fr: Mot de passe de l'administrateur
#         max_length: 255

set -e

# https://www.dokuwiki.org/requirements

wget -O- --no-hsts https://download.dokuwiki.org/src/dokuwiki/dokuwiki-stable.tgz | tar -xz --strip-components=1

curl -X POST -F l="$FORM_LANGUAGE" -F d[title]="$FORM_TITLE" -F d[acl]=on -F d[superuser]="$FORM_ADMIN_USERNAME" -F d[fullname]="$FORM_ADMIN_NAME" -F d[email]="$FORM_EMAIL" -F d[password]="$FORM_ADMIN_PASSWORD" -F d[confirm]="$FORM_ADMIN_PASSWORD" -F d[policy]=0 -F d[license]=cc-by-sa -F d[pop]=on -F submit=Save http://$INSTALL_URL/install.php

rm install.php
