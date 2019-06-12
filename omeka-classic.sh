#!/bin/bash

# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}'
#     php_version: '7.3'
#     php_ini: extension=exif.so
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
#         regex: ^[a-zA-Z0-9]+$
#         max_length: 30
#     admin_password:
#         type: password
#         label: Administrator password
#         min_length: 6
#         max_length: 255

set -e

wget -O- https://github.com/omeka/Omeka/archive/v2.7.tar.gz | tar -xz --strip-components=1

# https://omeka.org/docs/user-manual/install/

composer install

cat << EOF > db.ini
[database]
username = "$DATABASE_USERNAME"
password = "$DATABASE_PASSWORD"
dbname = "$DATABASE_NAME"
host = "$DATABASE_HOST"
prefix = "omeka_"
charset = "utf8"
;port = ""
EOF

mv .htaccess.changeme  .htaccess
mv application/config/config.ini.changeme application/config/config.ini

curl -X POST -F username="$FORM_ADMIN_USERNAME" -F password="$FORM_ADMIN_PASSWORD" -F password_confirm="$FORM_ADMIN_PASSWORD" -F super_email="$FORM_EMAIL" -F administrator_email="$FORM_EMAIL" -F site_title="$FORM_TITLE" -F tag_delimiter=, -F fullsize_constraint=800 -F thumbnail_constraint=200 -F square_thumbnail_constraint=200 -F per_page_admin=10 -F per_page_public=10 -F path_to_convert="$INSTALL_PATH_RELATIVE/imagemagick" -F install_submit=Install http://$INSTALL_URL/install/install.php

sed -i 's|# RewriteBase /|RewriteBase '$INSTALL_URL_PATH' |' .htaccess
