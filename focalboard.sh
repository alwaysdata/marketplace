#!/bin/bash

# site:
#     type: user_program
#     working_directory: '{INSTALL_PATH}'
#     command: '~{INSTALL_PATH_RELATIVE}/bin/focalboard-server'
#     path_trim: true
# requirements:
#     disk: 60

set -e

wget -O- https://github.com/mattermost/focalboard/releases/download/v7.4.1/focalboard-server-linux-amd64.tar.gz|tar -xz --strip-components=1

sed -i "s|localhost:8000|$INSTALL_URL|" config.json
sed -i "/$INSTALL_URL\",/a\ \ \ \ \"ip\": \"::\"," config.json
sed -i "s|\"port\": 8000,|\"port\": $PORT,|" config.json
sed -i "s|/var/tmp/focalboard_local.socket|/home/$USER/admin/tmp/focalboard_local.socket|" config.json
sed -i "s|\"prometheusaddress\": \":9092\",|\"prometheusaddress\": \"\",|" config.json
