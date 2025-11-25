#!/bin/bash

# Declare site in YAML, as documented on the documentation: https://help.alwaysdata.com/en/marketplace/build-application-script/
# site:
#     type: user_program
#     working_directory: '{INSTALL_PATH_RELATIVE}'
#     command: './readeck serve'
# database:
#     type: postgresql
# requirements:
#     disk: 60
# form:
#     email:
#         type: email
#         label:
#             en: Email
#             fr: Email
#         max_length: 255
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

set -e

# Download
wget --no-hsts -O readeck https://codeberg.org/readeck/readeck/releases/download/0.21.2/readeck-0.21.2-linux-amd64

chmod +x  readeck

# Configuration
cat << EOF > config.toml
# More options https://readeck.org/en/docs/configuration

[server]
host = "0.0.0.0"
port = $PORT

[database]
source = "postgres://$DATABASE_USERNAME:$DATABASE_PASSWORD@$DATABASE_HOST:5432/$DATABASE_NAME"
EOF

./readeck user -email $FORM_EMAIL -password $FORM_PASSWORD -user $FORM_USERNAME
