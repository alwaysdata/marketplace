#!/bin/bash

# Declare site in YAML, as documented on the documentation: https://help.alwaysdata.com/en/marketplace/build-application-script/
# site:
#     type: user_program
#     working_directory: '{INSTALL_PATH_RELATIVE}'
#     command: './gotify-linux-amd64'
# requirements:
#     disk: 25

set -e

# Download
wget -O- --no-hsts https://github.com/gotify/server/releases/download/v2.6.1/gotify-linux-amd64.zip | bsdtar -xf -
chmod +x gotify-linux-amd64

# Configuration
wget --no-hsts -O config.yml https://raw.githubusercontent.com/gotify/server/master/config.example.yml

sed -i "s|listenaddr: \"\"|listenaddr: \"0.0.0.0\"|" config.yml
sed -i "s|port: 80|port: $PORT|" config.yml

sed -i '/name:/d' config.yml
sed -i '/pass:/d' config.yml

# Default credentials for first login: admin / admin
