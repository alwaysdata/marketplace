#!/bin/bash

# Declare site in YAML, as documented on the documentation: https://help.alwaysdata.com/en/marketplace/build-application-script/
# site:
#     type: wsgi
#     path_trim: true
#     python_version: '3.12'
#     working_directory: '{INSTALL_PATH_RELATIVE}'
#     virtualenv_directory: '{INSTALL_PATH_RELATIVE}/env'
#     path: '{INSTALL_PATH_RELATIVE}/{FORM_PROJECT}/wsgi.py'
#     static_paths: /static=static
# database:
#     type: postgresql
# requirements:
#     disk: 90
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
#         max_length: 255
#     admin_password:
#         type: password
#         label:
#             en: Administrator password
#             fr: Mot de passe de l'administrateur
#         max_length: 255

set -e

# https://docs.django-cms.org/en/latest/how_to/install.html

# Create virtualenv and install dependancies
python -m venv env
source env/bin/activate
python -m pip install django-cms Django psycopg2
django-admin startproject $FORM_PROJECT $INSTALL_PATH

# Configuration
sed -i "s|DEBUG = True|DEBUG = False|" $FORM_PROJECT/settings.py
sed -i "s|^ALLOWED_HOSTS = .*|ALLOWED_HOSTS = [\'*']|" $FORM_PROJECT/settings.py

sed -i "/INSTALLED_APPS = \[/a \ \ \ \ 'djangocms_admin_style'," $FORM_PROJECT/settings.py
cat << EOF | sed -i "/'django.contrib.staticfiles',/r /dev/stdin" $FORM_PROJECT/settings.py
    'django.contrib.sites',
    'cms',
    'menus',
    'treebeard',
    'sekizai',
    '$FORM_PROJECT',
EOF

cat << EOF | sed -i "/'django.middleware.clickjacking.XFrameOptionsMiddleware',/r /dev/stdin" $FORM_PROJECT/settings.py
    'django.middleware.locale.LocaleMiddleware',
    'cms.middleware.user.CurrentUserMiddleware',
    'cms.middleware.page.CurrentPageMiddleware',
    'cms.middleware.toolbar.ToolbarMiddleware',
    'cms.middleware.language.LanguageCookieMiddleware',
EOF

cat << EOF | sed -i "/'django.contrib.messages.context_processors.messages',/r /dev/stdin" $FORM_PROJECT/settings.py
                'sekizai.context_processors.sekizai',
                'cms.context_processors.cms_settings',
                'django.template.context_processors.i18n',
EOF

sed -i "s|en-us|en|" $FORM_PROJECT/settings.py

# Statics
sed -i "s|STATIC_URL = '\/static\/'|STATIC_URL = 'static\/'|" $FORM_PROJECT/settings.py
cat << EOF  | sed -i "/'static\/'/r /dev/stdin" $FORM_PROJECT/settings.py
import os
STATIC_ROOT = os.path.join(BASE_DIR, "static")
EOF

echo "
X_FRAME_OPTIONS = 'SAMEORIGIN'

SITE_ID = 1
" >> $FORM_PROJECT/settings.py

# Templates
mkdir $FORM_PROJECT/templates
cat << EOF > $FORM_PROJECT/templates/home.html
{% load cms_tags sekizai_tags %}
<html>
    <head>
        <title>{% page_attribute "page_title" %}</title>
        {% render_block "css" %}
    </head>
    <body>
        {% cms_toolbar %}
        {% placeholder "content" %}
        {% render_block "js" %}
    </body>
</html>
EOF

echo "CMS_TEMPLATES = [
    ('home.html', 'Home page template'),
]" >> $FORM_PROJECT/settings.py

echo "CMS_CONFIRM_VERSION4 = True"  >> $FORM_PROJECT/settings.py

# Urls
sed -i "s|from django.urls import path|from django.urls import path, include|" $FORM_PROJECT/urls.py
sed -i "/admin.site.urls),/a \ \ \ \ path(\'\', include('cms.urls'))," $FORM_PROJECT/urls.py

# Database
sed -i "s|django.db.backends.sqlite3|django.db.backends.postgresql|" $FORM_PROJECT/settings.py
sed -i "s|BASE_DIR / 'db.sqlite3'|'$DATABASE_NAME'|" $FORM_PROJECT/settings.py
cat << EOF  | sed -i "/'$DATABASE_NAME',/r /dev/stdin" $FORM_PROJECT/settings.py
        'USER': '$DATABASE_USERNAME',
        'PASSWORD': '$DATABASE_PASSWORD',
        'HOST': '$DATABASE_HOST',
        'PORT': '5432',
EOF

python manage.py migrate

echo "yes"| python manage.py collectstatic

# Create admin username
DJANGO_SUPERUSER_PASSWORD="$FORM_ADMIN_PASSWORD" python manage.py createsuperuser --username $FORM_ADMIN_USERNAME --email $FORM_EMAIL --noinput

# Clean install environment
rm -rf ~/.cache
