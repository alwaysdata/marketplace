#!/bin/bash

# site:
#     type: user_program
#     working_directory: '{INSTALL_PATH}'
#     command: './listmonk'
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

# https://listmonk.app/docs/installation/

wget -O- https://github.com/knadh/listmonk/releases/download/v2.5.1/listmonk_2.5.1_linux_amd64.tar.gz | tar -xz --strip-components=0

cat << EOF > config.toml
[app]
address = "0.0.0.0:$PORT"

# BasicAuth authentication for the admin dashboard
admin_username = "$FORM_ADMIN_USERNAME"
admin_password = "$FORM_ADMIN_PASSWORD"

# Database
[db]
host = "$DATABASE_HOST"
port = 5432
user = "$DATABASE_USERNAME"
password = "$DATABASE_PASSWORD"
database = "$DATABASE_NAME"
ssl_mode = "disable"
max_open = 25
max_idle = 25
max_lifetime = "300s"
EOF

./listmonk --install --yes

rm .wget-hsts
