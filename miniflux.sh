#!/bin/bash

# Declare site in YAML, as documented on the documentation: https://help.alwaysdata.com/en/marketplace/build-application-script/
# site:
#     type: user_program
#     working_directory: '{INSTALL_PATH_RELATIVE}'
#     command: './miniflux -c miniflux.conf'
#     ssl: true
# database:
#     type: postgresql
# requirements:
#     disk: 30
# form:
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

# https://miniflux.app/docs/binary_installation.html

# Download
wget  --no-hsts -O miniflux https://github.com/miniflux/v2/releases/download/2.2.10/miniflux-linux-amd64
chmod +x miniflux

# Configuration
cat << EOF > miniflux.conf
DATABASE_URL=postgres://$DATABASE_USERNAME:$DATABASE_PASSWORD@$DATABASE_HOST/$DATABASE_NAME?sslmode=disable
CREATE_ADMIN=1
EOF

./miniflux -migrate -c miniflux.conf

# Admin user creation
export ADMIN_USERNAME=$FORM_ADMIN_USERNAME
export ADMIN_PASSWORD=$FORM_ADMIN_PASSWORD

timeout 5s ./miniflux -c miniflux.conf ||true

sed -i "s|CREATE_ADMIN=1|LISTEN_ADDR=\$IP:\$PORT|" miniflux.conf
