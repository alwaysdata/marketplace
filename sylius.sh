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
# Requirements: https://docs.sylius.com/en/1.12/book/installation/requirements.html
# Sylius install
composer2 create-project sylius/sylius-standard

cat << EOF > sylius-standard/.env.local
DATABASE_URL=mysql://$DATABASE_USERNAME:$DATABASE_PASSWORD@$DATABASE_HOST/$DATABASE_NAME
EOF

sed -i "s|locale: en_US|locale: $FORM_LANGUAGE|" sylius-standard/config/services.yaml

sylius-standard/bin/console sylius:install --env=prod -n --fixture-suite=default
echo "y"|sylius-standard/bin/console sylius:install:sample-data --env=prod

export NODEJS_VERSION=18
npm install yarn

cd sylius-standard
~/node_modules/yarn/bin/yarn install
~/node_modules/yarn/bin/yarn build
cd

# Nettoyage
rm -rf .config .local .subversion .cache node_modules .npm package.json package-lock.json .yarn .yarnrc .cache
shopt -s dotglob
mv sylius-standard/* .
rmdir sylius-standard

# default credentials: sylius / sylius
