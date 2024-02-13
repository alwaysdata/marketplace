#!/bin/bash

# Declare site in YAML, as documented on the documentation: https://help.alwaysdata.com/en/marketplace/build-application-script/
# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}/nextcloud'
#     php_version: '8.2'
#     php_ini: |
#         extension=intl.so
#         extension=gmp.so
#         extension={INSTALL_PATH}/imagick-8.2.so
#         memory_limit=512M
# database:
#     type: mysql
# requirements:
#     disk: 550
# form:
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

set -e

# https://docs.nextcloud.com/server/latest/admin_manual/installation/system_requirements.html

ad_install_pecl imagick

# Download
wget -O- --no-hsts https://download.nextcloud.com/server/releases/latest.zip | bsdtar --strip-components=0 -xf -

cd nextcloud

# Install
# CLI: https://docs.nextcloud.com/server/latest/admin_manual/configuration_server/occ_command.html?highlight=occ#command-line-installation-label
php occ maintenance:install --database="mysql" --database-host="$DATABASE_HOST" --database-name="$DATABASE_NAME" --database-user="$DATABASE_USERNAME" --database-pass="$DATABASE_PASSWORD" --admin-user="$FORM_ADMIN_USERNAME" --admin-pass="$FORM_ADMIN_PASSWORD"
php occ config:system:set trusted_domains 0 --value="$INSTALL_URL_HOSTNAME"
php occ config:system:set overwrite.cli.url --value="http://$INSTALL_URL"

# WAF specific profile: https://help.alwaysdata.com/en/sites/waf/#available-profiles
