#!/bin/bash

# Declare site in YAML, as documented on the documentation: https://help.alwaysdata.com/en/marketplace/build-application-script/
# site:
#     type: user_program
#     working_directory: '{INSTALL_PATH_RELATIVE}'
#     command: './writefreely'
#     path_trim: true
# database:
#     type: mysql
# requirements:
#     disk: 60
# form:
#     site_name:
#         label:
#             en: Site name
#             fr: Nom du site
#         max_length: 255
#     admin_username:
#         label:
#             en: Administrator username
#             fr: Nom d'utilisateur de l'administrateur
#         regex: ^[ a-zA-Z0-9.@_-]+$
#         min_length: 5
#         max_length: 255
#     admin_password:
#         type: password
#         label:
#             en: Administrator password
#             fr: Mot de passe de l'administrateur
#         min_length: 5
#         max_length: 255

set -e

# Download
wget -O- --no-hsts https://github.com/writefreely/writefreely/releases/download/v0.15.0/writefreely_0.15.0_linux_amd64.tar.gz|tar -xz --strip-components=1

# Configuration
./writefreely config generate

sed -i "s|port                 = 8080|port = $PORT|" config.ini
sed -i "s|bind                 = localhost|bind = 0.0.0.0|" config.ini
sed -i "s|username = |username = $DATABASE_USERNAME|" config.ini
sed -i "s|password = |password = $DATABASE_PASSWORD|" config.ini
sed -i "s|database = |database = $DATABASE_NAME|" config.ini
sed -i "s|host     = localhost|host = $DATABASE_HOST|" config.ini
sed -i "s|site_name          = |site_name = $FORM_SITE_NAME|" config.ini
sed -i "s|host               = http://localhost:8080|host = http://$INSTALL_URL|" config.ini

./writefreely --init-db
./writefreely keys generate

# Create admin user
./writefreely --create-admin $FORM_ADMIN_USERNAME:$FORM_ADMIN_PASSWORD
