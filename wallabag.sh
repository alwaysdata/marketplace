#!/bin/bash

# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}/web/'
#     php_version: '8.0'
#     php_ini: |
#         extension=intl.so
#         error_reporting = E_ALL & ~E_DEPRECATED
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
#     admin_username:
#         label:
#             en: Administrator username
#             fr: Nom d'utilisateur de l'administrateur
#         regex: ^[ a-zA-Z0-9.@_-]+$
#         max_length: 255
#     admin_password:
#         label:
#             en: Administrator password
#             fr: Mot de passe de l'administrateur
#         type: password
#         min_length: 5
#         max_length: 255

set -e

wget -O- https://github.com/wallabag/wallabag/releases/download/2.5.2/wallabag-2.5.2.tar.gz | tar -xz --strip-components=1

sed -i "s|database_host: 127.0.0.1|database_host: $DATABASE_HOST|" app/config/parameters.yml
sed -i "s|database_name: wallabag|database_name: $DATABASE_NAME|" app/config/parameters.yml
sed -i "s|database_user: root|database_user: $DATABASE_USERNAME|" app/config/parameters.yml
sed -i "s|database_password: null|database_password: '$DATABASE_PASSWORD'|" app/config/parameters.yml
sed -i "s|your-wallabag-url-instance.com|$INSTALL_URL|" app/config/parameters.yml
sed -i "s|locale: en|locale: $FORM_LANGUAGE|" app/config/parameters.yml

bin/console cache:clear --env=prod
bin/console wallabag:install --env=prod -n
bin/console fos:user:create --env=prod "$FORM_ADMIN_USERNAME" "$FORM_ADMIN_EMAIL" "$FORM_ADMIN_PASSWORD"
