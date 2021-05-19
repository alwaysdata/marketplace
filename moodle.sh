#!/bin/bash

# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}'
#     php_version: '7.4'
#     php_ini: extension=intl.so
# database:
#     type: mysql
# form:
#     language:
#         type: choices
#         label: Language
#         initial: en
#         choices:
#             de: German
#             en: English
#             es: Spanish
#             fr: French
#             it: Italian
#     title:
#         label: Learning platform title
#         max_length: 255
#     email:
#         type: email
#         label: Email
#     admin_username:
#         label: Administrator username
#         regex: ^[ a-zA-Z0-9.@_-]+$
#         max_length: 255
#     admin_password:
#         type: password
#         label: Administrator password
#         regex: ^(?=.*[A-Z])(?=.*[0-9])(?=.*[!"#$€%&'()[]*+,./:;<=>?@\^_`{|}~-])+$
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
