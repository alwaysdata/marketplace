#!/bin/bash

# Declare site in YAML, as documented on the documentation: https://help.alwaysdata.com/en/marketplace/build-application-script/
# site:
#     type: wsgi
#     path_trim: true
#     python_version: '3.12'
#     working_directory: '{INSTALL_PATH_RELATIVE}'
#     virtualenv_directory: '{INSTALL_PATH_RELATIVE}/env'
#     path: '{INSTALL_PATH_RELATIVE}/{FORM_PROJECT}/wsgi.py'
# requirements:
#     disk: 65
# form:
#     project:
#         label:
#             en: Project name
#             fr: Nom du projet
#         regex: ^[a-zA-Z][a-zA-Z0-9_]+$
#         regex_text: "Il doit comporter des majuscules et minuscules et peut aussi utiliser des chiffres et le tiret bas (_)."
#         max_length: 255

set -e

# https://docs.djangoproject.com/en/5.0/faq/install/

# Create a virtualenv and install Django in it
python -m venv env
source env/bin/activate

pip install Django
django-admin startproject $FORM_PROJECT $INSTALL_PATH

# By default ALLOWED_HOSTS is empty (https://docs.djangoproject.com/en/5.0/ref/settings/#allowed-hosts). We modify it so that it works for all possible addresses.
sed -i "s|^ALLOWED_HOSTS = .*|ALLOWED_HOSTS = [\'*']|" $FORM_PROJECT/settings.py
