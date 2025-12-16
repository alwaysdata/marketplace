#!/bin/bash

# Declare site in YAML, as documented on the documentation: https://help.alwaysdata.com/en/marketplace/build-application-script/
# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}/public'
#     php_version: '8.5'
#     php_ini: |
#         memory_limit=512M
# database:
#     type: mysql
# requirements:
#     disk: 250
# form:
#     username:
#         label:
#             en: Username
#             fr: Nom d'utilisateur
#         regex: ^[a-zA-Z0-9_-]+$
#         regex_text:
#             en: "It can include uppercase, lowercase, numbers, hyphen (-) and underscore (_)."
#             fr: "Il peut comporter des majuscules, des minuscules, des chiffres, le tiret (-) et le tiret bas (_)."
#         max_length: 255
#     email:
#         type: email
#         label:
#             en: Email
#             fr: Email
#         max_length: 255
#     password:
#         type: password
#         label:
#             en: Password
#             fr: Mot de passe
#         min_length: 8
#         max_length: 255

set -e

# https://www.kimai.org/documentation/installation.html

# Download and install dependancies
git clone -b 2.44.0 --depth 1 https://github.com/kimai/kimai.git
cd kimai/

COMPOSER_CACHE_DIR=/dev/null composer2 install --no-dev --optimize-autoloader -n

# Configuration
cat << EOF > .env
DATABASE_URL=mysql://$DATABASE_USERNAME:$DATABASE_PASSWORD@$DATABASE_HOST:3306/$DATABASE_NAME
MAILER_FROM=$USER@$RESELLER_DOMAIN
APP_ENV=prod
APP_SECRET="$(echo $RANDOM | md5sum | sed 's/ .*//')"
CORS_ALLOW_ORIGIN=^https?://localhost(:[0-9]+)?$
EOF

# Install
php bin/console kimai:install -n

# Create admin username
php bin/console kimai:user:create $FORM_USERNAME $FORM_EMAIL ROLE_ADMIN $FORM_PASSWORD

# Clean install environment
cd
rm -rf .config .local
shopt -s dotglob
mv kimai/* .
rmdir kimai
