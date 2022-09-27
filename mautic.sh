#!/bin/bash

# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}'
#     php_version: '8.0'
#     php_ini: |
#         memory_limit = 4096M
#         extension = imap.so
#         extension = intl.so
#         zend.assertions = -1
#     ssl_force: true
# database:
#     type: mysql
# requirements:
#     disk: 300
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
#         min_length: 6
#         max_length: 255

set -e

wget -O- https://github.com/mautic/mautic/releases/download/4.4.3/4.4.3.zip | bsdtar --strip-components=0 -xf -

php bin/console mautic:install --db_driver="pdo_mysql" --db_host="$DATABASE_HOST" --db_port="3306" --db_name="$DATABASE_NAME" --db_user="$DATABASE_USERNAME" --db_password="$DATABASE_PASSWORD" --admin_username="$FORM_ADMIN_USERNAME" --admin_email="$FORM_EMAIL" --admin_password="$FORM_ADMIN_PASSWORD" --mailer_from_email="$USER@$RESELLER_DOMAIN" --mailer_from_name="Mautic" https://$INSTALL_URL

rm .wget-hsts
