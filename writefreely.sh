#!/bin/bash

# site:
#     type: user_program
#     working_directory: '{INSTALL_PATH}'
#     command: '~{INSTALL_PATH_RELATIVE}/writefreely'
#     path_trim: true
# database:
#     type: mysql
# form:
#     site_name:
#         label: Site name
#         max_length: 255
#     admin_username:
#         label: Administrator username
#         regex: ^[ a-zA-Z0-9.@_-]+$
#         min_length: 5
#         max_length: 255
#     admin_password:
#         type: password
#         label: Administrator password
#         min_length: 5
#         max_length: 255

set -e

wget -O- https://github.com/writefreely/writefreely/releases/download/v0.12.0/writefreely_0.12.0_linux_amd64.tar.gz|tar -xz --strip-components=1

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
./writefreely --create-admin $FORM_ADMIN_USERNAME:$FORM_ADMIN_PASSWORD
