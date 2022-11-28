#!/bin/bash

# site:
#     type: nodejs
#     nodejs_version: '16'
#     working_directory: '{INSTALL_PATH}/'
#     command: 'node app.js'
#     environment: |
#         NODE_ENV=production
#         HOME='{INSTALL_PATH}'
# database:
#      type: postgresql
# requirements:
#     disk: 750
# form:
#     email:
#         type: email
#         label:
#             en: Email
#             fr: Email
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

wget -O- https://github.com/NodeBB/NodeBB/archive/refs/tags/v2.6.1.tar.gz|tar -xz --strip-components=1

cat << EOF > config.json
{
    "url": "http://$INSTALL_URL",
    "port": "$PORT",
    "secret": "$(sha256sum -b | sed 's/ .*//')",
    "database": "postgres",
    "postgres": {
        "host": "$DATABASE_HOST",
        "port": "5432",
        "username": "$DATABASE_USERNAME",
        "password": "$DATABASE_PASSWORD",
        "database": "$DATABASE_NAME",
        "ssl": "false"
    }
}
EOF

export admin__username="$FORM_ADMIN_USERNAME"
export admin__email="$FORM_EMAIL"
export admin__password="$FORM_ADMIN_PASSWORD"
export admin__password__confirm="$FORM_ADMIN_PASSWORD"

./nodebb setup

sed -i "s|'0.0.0.0'|'::'|" install/web.js
sed -i '/"database": "postgres",/a     "bind_address": "::",' config.json
