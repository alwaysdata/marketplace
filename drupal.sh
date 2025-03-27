#!/bin/bash

# Declare site in YAML, as documented on the documentation: https://help.alwaysdata.com/en/marketplace/build-application-script/
# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}/web'
#     php_version: '8.3'
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
#         max_length: 255
#     admin_username:
#         label:
#             en: Administrator username
#             fr: Nom d'utilisateur de l'administrateur
#         regex: ^[ a-zA-Z0-9.@_-]+$
#         regex_text:
#             en: "It must include at least 5 characters which can be uppercase, lowercase, numbers, spaces, and special characters: .@_-."
#             fr: "Il doit comporter au moins 5 caractères qui peuvent être des majuscules, des minuscules, des chiffres, des espaces et les caractères spéciaux : .@_-."
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

# Download & install dependancies
COMPOSER_CACHE_DIR=/dev/null composer2 create-project drupal/recommended-project

cd recommended-project

sed -i "/\"require\": {/a \ \ \ \ \ \ \ \ \"drush/drush\": \"^12.1\"," composer.json

COMPOSER_CACHE_DIR=/dev/null composer2 update

# Install
# CLI: https://drushcommands.com
echo "y" | php vendor/drush/drush/drush.php si --db-url=mysql://"$DATABASE_USERNAME":"$DATABASE_PASSWORD"@"$DATABASE_HOST"/"$DATABASE_NAME" --account-name="$FORM_ADMIN_USERNAME" --account-pass="$FORM_ADMIN_PASSWORD" --account-mail="$FORM_EMAIL" --site-name="$FORM_SITE_NAME" --locale="$FORM_LANGUAGE"

# Handle subdirectories base URL
if [ "$INSTALL_URL_PATH" != "/" ]
then
    sed -i "s|# RewriteBase /$|RewriteBase $INSTALL_URL_PATH|" web/.htaccess
fi

# Clean install environment
cd
rm -rf .config .local .subversion
shopt -s dotglob
mv recommended-project/* .
rmdir recommended-project

# WAF specific profile: https://help.alwaysdata.com/en/sites/waf/#available-profiles
