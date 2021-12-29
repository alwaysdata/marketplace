#!/bin/bash

# site:
#     type: wsgi
#     python_version: '3.9'
#     working_directory: '{INSTALL_PATH_RELATIVE}'
#     virtualenv_directory: '{INSTALL_PATH_RELATIVE}/env'
#     path: '{INSTALL_PATH_RELATIVE}/wsgi.py'
#     environment: 'IHATEMONEY_SETTINGS_FILE_PATH={INSTALL_PATH}/ihatemoney.cfg'
#     ssl_force: true
# database:
#     type: postgresql
# requirements:
#     disk: 90

set -e

python -m venv env
source env/bin/activate

PIP_CACHE_DIR=/dev/null pip install ihatemoney psycopg2

./env/bin/ihatemoney generate-config ihatemoney.cfg > ihatemoney.cfg
sed -i "s|sqlite:////var/lib/ihatemoney/ihatemoney.sqlite|postgresql://$DATABASE_USERNAME:$DATABASE_PASSWORD@$DATABASE_HOST/$DATABASE_NAME?client_encoding=utf8|" ihatemoney.cfg
sed -i "s|budget@notmyidea.org|$USER@$RESELLER_DOMAIN|" ihatemoney.cfg
echo "MAIL_SERVER = \"smtp-$USER.$RESELLER_DOMAIN\"" >> ihatemoney.cfg
 
cat << EOF > wsgi.py
from ihatemoney.run import create_app

application = create_app()
EOF
