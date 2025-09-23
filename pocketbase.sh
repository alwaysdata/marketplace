#!/bin/bash

# Declare site in YAML, as documented on the documentation: https://help.alwaysdata.com/en/marketplace/build-application-script/
# site:
#     type: user_program
#     working_directory: '{INSTALL_PATH_RELATIVE}'
#     command: './pocketbase serve --http="[::]:$PORT"'
# requirements:
#     disk: 40
# form:
#     email:
#         type: email
#         label:
#             en: Email
#             fr: Email
#         max_length: 255
#     password:
#         type: password
#         label:
#             en: Password
#             fr: Mot de passe
#         min_length: 5
#         max_length: 255

set -e

# https://pocketbase.io/docs/

wget -O- --no-hsts https://github.com/pocketbase/pocketbase/releases/download/v0.30.0/pocketbase_0.30.0_linux_amd64.zip | bsdtar --strip-components=0 -xf -
chmod +x pocketbase

./pocketbase superuser upsert $FORM_EMAIL $FORM_PASSWORD
