#!/bin/bash

# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}'
#     php_version: '8.0'
#     php_ini: extension=intl.so
# database:
#     type: mysql
# requirements:
#     disk: 240

set -e

# https://docs.humhub.org/docs/admin/installation/

wget -O- https://www.humhub.com/download/package/humhub-1.12.0.tar.gz | tar -xz --strip-components=1

curl -X POST -F DatabaseForm[hostname]="$DATABASE_HOST" -F DatabaseForm[username]="$DATABASE_USERNAME" -F DatabaseForm[password]="$DATABASE_PASSWORD" -F DatabaseForm[database]="$DATABASE_NAME" -F submit="Suivant" http://$INSTALL_URL/index.php?r=installer%2Fsetup%2Fdatabase

mv .htaccess.dist .htaccess
