#!/bin/bash

# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}/public'
#     php_version: '8.1'
#     php_ini: extension=intl.so
# database:
#     type: mysql
# requirements:
#     disk: 250
# form:
#     username:
#         label:
#             en: Username
#             fr: Nom d'utilisateur
#     email:
#         type: email
#         label:
#             en: Email
#             fr: Email
#     password:
#         type: password
#         label:
#             en: Password
#             fr: Mot de passe
#         min_length: 8

set -e

wget -O- https://github.com/kevinpapst/kimai2/archive/refs/tags/1.24.0.tar.gz | tar -xz --strip-components=1

COMPOSER_CACHE_DIR=/dev/null composer2 install --no-dev --optimize-autoloader -n

cat << EOF > .env
DATABASE_URL=mysql://$DATABASE_USERNAME:$DATABASE_PASSWORD@$DATABASE_HOST:3306/$DATABASE_NAME?charset=utf8
MAILER_FROM=$USER@$RESELLER_DOMAIN
APP_ENV=prod
APP_SECRET="$(echo $RANDOM | md5sum | sed 's/ .*//')"
CORS_ALLOW_ORIGIN=^https?://localhost(:[0-9]+)?$
EOF

php bin/console kimai:install -n
php bin/console kimai:user:create $FORM_USERNAME $FORM_EMAIL ROLE_ADMIN $FORM_PASSWORD
