#!/bin/bash

# site:
#     type: wsgi
#     path_trim: true
#     python_version: '3.9'
#     working_directory: '{INSTALL_PATH_RELATIVE}'
#     virtualenv_directory: '{INSTALL_PATH_RELATIVE}/env'
#     path: '{INSTALL_PATH_RELATIVE}/{FORM_PROJECT}/wsgi.py'
#     static_paths:/static=static
# database:
#     type: postgresql
# requirements:
#     disk: 100
# form:
#     project:
#         label:
#             en: Project name
#             fr: Nom du projet
#         regex: ^[a-zA-Z0-9_]+$
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

# Python environment
python -m venv env
source env/bin/activate

# Django-CMS setup
# https://docs.django-cms.org/en/latest/how_to/install.html
python -m pip install django-cms
django-admin startproject $FORM_PROJECT $INSTALL_PATH
sed -i "s|DEBUG = True|DEBUG = False|" $FORM_PROJECT/settings.py
sed -i "s|^ALLOWED_HOSTS = .*|ALLOWED_HOSTS = [\'*']|" $FORM_PROJECT/settings.py
sed -i "/INSTALLED_APPS = \[/a \ \ \ \ 'djangocms_admin_style'," $FORM_PROJECT/settings.py
sed -i "/'django.contrib.staticfiles',/a \ \ \ \ 'django.contrib.sites'," $FORM_PROJECT/settings.py
sed -i "/'django.contrib.sites',/a \ \ \ \ 'cms'," $FORM_PROJECT/settings.py
sed -i "/'cms',/a \ \ \ \ 'menus'," $FORM_PROJECT/settings.py
sed -i "/'menus',/a \ \ \ \ 'treebeard'," $FORM_PROJECT/settings.py
sed -i "/'treebeard',/a \ \ \ \ 'sekizai'," $FORM_PROJECT/settings.py
sed -i "/'django.middleware.clickjacking.XFrameOptionsMiddleware',/a \ \ \ \ 'django.middleware.locale.LocaleMiddleware'," $FORM_PROJECT/settings.py
sed -i "/'django.middleware.locale.LocaleMiddleware',/a \ \ \ \ 'cms.middleware.user.CurrentUserMiddleware'," $FORM_PROJECT/settings.py
sed -i "/'cms.middleware.user.CurrentUserMiddleware',/a \ \ \ \ 'cms.middleware.page.CurrentPageMiddleware'," $FORM_PROJECT/settings.py
sed -i "/'cms.middleware.page.CurrentPageMiddleware',/a \ \ \ \ 'cms.middleware.toolbar.ToolbarMiddleware'," $FORM_PROJECT/settings.py
sed -i "/'cms.middleware.toolbar.ToolbarMiddleware',/a \ \ \ \ 'cms.middleware.language.LanguageCookieMiddleware'," $FORM_PROJECT/settings.py
sed -i "/'django.contrib.messages.context_processors.messages',/a \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 'sekizai.context_processors.sekizai'," $FORM_PROJECT/settings.py
sed -i "/'sekizai.context_processors.sekizai',/a \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 'cms.context_processors.cms_settings'," $FORM_PROJECT/settings.py
sed -i "/'cms.context_processors.cms_settings',/a \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 'django.template.context_processors.i18n'," $FORM_PROJECT/settings.py
sed -i "s|en-us|en|" $FORM_PROJECT/settings.py
sed -i "/STATIC_URL = '\/static\/'/a import os" $FORM_PROJECT/settings.py
sed -i "/import os/a STATIC_ROOT = os.path.join(BASE_DIR, \"static\")" $FORM_PROJECT/settings.py

echo "X_FRAME_OPTIONS = 'SAMEORIGIN'" >> $FORM_PROJECT/settings.py
echo "SITE_ID = 1" >> $FORM_PROJECT/settings.py

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

sed -i "s|'DIRS':\[\],|'DIRS': ['templates'],|" $FORM_PROJECT/settings.py
echo "CMS_TEMPLATES = [" >> $FORM_PROJECT/settings.py
echo "    ('home.html', 'Home page template')," >> $FORM_PROJECT/settings.py
echo "]" >> $FORM_PROJECT/settings.py

# Urls
sed -i "s|from django.urls import path|from django.urls import path, include|" $FORM_PROJECT/urls.py
sed -i "/admin.site.urls),/a \ \ \ \ path(\'\', include('cms.urls'))," $FORM_PROJECT/urls.py

# Database
sed -i "s|django.db.backends.sqlite3|django.db.backends.postgresql|" $FORM_PROJECT/settings.py
sed -i "s|BASE_DIR / 'db.sqlite3'|'$DATABASE_NAME'|" $FORM_PROJECT/settings.py
sed -i "/'$DATABASE_NAME',/a \ \ \ \ \ \ \ 'USER': '$DATABASE_USERNAME'," $FORM_PROJECT/settings.py
sed -i "/'$DATABASE_USERNAME',/a \ \ \ \ \ \ \ 'PASSWORD': '$DATABASE_PASSWORD'," $FORM_PROJECT/settings.py
sed -i "/'$DATABASE_PASSWORD',/a \ \ \ \ \ \ \ 'HOST': '$DATABASE_HOST'," $FORM_PROJECT/settings.py
sed -i "/'$DATABASE_HOST',/a \ \ \ \ \ \ \ 'PORT': '5432'," $FORM_PROJECT/settings.py
python -m pip install psycopg2
python manage.py migrate

python manage.py collectstatic

# First admin user
DJANGO_SUPERUSER_PASSWORD="$FORM_ADMIN_PASSWORD" python manage.py createsuperuser --username $FORM_ADMIN_USERNAME --email $FORM_EMAIL --noinput
