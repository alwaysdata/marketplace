#!/bin/bash

# Declare site in YAML, as documented on the documentation: https://help.alwaysdata.com/en/marketplace/build-application-script/
# site:
#     type: user_program
#     working_directory: '{INSTALL_PATH_RELATIVE}'
#     command: './fathom --config=.env server'
#     path_trim: true
# database:
#     type: mysql
# requirements:
#     disk: 20
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
#         max_length: 255

set -e

# Download
wget -O- --no-hsts https://github.com/usefathom/fathom/releases/download/v1.3.1/fathom_1.3.1_linux_amd64.tar.gz | tar -xz --strip-components=0

# Configuration
cat << EOF > .env
FATHOM_SERVER_ADDR=0.0.0.0:$PORT
FATHOM_DATABASE_DRIVER="mysql"
FATHOM_DATABASE_NAME="$DATABASE_NAME"
FATHOM_DATABASE_USER="$DATABASE_USERNAME"
FATHOM_DATABASE_PASSWORD="$DATABASE_PASSWORD"
FATHOM_DATABASE_HOST="$DATABASE_HOST"
FATHOM_SECRET="$(echo $RANDOM | md5sum | sed 's/ .*//')"
EOF

# Create user
./fathom user add --email=$FORM_EMAIL --password=$FORM_PASSWORD
