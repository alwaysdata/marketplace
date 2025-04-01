#!/bin/bash

# Declare site in YAML, as documented on the documentation: https://help.alwaysdata.com/en/marketplace/build-application-script/
# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}'
#     php_version: '8.3'
# database:
#     type: mysql
# requirements:
#     disk: 60
# form:
#     language:
#         type: choices
#         label:
#             en: Language
#             fr: Langue
#         choices:
#             de: Deutsch
#             en: English
#             es: Español
#             fr: Français
#             it: Italiano
#     site_name:
#         label:
#             en: Site name
#             fr: Nom du site
#         max_length: 255
#     email:
#         type: email
#         label:
#             en: Email
#             fr: Email
#         max_length: 255
#     admin_username:
#         label:
#             en: Administrator username
#             fr: Nom d'utilisateur de l'administrateur
#         regex: ^[ a-zA-Z0-9.+_-]+$
#         regex_text:
#             en: "It can include uppercase, lowercase, numbers, spaces, and special characters: .+_-."
#             fr: "Il peut comporter des majuscules, des minuscules, des chiffres, des espaces et les caractères spéciaux : .+_-."
#         max_length: 255
#     admin_password:
#         type: password
#         label:
#             en: Administrator password
#             fr: Mot de passe de l'administrateur
#         min_length: 5
#         max_length: 255

set -e

# https://docs.backdropcms.org/documentation/system-requirements
# https://github.com/backdrop-contrib/bee/wiki/Usage

wget --no-hsts https://github.com/backdrop-contrib/bee/releases/download/1.x-1.1.0/bee.phar
php bee.phar download-core
php bee.phar install --db-name=$DATABASE_NAME --db-user=$DATABASE_USERNAME --db-pass=$DATABASE_PASSWORD --db-host=$DATABASE_HOST --username=$FORM_ADMIN_USERNAME --password=$FORM_ADMIN_PASSWORD --email=$FORM_EMAIL --site-mail=$USER@$RESELLER_DOMAIN --langcode=$FORM_LANGUAGE --site-name=$FORM_SITE_NAME --auto
