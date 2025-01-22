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

set -e

# Download
wget --no-hsts -O readeck https://codeberg.org/readeck/readeck/releases/download/0.17.1/readeck-0.17.1-linux-amd64

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
