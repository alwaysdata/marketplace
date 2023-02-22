#!/bin/bash

# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}'
#     php_version: '8.0'
#     php_ini:|
#         extension=intl.so
#         max_input_vars=5000
# database:
#     type: mysql
# requirements:
#     disk: 300
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
#     title:
#         label:
#             en: Learning platform title
#             fr: Titre de la plateforme d'enseignement
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
#         regex: ^[ a-zA-Z0-9.@_-]+$
#         max_length: 255
#     admin_password:
#         type: password
#         label:
#             en: Administrator password
#             fr: Mot de passe de l'administrateur
#         regex: ^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[*\-#])[A-Za-z\d*\-#]{8,}$
#         min_length: 8
#         max_length: 255

set -e

# https://docs.moodle.org/310/en/Installing_Moodle

COMPOSER_CACHE_DIR=/dev/null composer2 create-project moodle/moodle

mkdir moodledata/

cat << EOF > moodledata/.htaccess
order deny,allow
deny from all
EOF

chmod 755 moodledata

php moodle/admin/cli/install.php --dbtype=mariadb --dbhost="$DATABASE_HOST" --dbname="$DATABASE_NAME" --dbuser="$DATABASE_USERNAME" --dbpass="$DATABASE_PASSWORD" --lang="$FORM_LANGUAGE" --wwwroot="https://$INSTALL_URL" --dataroot="$INSTALL_PATH/moodledata/" --adminuser="$FORM_ADMIN_USERNAME" --adminpass="$FORM_ADMIN_PASSWORD" --adminemail="$FORM_EMAIL" --fullname="$FORM_TITLE" --shortname="$FORM_TITLE" --agree-license --non-interactive

rm -rf .composer

shopt -s dotglob
mv moodle/* .
rmdir moodle
