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
#             fr: French
#     username:
#         label: Username
#         max_length: 255
#     password:
#         type: password
#         label: Password
#         max_length: 255
#         min_length: 8
#     title:
#         label: Shaarli title
#         max_length: 255
set -e

wget -O- https://github.com/shaarli/Shaarli/releases/download/v0.12.1/shaarli-v0.12.1-full.tar.gz | tar -xz --strip-components=1

curl -X POST -F setlogin="$FORM_USERNAME" -F setpassword="$FORM_PASSWORD" -F title="$FORM_TITLE" -F language="$FORM_LANGUAGE" -F Save=Install http://$INSTALL_URL/install
