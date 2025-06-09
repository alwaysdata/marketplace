#!/bin/bash

# Declare site in YAML, as documented on the documentation: https://help.alwaysdata.com/en/marketplace/build-application-script/
# site:
#     type: user_program
#     working_directory: '{INSTALL_PATH_RELATIVE}'
#     command: './listmonk'
# database:
#     type: postgresql
# requirements:
#     disk: 30

set -e

# https://listmonk.app/docs/installation/

# Download
wget -O- --no-hsts https://github.com/knadh/listmonk/releases/download/v5.0.2/listmonk_5.0.2_linux_amd64.tar.gz | tar -xz --strip-components=0

# Configuration
cat << EOF > config.toml
[app]
address = "0.0.0.0:$PORT"

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

# Install
./listmonk --install --yes
