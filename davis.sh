#!/bin/bash

# Declare site in YAML, as documented on the documentation: https://help.alwaysdata.com/en/marketplace/build-application-script/
# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}/public'
#     php_version: '8.3'
#     ssl_force: true
#     vhost_additional_directives: |
#          RewriteEngine On
#          RewriteRule ^\.well-known/carddav /dav/ [R=301,L]
#          RewriteRule ^\.well-known/caldav /dav/ [R=301,L]
# database:
#     type: mysql
# requirements:
#     disk: 100
# form:
#     admin_login:
#         label:
#             en: Admin username
#             fr: Identifiant administrateur
#         max_length: 255
#     admin_password:
#         type: password
#         label:
#             en: Admin password
#             fr: Mot de passe administrateur
#         regex: ^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#$%^&*_=+-]).{8,}$
#         regex_text:
#             en: "It must be at least 8 characters; including at least one uppercase, one lowercase, one digit, and one of these special characters: !@#$%^&*_=+-"
#             fr: "Il doit comporter au moins 8 caractères ; dont au moins une majuscule, une minuscule, un chiffre, et un de ces caractères spéciaux : !@#$%^&*_=+-"
#         min_lenght: 8
#         max_length: 255

set -e

# Install

wget -O- --no-hsts https://github.com/tchapi/davis/archive/refs/tags/v5.2.0.tar.gz | tar -xz --strip-components=1

COMPOSER_CACHE_DIR=/dev/null composer2 require symfony/polyfill-intl-messageformatter
COMPOSER_CACHE_DIR=/dev/null composer2 install

mkdir -p home public

# Configuration
rm .env.test

cat  << EOF > .env.local
APP_ENV=prod
APP_DEBUG=false
APP_SECRET='$(openssl rand -hex 16)'
DATABASE_DRIVER=mysql
DATABASE_URL="mysql://$DATABASE_USERNAME:$DATABASE_PASSWORD@$DATABASE_HOST:3306/$DATABASE_NAME?charset=utf8mb4"
ADMIN_LOGIN=$FORM_ADMIN_LOGIN
ADMIN_PASSWORD=$FORM_ADMIN_PASSWORD
AUTH_REALM=SabreDAV
AUTH_METHOD=Basic
CALDAV_ENABLED=true
CARDDAV_ENABLED=true
WEBDAV_ENABLED=false
INVITE_FROM_ADDRESS=$USER@$RESELLER_DOMAIN
MAILER_DSN="smtp://$SMTP_HOST:465?encryption=ssl"
EOF

# Set database
bin/console doctrine:migrations:migrate
