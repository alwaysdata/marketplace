#!/bin/bash

# site:
#     type: wsgi
#     python_version: '2.7'
#     working_directory: '{INSTALL_PATH_RELATIVE}'
#     virtualenv_directory: '{INSTALL_PATH_RELATIVE}/env'
#     path: '{INSTALL_PATH_RELATIVE}/connecthys.wsgi'
#     path_trim: true

set -e

# https://github.com/Noethys/Connecthys

python -m virtualenv env
source env/bin/activate

pip install pycrypto flask

wget -O- https://github.com/Noethys/Connecthys/archive/0.7.1.tar.gz | tar -xz --strip-components=1

shopt -s dotglob nullglob
mv connecthys/* .
rmdir connecthys

chmod 755 connecthys.wsgi run.py
