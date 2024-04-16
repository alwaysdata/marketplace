#!/bin/bash

# Declare site in YAML, as documented on the documentation: https://help.alwaysdata.com/en/marketplace/build-application-script/
# site:
#     type: user_program
#     working_directory: '{INSTALL_PATH}'
#     command: './bin/focalboard-server'
#     path_trim: true
# database:
#     type: postgresql
# requirements:
#     disk: 70

set -e

# Download
wget -O- --no-hsts https://github.com/mattermost/focalboard/releases/download/v7.9.7/focalboard-server-linux-amd64.tar.gz|tar -xz --strip-components=1

# Configuration
mv config.json config.json.example
cat << EOF > config.json
{
    "serverRoot": "http://$INSTALL_URL",
    "ip": "::",
    "port": $PORT,
    "dbtype": "postgres",
    "dbconfig": "postgres://$DATABASE_USERNAME:$DATABASE_PASSWORD@$DATABASE_HOST/$DATABASE_NAME?sslmode=disable&connect_timeout=10",
    "useSSL": false,
    "webpath": "./pack",
    "filespath": "./files",
    "telemetry": true,
    "prometheusaddress": "",
    "session_expire_time": 2592000,
    "session_refresh_time": 18000,
    "localOnly": false,
    "enableLocalMode": true,
    "localModeSocketLocation": "/home/$USER/admin/tmp/focalboard_local.socket"
}
EOF

# Focalbaord 7.10 needs GLIBC 2.34
