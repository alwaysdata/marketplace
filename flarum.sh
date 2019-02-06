#!/bin/bash

# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}/public'
#     php_version: '7.3'
#     ssl_force: true
# database:
#     type: mysql
# form:
#     title:
#         label: Forum title
#         max_length: 255
#     email:
#         type: email
#         label: Email
#     admin_username:
#         label: Administrator username
#         regex: ^[a-zA-Z0-9_-]+$
#         max_length: 255
#     admin_password:
#         type: password
#         label: Administrator password
#         regex: ^[a-zA-Z0-9!#$€%&'[]()*+,./:;<=>?@^_`{|}~-]+$
#         max_length: 255
#         min_length: 8

set -e

composer create-project flarum/flarum default --stability=beta

cat << EOF > config.yml
baseUrl : "https://$INSTALL_URL"
databaseConfiguration :
    host : "$DATABASE_HOST"
    database : "$DATABASE_NAME"
    username : "$DATABASE_USERNAME"
    password : "$DATABASE_PASSWORD"
adminUser : 
    username : "$FORM_ADMIN_USERNAME"
    password : "$FORM_ADMIN_PASSWORD"
    password_confirmation : "$FORM_ADMIN_PASSWORD"
    email : "$FORM_EMAIL"
settings : 
    forum_title : "$FORM_TITLE"
EOF

php default/flarum install -f config.yml

rm -rf .composer config.yml

shopt -s dotglob nullglob
mv default/* .
rmdir default
