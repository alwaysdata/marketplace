#!/bin/bash

# Declare site in YAML, as documented on the documentation: https://help.alwaysdata.com/en/marketplace/build-application-script/
# site:
#     type: wsgi
#     python_version: '3.14'
#     working_directory: '{INSTALL_PATH_RELATIVE}'
#     virtualenv_directory: '{INSTALL_PATH_RELATIVE}/env'
#     path: '{INSTALL_PATH_RELATIVE}/{FORM_PROJECT}/wsgi.py'
# requirements:
#     disk: 160
# form:
#     project:
#         label:
#             en: Project name
#             fr: Nom du projet
#         regex: ^[a-zA-Z0-9_]+$
#         regex_text:
#             en: "It can include uppercase and lowercase, numbers and underscores (_)."
#             fr: "Il peut comporter des majuscules, minuscules, des chiffres et le tiret bas (_)."
#         max_length: 255
#     email:
#         type: email
#         label:
#             en: Email
#             fr: Email
#         max_length: 255
#     admin_username:
#         label:
#             en: Administrator username
#             fr: Nom d'utilisateur de l'administrateur
#         max_length: 255
#     admin_password:
#         type: password
#         label:
#             en: Administrator password
#             fr: Mot de passe de l'administrateur
#         max_length: 255

set -e

# https://docs.wagtail.org/en/stable/releases/upgrading.html#compatible-django-python-versions

# Create a virtualenv and install Wagtail in it
python -m venv env
source env/bin/activate

python -m pip install wagtail
./env/bin/wagtail start $FORM_PROJECT .

python manage.py migrate

# Create admin user
DJANGO_SUPERUSER_PASSWORD="$FORM_ADMIN_PASSWORD" python manage.py createsuperuser --username $FORM_ADMIN_USERNAME --email $FORM_EMAIL --noinput
