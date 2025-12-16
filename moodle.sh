#!/bin/bash

# Declare site in YAML, as documented on the documentation: https://help.alwaysdata.com/en/marketplace/build-application-script/
# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}/public'
#     php_version: '8.4'
#     php_ini: |
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
#         regex_text:
#             en: "It can include uppercase, lowercase, numbers, spaces and special characters: +@_-."
#             fr: "Il peut comporter des majuscules, des minuscules, des chiffres, des espaces et les caractères spéciaux : +@_-."
#         max_length: 255
#     admin_password:
#         type: password
#         label:
#             en: Administrator password
#             fr: Mot de passe de l'administrateur
#         regex: ^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[*-+_!@#$%^&.,?])[A-Za-z\d*-+_!@#$%^&.,?]{8,}$
#         regex_text:
#             en: "It must be at least 8 characters; including at least one uppercase, one lowercase, one digit, and one of these special characters: *-+_!@#$%^&.,?."
#             fr: "Il doit comporter au moins 8 caractères ; dont au moins une majuscule, une minuscule, un chiffre, et un de ces caractères spéciaux : *-+_!@#$%^&.,?."
#         min_length: 8
#         max_length: 255

set -e

# https://docs.moodle.org/501/en/Installation_quick_guide

COMPOSER_CACHE_DIR=/dev/null composer2 create-project moodle/moodle

mkdir moodledata/

cat << EOF > moodledata/.htaccess
order deny,allow
deny from all
EOF

chmod 755 moodledata

php moodle/admin/cli/install.php --dbtype=mariadb --dbhost="$DATABASE_HOST" --dbname="$DATABASE_NAME" --dbuser="$DATABASE_USERNAME" --dbpass="$DATABASE_PASSWORD" --lang="$FORM_LANGUAGE" --wwwroot="https://$INSTALL_URL" --dataroot="$INSTALL_PATH/moodledata/" --adminuser="$FORM_ADMIN_USERNAME" --adminpass="$FORM_ADMIN_PASSWORD" --adminemail="$FORM_EMAIL" --fullname="$FORM_TITLE" --shortname="$FORM_TITLE" --agree-license --non-interactive

# Clean install environment
rm -rf .composer

shopt -s dotglob
mv moodle/* .
rmdir moodle
