#!/bin/bash

# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}'
#     php_version: '8.2'
#     php_ini: extension=intl.so
# database:
#     type: mysql
# requirements:
#     disk: 90
# form:
#     language:
#         type: choices
#         label:
#             en: Language
#             fr: Langue
#         choices:
#             de_DE: Deutsch
#             en_US: English
#             es: Español
#             fr: Français
#             it: Italiano
#     title:
#         label:
#             en: Title
#             fr: Titre
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

wget -O- https://github.com/omeka/omeka-s/archive/v4.0.0.tar.gz | tar -xz --strip-components=1

# https://omeka.org/s/docs/user-manual/install/

COMPOSER_CACHE_DIR=/dev/null composer2 install

cat << EOF > config/database.ini
user = '$DATABASE_USERNAME'
password = '$DATABASE_PASSWORD'
dbname = '$DATABASE_NAME'
host = '$DATABASE_HOST'
EOF

mv .htaccess.dist  .htaccess

curl -X POST -F user[email]="$FORM_EMAIL" -F user[email-confirm]="$FORM_EMAIL" -F user[name]="$FORM_ADMIN_USERNAME" -F user[password-confirm][password]="$FORM_ADMIN_PASSWORD" -F user[password-confirm][password-confirm]="$FORM_ADMIN_PASSWORD" -F settings[installation_title]="$FORM_TITLE" -F settings[time_zone]=Europe/Paris -F settings[locale]="$FORM_LANGUAGE" -F submit=Submit http://$INSTALL_URL/install
