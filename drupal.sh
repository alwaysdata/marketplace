#!/bin/bash

# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}/web'
#     php_version: '8.0'
# database:
#     type: mysql
# requirements:
#     disk: 140
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
#     admin_username:
#         label:
#             en: Administrator username
#             fr: Nom d'utilisateur de l'administrateur
#         regex: ^[ a-zA-Z0-9.@_-]+$
#         min_length: 5
#         max_length: 255
#     admin_password:
#         type: password
#         label:
#             en: Administrator password
#             fr: Mot de passe de l'administrateur
#         min_length: 5
#         max_length: 255

set -e

# https://www.drupal.org/docs/system-requirements

COMPOSER_CACHE_DIR=/dev/null composer2 require drush/drush 10
COMPOSER_CACHE_DIR=/dev/null composer2 create-project drupal/recommended-project

# https://drushcommands.com
echo "y" | php vendor/drush/drush/drush.php si --db-url=mysql://"$DATABASE_USERNAME":"$DATABASE_PASSWORD"@"$DATABASE_HOST"/"$DATABASE_NAME" --account-name="$FORM_ADMIN_USERNAME" --account-pass="$FORM_ADMIN_PASSWORD" --account-mail="$FORM_EMAIL" --site-name="$FORM_SITE_NAME" --locale="$FORM_LANGUAGE" --root=recommended-project

if [ "$INSTALL_URL_PATH" != "/" ]
then
    sed -i "s|# RewriteBase /$|RewriteBase $INSTALL_URL_PATH|" recommended-project/web/.htaccess
fi

rm -rf .composer .drush .subversion vendor composer.json composer.lock

shopt -s dotglob
mv recommended-project/* .
rmdir recommended-project
