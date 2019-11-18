#!/bin/bash

# site:
#     type: wsgi
#     python_version: '3.7'
#     path: '{INSTALL_PATH_RELATIVE}/setup/odoo-wsgi.py'
#     working_directory: '{INSTALL_PATH_RELATIVE}'
#     virtualenv_directory: '{INSTALL_PATH_RELATIVE}/myenv'
# database:
#     type: postgresql

set -e

python -m venv myenv
source myenv/bin/activate
wget -O- https://download.odoocdn.com/13.0/nightly/src/odoo_13.0.latest.tar.gz | tar -xz --strip-components=1

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
