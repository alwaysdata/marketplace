#!/bin/bash

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
#         max_length: 255
#     email:
#         type: email
#         label:
#             en: Email
#             fr: Email
#     admin_username:
#         label:
#             en: Administrator username
#             fr: Nom d'utilisateur de l'administrateur
#         regex: ^[ a-zA-Z0-9.+@_-]+$
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

python -m venv env
source env/bin/activate

# https://spirit.readthedocs.io

pip install django-spirit psycopg2

./env/bin/spirit startproject $FORM_PROJECT --path=.

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

python manage.py spiritinstall --settings=$FORM_PROJECT.settings.prod_local
python manage.py migrate --settings=$FORM_PROJECT.settings.prod_local

# First admin user
DJANGO_SUPERUSER_PASSWORD="$FORM_ADMIN_PASSWORD" python manage.py createsuperuser --username $FORM_ADMIN_USERNAME --email $FORM_EMAIL --settings=$FORM_PROJECT.settings.prod_local --noinput
