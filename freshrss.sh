#!/bin/bash

# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}'
#     php_version: '7.4'
#     php_ini: extension=pdo_sqlite.so
# database:
#     type: mysql
# form:
#     language:
#         type: choices
#         label: Language
#         initial: en_US
#         choices:
#             de: German
#             en_US: English
#             es: Spanish
#             fr: French
#             it: Italian
#     title:
#         label: Feed title
#         max_length: 255
#     username:
#         label: Administrator username
#         regex: ^[ a-zA-Z0-9.@_-]+$
#         max_length: 255
#     password:
#         type: password
#         label: Username password
#         max_length: 255

set -e

wget -O- https://github.com/FreshRSS/FreshRSS/archive/1.18.0.tar.gz | tar -xz --strip-components=1

./cli/do-install.php --default_user admin --auth_type form --environment production --base_url https://$INSTALL_URL --language "$FORM_LANGUAGE" --title "$FORM_TITLE" --db-type mysql --db-host "$DATABASE_HOST":3306 --db-user "$DATABASE_USERNAME" --db-password "$DATABASE_PASSWORD" --db-base "$DATABASE_NAME"

./cli/create-user.php --user "$FORM_USERNAME" --password "$FORM_PASSWORD"
