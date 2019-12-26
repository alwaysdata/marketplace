#!/bin/bash

# site:
#     type: wsgi
#     path_trim: true
#     python_version: '3.8'
#     working_directory: '{INSTALL_PATH_RELATIVE}'
#     virtualenv_directory: '{INSTALL_PATH_RELATIVE}/env'
#     path: '{INSTALL_PATH_RELATIVE}/{FORM_PROJECT}/wsgi.py'
# form:
#     project:
#         label: Project name
#         regex: ^[a-zA-Z0-9_]+$
#         max_length: 255

set -e

# Python environment
python -m venv env
source env/bin/activate

# Django setup
pip install Django
django-admin startproject $FORM_PROJECT $INSTALL_PATH
sed -i "s|^ALLOWED_HOSTS = .*|ALLOWED_HOSTS = [\'*']|" $FORM_PROJECT/settings.py
