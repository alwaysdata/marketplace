#!/bin/bash

# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}/public'
#     php_version: '8.2'
#     php_ini: |
#         memory_limit=4096M
#         extension=intl.so
# database:
#     type: mysql
# requirements:
#     disk: 650
# form:
#     language:
#         type: choices
#         label:
#             en: Language
#             fr: Langue
#         choices:
#             de_DE: Deutsch
#             en_US: English
#             es_ES: Español
#             fr_FR: Français

set -e
# Requirements: https://docs.sylius.com/en/1.10/book/installation/requirements.html
# Sylius install
COMPOSER_CACHE_DIR=/dev/null composer2 create-project sylius/sylius-standard

cat << EOF > sylius-standard/.env.local
DATABASE_URL=mysql://$DATABASE_USERNAME:$DATABASE_PASSWORD@$DATABASE_HOST/$DATABASE_NAME
EOF

sed -i "s|locale: en_US|locale: $FORM_LANGUAGE|" sylius-standard/config/services.yaml

COMPOSER_CACHE_DIR=/dev/null composer2 require doctrine/dbal:"^2.6"
sylius-standard/bin/console sylius:install --env=prod -n --fixture-suite=default
echo "y"|sylius-standard/bin/console sylius:install:sample-data --env=prod

export NODEJS_VERSION=18
npm config set scripts-prepend-node-path true
npm install yarn

cd sylius-standard
~/node_modules/yarn/bin/yarn install
~/node_modules/yarn/bin/yarn build
cd

# Nettoyage
rm -rf .config .local .subversion .cache .babel.json composer.json composer.lock node_modules .npm .npm-packages .npmrc package-lock.json vendor .yarn
shopt -s dotglob
mv sylius-standard/* .
rmdir sylius-standard

# default credentials: sylius / sylius
