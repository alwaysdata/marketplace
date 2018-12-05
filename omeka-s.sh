#!/bin/sh

# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}'
#     php_version: '7.2'
# database:
#     type: mysql
# form:
#     title:
#         label: Title
#         max_length: 255
#     email:
#         type: email
#         label: Email
#     admin_username:
#         label: Administrator username
#         max_length: 255
#     admin_password:
#         type: password
#         label: Administrator password
#         max_length: 255

set -e

wget -O- https://github.com/omeka/omeka-s/archive/v1.3.0.tar.gz | tar -xz --strip-components=1

# https://omeka.org/s/docs/user-manual/install/

composer install

cat << EOF > config/database.ini
user = '$DATABASE_USERNAME'
password = '$DATABASE_PASSWORD'
dbname = '$DATABASE_NAME'
host = '$DATABASE_HOST'
EOF

mv .htaccess.dist  .htaccess

curl -X POST -F user[email]="$FORM_EMAIL" -F user[email-confirm]="$FORM_EMAIL" -F user[password]="$FORM_ADMIN_PASSWORD" -F user[password-confirm]="$FORM_ADMIN_PASSWORD" -F user[name]="$FORM_ADMIN_USERNAME" -F settings[installation_title]="$FORM_TITLE" -F settings[time_zone]=Europe/Paris -F submit=Submit http://$INSTALL_URL/install
