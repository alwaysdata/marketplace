#!/bin/bash

# site:
#     type: wsgi
#     python_version: '3.9'
#     path: '{INSTALL_PATH_RELATIVE}/setup/odoo-wsgi.py'
#     working_directory: '{INSTALL_PATH_RELATIVE}'
#     virtualenv_directory: '{INSTALL_PATH_RELATIVE}/env'
# database:
#     type: postgresql

set -e

# https://www.odoo.com/documentation/14.0/setup/install.html#setup-install-source

python -m venv env
source env/bin/activate
wget -O- https://download.odoocdn.com/14.0/nightly/src/odoo_14.0.latest.tar.gz | tar -xz --strip-components=1

# Avoid segmentation fault issues, see: https://github.com/psycopg/psycopg2/issues/543
sed -i 's/psycopg2==\(2\.7.*\);/psycopg2==2.8;/' requirements.txt
pip install -r requirements.txt

python setup.py install

mkdir -p odoo-data addons

cat << EOF > setup/odoo-wsgi.py

import odoo

#----------------------------------------------------------
# Common
#----------------------------------------------------------
odoo.multi_process = True

# Equivalent of --load command-line option
odoo.conf.server_wide_modules = ['web']
conf = odoo.tools.config

# Path to the OpenERP Addons repository (comma-separated for multiple locations)

conf['addons_path'] = '$INSTALL_PATH/addons, $INSTALL_PATH/odoo/addons'

# Database config
conf['db_name'] = '$DATABASE_NAME'
conf['db_host'] = '$DATABASE_HOST'
conf['db_user'] = '$DATABASE_USERNAME'
conf['db_password'] = "$DATABASE_PASSWORD"

conf['data_dir'] = '$INSTALL_PATH/odoo-data'

#----------------------------------------------------------
# Generic WSGI handlers application
#----------------------------------------------------------
application = odoo.service.wsgi_server.application

odoo.service.server.load_server_wide_modules()

EOF

python setup/odoo --without-demo=WITHOUT_DEMO --init=INIT --database="$DATABASE_NAME" --db_user="$DATABASE_USERNAME" --db_password="$DATABASE_PASSWORD" --db_host="$DATABASE_HOST" --data-dir=odoo-data --stop-after-init

# default credentials: admin / admin - to change at the first logging
