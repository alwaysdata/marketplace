#!/bin/bash

# site:
#     type: user_program
#     working_directory: '{INSTALL_PATH}'
#     command: '~{INSTALL_PATH_RELATIVE}/gotify-linux-amd64'

set -e

wget -O- https://github.com/gotify/server/releases/download/v2.0.22/gotify-linux-amd64.zip | bsdtar -xf -
chmod +x gotify-linux-amd64

wget -O config.yml https://raw.githubusercontent.com/gotify/server/master/config.example.yml

sed -i "s|listenaddr: \"\"|listenaddr: \"0.0.0.0\"|" config.yml
sed -i "s|port: 80|port: $PORT|" config.yml

sed -i '/name:/d' config.yml
sed -i '/pass:/d' config.yml

# default credentials: admin / admin
