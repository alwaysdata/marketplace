#!/bin/bash

# Declare site in YAML, as documented on the documentation: https://help.alwaysdata.com/en/marketplace/build-application-script/
# site:
#     type: wsgi
#     python_version: '3.11'
#     working_directory: '{INSTALL_PATH_RELATIVE}'
#     virtualenv_directory: '{INSTALL_PATH_RELATIVE}/env'
#     path: '{INSTALL_PATH_RELATIVE}/{FORM_PROJECT}/wsgi.py'
#     static_paths: /static=static
#     environment: 'DJANGO_SETTINGS_MODULE={FORM_PROJECT}.settings.prod_local'
# database:
#     type: postgresql
# requirements:
#     disk: 130
# form:
#     project:
#         label:
#             en: Project name
#             fr: Nom du projet
#         regex: ^[a-zA-Z][a-zA-Z0-9_]+$
#         regex_text: "Il doit comporter des majuscules et minuscules et peut aussi utiliser des chiffres et le tiret bas (_)."
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
#         regex: ^[ a-zA-Z0-9.+@_-]+$
#         regex_text: "Il doit comporter au moins 5 caractères qui peuvent être des majuscules, des minuscules, des chiffres, des espaces et les caractères spéciaux : .+@_-."
#         min_length: 5
#         max_length: 150
#     admin_password:
#         type: password
#         label:
#             en: Administrator password
#             fr: Mot de passe de l'administrateur
#         min_length: 5
#         max_length: 255

set -e

# https://spirit.readthedocs.io/en/latest/installation.html

# Create a virtualenv & install Spirit in it
python -m venv env
source env/bin/activate

pip install django-spirit psycopg2

./env/bin/spirit startproject $FORM_PROJECT --path=.

# Configuration
cat << EOF > $FORM_PROJECT/settings/prod_local.py
from .base import *

ALLOWED_HOSTS = ['$INSTALL_URL', ]
SECRET_KEY = '$(openssl rand -base64 32)'
ST_SITE_URL = 'https://$INSTALL_URL'

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql_psycopg2',
        'NAME': '$DATABASE_NAME',
        'USER': '$DATABASE_USERNAME',
        'PASSWORD': '$DATABASE_PASSWORD',
        'HOST': '$DATABASE_HOST',
        'PORT': '5432',
    }
}
EOF

# Install
python manage.py spiritinstall --settings=$FORM_PROJECT.settings.prod_local
python manage.py migrate --settings=$FORM_PROJECT.settings.prod_local

# Create admin user
DJANGO_SUPERUSER_PASSWORD="$FORM_ADMIN_PASSWORD" python manage.py createsuperuser --username $FORM_ADMIN_USERNAME --email $FORM_EMAIL --settings=$FORM_PROJECT.settings.prod_local --noinput
