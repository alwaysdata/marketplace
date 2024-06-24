#!/bin/bash

# Declare site in YAML, as documented on the documentation: https://help.alwaysdata.com/en/marketplace/build-application-script/
# site:
#     type: user_program
#     working_directory: '{INSTALL_PATH_RELATIVE}'
#     command: './gogs web'
#     path_trim: true
# database:
#     type: postgresql
# requirements:
#     disk: 60

set -e

# Download
wget -O- --no-hsts https://github.com/gogs/gogs/releases/download/v0.13.0/gogs_0.13.0_linux_amd64.tar.gz|tar -xz --strip-components=1

# Configuration
mkdir -p custom/conf

cat << EOF > custom/conf/app.ini

RUN_MODE = prod
RUN_USER   = $USER
[server]
HTTP_PORT = $PORT
DOMAIN = 0.0.0.0
EXTERNAL_URL = http://$INSTALL_URL/

[database]
DB_TYPE  = postgres
HOST     = $DATABASE_HOST:5432
NAME     = $DATABASE_NAME
USER     = $DATABASE_USERNAME
PASSWORD = $DATABASE_PASSWORD
EOF

# Install
curl -X POST -F db_type=PostgreSQL -F db_host=$DATABASE_HOST:5432 -F db_user=$DATABASE_USERNAME -F db_passwd=$DATABASE_PASSWORD -F db_name=$DATABASE_NAME -F db_schema=public -F app_name=Gogs -F repo_root_path=$INSTALL_PATH/gogs-repositories -F run_user=$USER -F domain=0.0.0.0 -F http_port=$PORT -F app_url=http://$INSTALL_URL/ -F log_root_path=$INSTALL_PATH/log -F submit="Installer Gogs" http://$INSTALL_URL/install
