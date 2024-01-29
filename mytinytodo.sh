#!/bin/bash

# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}'
#     php_version: '8.3'
#     ssl_force: true
# database:
#     type: mysql
# requirements:
#     disk: 5

set -e

wget -O- --no-hsts https://github.com/maxpozdeev/mytinytodo/releases/download/v1.8.1/mytinytodo-v1.8.1.tar.gz| tar -xz --strip-components=1

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

#As there is a "No token provided" with curl, the client will need to go to https://$INSTALL_URL/setup.php at the end, then removed the setup.php
