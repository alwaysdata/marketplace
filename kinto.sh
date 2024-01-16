#!/bin/bash

# site:
#     type: wsgi
#     path: '{INSTALL_PATH_RELATIVE}/app.wsgi'
#     python_version: '3.12'
#     virtualenv_directory: '{INSTALL_PATH_RELATIVE}/env'
#     working_directory: '{INSTALL_PATH_RELATIVE}'
#     ssl_force: true
# database:
#     type: postgresql
# requirements:
#     disk: 85

set -e

# Python environment
python -m venv env
source env/bin/activate
python -m pip install kinto[postgresql]

# WSGI
wget --no-hsts https://raw.githubusercontent.com/Kinto/kinto/master/app.wsgi

# Application configuration
kinto init --ini config/kinto.ini --backend postgresql --cache-backend postgresql
sed -i "s|postgresql://postgres:postgres@localhost/postgres|postgresql://$DATABASE_USERNAME:$DATABASE_PASSWORD@$DATABASE_HOST/$DATABASE_NAME|" config/kinto.ini
kinto migrate --ini config/kinto.ini
