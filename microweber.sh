#!/bin/bash

# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}'
#     php_version: '8.2'
#     php_ini: |
#         extension={INSTALL_PATH}/mcrypt-8.2.so
#         extension=intl.so
#         extension=sodium.so
#     ssl_force: true
# database:
#     type: mysql
# requirements:
#     disk: 500
# form:
#     email:
#         type: email
#         label:
#             en: Email
#             fr: Email
#     admin_username:
#         label:
#             en: Administrator username
#             fr: Nom d'utilisateur de l'administrateur
#         max_length: 255
#     admin_password:
#         type: password
#         label:
#             en: Administrator password
#             fr: Mot de passe de l'administrateur
#         max_length: 255
#         min_length: 8
set -e

ad_install_pecl mcrypt

COMPOSER_CACHE_DIR=/dev/null composer2 create-project microweber/microweber --no-interaction

cd microweber

# To avoid "Error: Could not connect to the database.  Please check your configuration. SQLSTATE[HY000] [2002] No such file or directory" we prepare the database connection file
mv config/database.php config/database.php.example
cat << EOF > config/database.php
<?php return array (
  'fetch' => 8,
  'default' => 'mysql',
  'connections' =>
  array (
    'mysql' =>
    array (
      'driver' => 'mysql',
      'host'      => '$DATABASE_HOST',
      'database'  => '$DATABASE_NAME',
      'username'  => '$DATABASE_USERNAME',
      'password'  => '$DATABASE_PASSWORD',
      'charset' => 'utf8',
      'collation' => 'utf8_unicode_ci',
      'prefix' => '',
      'strict' => false,
    ),
  ),
  'migrations' => 'migrations',
  'redis' =>
  array (
    'cluster' => false,
    'default' =>
    array (
      'host' => '127.0.0.1',
      'port' => 6379,
      'database' => 0,
    ),
  ),
);
EOF

php artisan microweber:install --email="$FORM_EMAIL" --username="$FORM_ADMIN_USERNAME" --password="$FORM_ADMIN_PASSWORD" --db-host="$DATABASE_HOST" --db-name="$DATABASE_NAME" --db-username="$DATABASE_USERNAME" --db-password="$DATABASE_PASSWORD" --db-driver=mysql --template=default --default-content

# Nettoyage
cd
rm -rf .subversion .config .local .rnd
shopt -s dotglob
mv microweber/* .
rmdir microweber
