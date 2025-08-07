#!/bin/bash

# Declare site in YAML, as documented on the documentation: https://help.alwaysdata.com/en/marketplace/build-application-script/
# site:
#     type: user_program
#     working_directory: '{INSTALL_PATH_RELATIVE}'
#     command: './filebrowser'
# requirements:
#     disk: 25
# form:
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
#         min_length: 12
#         max_length: 255

set -e

wget -O- --no-hsts https://github.com/filebrowser/filebrowser/releases/download/v2.42.2/linux-amd64-filebrowser.tar.gz | tar -xz --strip-components=0

./filebrowser config init -a "0.0.0.0" -p "$PORT" -b "$INSTALL_URL_PATH"
./filebrowser users add $FORM_USERNAME $FORM_PASSWORD
