#!/bin/bash

# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}'
#     php_version: '8.1'
# database:
#     type: mysql
# requirements:
#     disk: 5

set -e

wget -O- https://github.com/maxpozdeev/mytinytodo/releases/download/v1.7.0/mytinytodo-v1.7.0.tar.gz| tar -xz --strip-components=1

cat << EOF > config.php
<?php

define("MTT_DB_TYPE", "mysql");

define("MTT_DB_HOST", "$DATABASE_HOST");

define("MTT_DB_NAME", "$DATABASE_NAME");

define("MTT_DB_USER", "$DATABASE_USERNAME");

define("MTT_DB_PASSWORD", "$DATABASE_PASSWORD");

define("MTT_DB_PREFIX", "");

define("MTT_SALT", "$(echo $RANDOM | md5sum | sed 's/ .*//')");
EOF

curl -X POST -F install=create https://$INSTALL_URL/setup.php
  
rm setup.php
