#!/bin/bash

# Declare site in YAML, as documented on the documentation: https://help.alwaysdata.com/en/marketplace/build-application-script/
# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}'
#     php_version: '8.5'
# database:
#     type: mysql
# requirements:
#     disk: 90
# form:
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
#         max_length: 255
#     admin_username:
#         label:
#             en: Administrator username
#             fr: Nom d'utilisateur de l'administrateur
#         regex: ^[a-zA-Z0-9]+$
#         regex_text:
#             en: "It can include uppercase, lowercase and numbers."
#             fr: "Il peut comporter des majuscules, des minuscules et des chiffres."
#         max_length: 30
#     admin_password:
#         type: password
#         label:
#             en: Administrator password
#             fr: Mot de passe de l'administrateur
#         min_length: 6
#         max_length: 255

set -e

# https://omeka.org/classic/docs/Installation/System_Requirements/

# Download & install dependancies
wget -O- --no-hsts https://github.com/omeka/Omeka/archive/v3.2.tar.gz | tar -xz --strip-components=1
COMPOSER_CACHE_DIR=/dev/null composer2 install

# Configuration
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

# Install
curl -X POST -F username="$FORM_ADMIN_USERNAME" -F password="$FORM_ADMIN_PASSWORD" -F password_confirm="$FORM_ADMIN_PASSWORD" -F super_email="$FORM_EMAIL" -F administrator_email="$FORM_EMAIL" -F site_title="$FORM_TITLE" -F tag_delimiter=, -F fullsize_constraint=800 -F thumbnail_constraint=200 -F square_thumbnail_constraint=200 -F per_page_admin=10 -F per_page_public=10 -F path_to_convert="$INSTALL_PATH_RELATIVE/imagemagick" -F install_submit=Install http://$INSTALL_URL/install/install.php

sed -i 's|# RewriteBase /|RewriteBase '$INSTALL_URL_PATH' |' .htaccess
