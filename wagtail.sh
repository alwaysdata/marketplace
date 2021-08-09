#!/bin/bash

# site:
#     type: wsgi
#     python_version: '3.9'
#     working_directory: '{INSTALL_PATH_RELATIVE}'
#     virtualenv_directory: '{INSTALL_PATH_RELATIVE}/env'
#     path: '{INSTALL_PATH_RELATIVE}/{FORM_PROJECT}/wsgi.py'
# form:
#     project:
#         label: Project name
#         regex: ^[a-zA-Z0-9_]+$
#         max_length: 255

set -e

python -m venv env
source env/bin/activate

pip install wagtail
./env/bin/wagtail start $FORM_PROJECT .

python manage.py migrate
