#!/bin/bash

# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}'
#     php_version: '7.2'
#     php_ini: extension=intl.so
# database:
#     type: mysql

set -e

wget -O- https://github.com/NeoFragCMS/neofrag-cms/archive/alpha0.2.1.tar.gz | tar -xz --strip-components=1

mysql -h "$DATABASE_HOST" -u "$DATABASE_USERNAME" -p"$DATABASE_PASSWORD" "$DATABASE_NAME" < DATABASE.sql

cat << EOF > config/db.php
<?php

\$db[] = [
    'hostname' => '"$DATABASE_HOST"',
    'username' => '"$DATABASE_USERNAME"',
    'password' => '"$DATABASE_PASSWORD"',
    'database' => '"$DATABASE_NAME"',
    'driver'   => 'mysqli'
];    
EOF
