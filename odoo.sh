#!/bin/bash

# Declare site in YAML, as documented on the documentation: https://help.alwaysdata.com/en/marketplace/build-application-script/
# site:
#     type: user_program
#     working_directory: '{INSTALL_PATH_RELATIVE}'
#     command: '.venv/bin/python odoo-bin --config=.odoorc --http-port=$PORT'
# database:
#     type: postgresql
# requirements:
#     disk: 1100

set -e

# https://www.odoo.com/documentation/17.0/administration/install/source.html
# https://www.odoo.com/documentation/17.0/administration/on_premise/deploy.html#builtin-server
# https://www.odoo.com/documentation/17.0/developer/reference/cli.html

export PYTHON_VERSION=3.11
export NODEJS_VERSION=20

git clone -b 17.0 --depth 1 https://github.com/odoo/odoo.git .

npm install -g rtlcss

# Create virtualenv & install dependancies in it
python -m venv .venv
source .venv/bin/activate

pip install --upgrade pip
pip install -r requirements.txt

mkdir -p odoo-data

# Configuration
cat << EOF > .odoorc
[options]
db_name = $DATABASE_NAME
db_user = $DATABASE_USERNAME
db_password = $DATABASE_PASSWORD
db_host = $DATABASE_HOST
addons_path = $INSTALL_PATH/addons
data_dir = $INSTALL_PATH/odoo-data
email_from = $USER@$RESELLER_DOMAIN
http_interface = ::
EOF

# Install
python odoo-bin --config=.odoorc --init --no-http --stop-after-init

# Default credentials for first login: admin / admin
