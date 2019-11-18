#!/bin/bash

# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}'
#     php_version: '7.3'
#     php_ini: extension=xmlreader.so
# database:
#     type: mysql
# form:
#     admin_username:
#         label: Administrator username
#         max_length: 255
#     admin_password:
#         type: password
#         label: Administrator password
#         max_length: 255

set -e

# https://docs.nextcloud.com/server/17/admin_manual/configuration_server/occ_command.html?highlight=occ#command-line-installation-label

wget -O- https://github.com/nextcloud/server/archive/v17.0.1.tar.gz | tar -xz --strip-components=1
# Although not specified in the documentation, the 3rdparty directory must be downloaded separately, otherwise the occ command will complain.
wget -O- https://github.com/nextcloud/3rdparty/archive/v17.0.1.tar.gz | tar -C 3rdparty -xz --strip-components=1

composer install

php occ maintenance:install --database="mysql" --database-host="$DATABASE_HOST" --database-name="$DATABASE_NAME" --database-user="$DATABASE_USERNAME" --database-pass="$DATABASE_PASSWORD" --admin-user="$FORM_ADMIN_USERNAME" --admin-pass="$FORM_ADMIN_PASSWORD"
php occ config:system:set trusted_domains 0 --value="$INSTALL_URL_HOSTNAME"
php occ config:system:set overwrite.cli.url --value="http://$INSTALL_URL"

rm -rf  .composer .subversion
