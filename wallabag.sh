#!/bin/bash

# Declare site in YAML, as documented on the documentation: https://help.alwaysdata.com/en/marketplace/build-application-script/
# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}/web/'
#     php_version: '8.0'
#     php_ini: |
#         extension=intl.so
# database:
#     type: mysql
# requirements:
#     disk: 200
# form:
#     language:
#         type: choices
#         label:
#             en: Language
#             fr: Langue
#         choices:
#             de: Deutsch 
#             en: English
#             es: Español
#             fr: Français
#             it: Italiano
#     admin_email:
#         type: email
#         label:
#             en: Email
#             fr: Email
#         max_length: 255
#     admin_username:
#         label:
#             en: Administrator username
#             fr: Nom d'utilisateur de l'administrateur
#         regex: ^[ a-zA-Z0-9.@_-]+$
#         regex_text: "Il peut comporter des majuscules, des minuscules, des chiffres, des espaces et les caractères spéciaux : .@_-."
#         max_length: 255
#     admin_password:
#         label:
#             en: Administrator password
#             fr: Mot de passe de l'administrateur
#         type: password
#         min_length: 5
#         max_length: 255

set -e

# https://doc.wallabag.org/en/admin/installation/requirements

# Download
wget -O- --no-hsts https://github.com/wallabag/wallabag/releases/download/2.6.10/wallabag-2.6.10.tar.gz | tar -xz --strip-components=1

# Configuration
sed -i "s|database_host: 127.0.0.1|database_host: $DATABASE_HOST|" app/config/parameters.yml
sed -i "s|database_name: wallabag|database_name: $DATABASE_NAME|" app/config/parameters.yml
sed -i "s|database_user: root|database_user: $DATABASE_USERNAME|" app/config/parameters.yml
sed -i "s|database_password: null|database_password: '$DATABASE_PASSWORD'|" app/config/parameters.yml
sed -i "s|your-wallabag-instance.wallabag.org|$INSTALL_URL|" app/config/parameters.yml
sed -i "s|locale: en|locale: $FORM_LANGUAGE|" app/config/parameters.yml
sed -i "s|smtp://127.0.0.1|smtp://$SMTP_HOST|" app/config/parameters.yml
sed -i "s|no-reply@wallabag.org|$USER@$RESELLER_DOMAIN|" app/config/parameters.yml

# Install
bin/console cache:clear --env=prod
bin/console wallabag:install --env=prod -n

# Create admin user
bin/console fos:user:create --env=prod "$FORM_ADMIN_USERNAME" "$FORM_ADMIN_EMAIL" "$FORM_ADMIN_PASSWORD"
