#!/bin/bash

# Declare site in YAML, as documented on the documentation: https://help.alwaysdata.com/en/marketplace/build-application-script/
# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}/public'
#     php_version: '8.3'
#     php_ini: |
#         memory_limit=4096M
#         extension=intl.so
#         extension=sodium.so
# database:
#     type: mysql
# requirements:
#     disk: 700
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

# https://docs.sylius.com/en/latest/book/installation/requirements.html

# Download
composer2 create-project sylius/sylius-standard

# Configuration
cat << EOF > sylius-standard/.env.local
DATABASE_URL=mysql://$DATABASE_USERNAME:$DATABASE_PASSWORD@$DATABASE_HOST/$DATABASE_NAME
EOF

sed -i "s|locale: en_US|locale: $FORM_LANGUAGE|" sylius-standard/config/services.yaml

# Install
sylius-standard/bin/console sylius:install --env=prod -n --fixture-suite=default
echo "y"|sylius-standard/bin/console sylius:install:sample-data --env=prod

export NODEJS_VERSION=20
npm install yarn

cd sylius-standard
~/node_modules/yarn/bin/yarn install
~/node_modules/yarn/bin/yarn build
cd

# Clean install environment
rm -rf .config .local .subversion .cache node_modules .npm package.json package-lock.json .yarn .yarnrc .cache

shopt -s dotglob
mv sylius-standard/* .
rmdir sylius-standard

# Default credentials for first login: sylius / sylius
