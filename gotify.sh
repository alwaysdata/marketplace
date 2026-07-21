#!/bin/bash

# Declare site in YAML, as documented here: https://help.alwaysdata.com/en/docs/development/marketplace/build-application-script/
# site:
#     type: user_program
#     working_directory: '{INSTALL_PATH_RELATIVE}'
#     command: './gotify-linux-amd64'
# requirements:
#     disk: 25
set -e

# Download
wget -O- --no-hsts https://github.com/gotify/server/releases/download/v3.0.0/gotify-linux-amd64.zip | bsdtar -xf -
chmod +x gotify-linux-amd64

# Configuration
cat << EOF > gotify-server.env
# Documentation: https://gotify.net/docs/config
GOTIFY_SERVER_LISTENADDR=0.0.0.0
GOTIFY_SERVER_PORT=$PORT
EOF

# Default credentials for first login: admin / admin
