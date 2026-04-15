#!/bin/bash

# Declare site in YAML, as documented on the documentation: https://help.alwaysdata.com/en/marketplace/build-application-script/
# site:
#     type: user_program
#     working_directory: '{INSTALL_PATH_RELATIVE}'
#     command: './env/bin/kinto start'
#     environment: |
#         PYTHON_VERSION=3.14
#     ssl_force: true
# database:
#     type: postgresql
# requirements:
#     disk: 120

set -e

export PYTHON_VERSION=3.14

# Create virtualenv and install Kinto in it
python -m venv env
source env/bin/activate
python -m pip install kinto[postgresql]

# Configuration
# https://docs.kinto-storage.org/en/latest/configuration/settings.html
kinto init --ini config/kinto.ini --backend postgresql --cache-backend postgresql
sed -i "s|postgresql://postgres:postgres@localhost/postgres|postgresql://$DATABASE_USERNAME:$DATABASE_PASSWORD@$DATABASE_HOST/$DATABASE_NAME|" config/kinto.ini
sed -i "s|port = %(http_port)s|port = $PORT|" config/kinto.ini
sed -i "s|host = 127.0.0.1|host = ::|" config/kinto.ini

kinto migrate --ini config/kinto.ini
