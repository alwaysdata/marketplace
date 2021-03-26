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
#     title:
#         label: Wiki Title
#         max_length: 255
#     email:
#         type: email
#         label: Email
#     admin_name:
#         label: Administrator name
#         max_length: 255
#     admin_username:
#         label: Administrator username
#         max_length: 255
#     admin_password:
#         type: password
#         label: Administrator password
#         max_length: 255

set -e

# https://www.dokuwiki.org/requirements

wget -O- https://github.com/splitbrain/dokuwiki/archive/release_stable_2020-07-29.tar.gz | tar -xz --strip-components=1

curl -X POST -F l="$FORM_LANGUAGE" -F d[title]="$FORM_TITLE" -F d[acl]=on -F d[superuser]="$FORM_ADMIN_USERNAME" -F d[fullname]="$FORM_ADMIN_NAME" -F d[email]="$FORM_EMAIL" -F d[password]="$FORM_ADMIN_PASSWORD" -F d[confirm]="$FORM_ADMIN_PASSWORD" -F d[policy]=0 -F d[license]=cc-by-sa -F d[pop]=on -F submit=Save http://$INSTALL_URL/install.php

rm install.php
