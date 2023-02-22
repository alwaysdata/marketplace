#!/bin/bash

# site:
#     type: user_program
#     working_directory: '{INSTALL_PATH}'
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
#     password:
#         type: password
#         label:
#             en: Password
#             fr: Mot de passe
#         max_length: 255

set -e

wget -O- https://github.com/usefathom/fathom/releases/download/v1.3.1/fathom_1.3.1_linux_amd64.tar.gz | tar -xz --strip-components=0

cat << EOF > .env
FATHOM_SERVER_ADDR=0.0.0.0:$PORT
FATHOM_DATABASE_DRIVER="mysql"
FATHOM_DATABASE_NAME="$DATABASE_NAME"
FATHOM_DATABASE_USER="$DATABASE_USERNAME"
FATHOM_DATABASE_PASSWORD="$DATABASE_PASSWORD"
FATHOM_DATABASE_HOST="$DATABASE_HOST"
FATHOM_SECRET="$(echo $RANDOM | md5sum | sed 's/ .*//')"
EOF

./fathom user add --email=$FORM_EMAIL --password=$FORM_PASSWORD

rm .wget-hsts
