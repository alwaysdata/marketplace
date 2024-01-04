#!/bin/bash

# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}/public'
#     php_version: '8.3'
#     ssl_force: true
# database:
#     type: mysql
# requirements:
#     disk: 75
# form:
#     title:
#         label:
#             en: Forum title
#             fr: Titre du forum
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
#         regex: ^[a-zA-Z0-9_-]+$
#         max_length: 255
#     admin_password:
#         type: password
#         label:
#             en: Administrator password
#             fr: Mot de passe de l'administrateur
#         regex: ^[a-zA-Z0-9!#$€%&'\[\]()*+,./:;<=>?@^_`{|}~-]+$
#         max_length: 255
#         min_length: 8

set -e

# https://docs.flarum.org/install.html#server-requirements

COMPOSER_CACHE_DIR=/dev/null composer2 create-project flarum/flarum default

cat << EOF > config.yml
baseUrl : "https://$INSTALL_URL"
databaseConfiguration :
    host : "$DATABASE_HOST"
    database : "$DATABASE_NAME"
    username : "$DATABASE_USERNAME"
    password : "$DATABASE_PASSWORD"
adminUser : 
    username : "$FORM_ADMIN_USERNAME"
    password : "$FORM_ADMIN_PASSWORD"
    password_confirmation : "$FORM_ADMIN_PASSWORD"
    email : "$FORM_EMAIL"
settings : 
    forum_title : "$FORM_TITLE"
EOF

php default/flarum install -f config.yml

# https://flarum.org/docs/install.html#customizing-paths
if [ "$INSTALL_URL_PATH" != "/" ]
then
  sed -i 's|\ \ \#\ RewriteRule \/\\\.git \/ \[F,L\]|\ \ RewriteRule \/\\\.git \/ \[F,L\]|' default/public/.htaccess
    sed -i 's|\ \ \#\ RewriteRule \^auth\\\.json\$ \/ \[F,L\]|\ \ RewriteRule \^auth\\\.json\$ \/ \[F,L\]|' default/public/.htaccess
  sed -i 's|\ \ \#\ RewriteRule \^composer\\\.(lock\|json)\$ \/ \[F,L\]|\ \ RewriteRule \^composer\\\.(lock\|json)\$ \/ \[F,L\]|' default/public/.htaccess
  sed -i 's|\ \ \#\ RewriteRule \^config.php\$ \/ \[F,L\]|\ \ RewriteRule \^config.php\$ \/ \[F,L\]|' default/public/.htaccess
  sed -i 's|\ \ \#\ RewriteRule \^flarum\$ \/ \[F,L\]|\ \ RewriteRule \^flarum\$ \/ \[F,L\]|' default/public/.htaccess
  sed -i 's|\ \ \#\ RewriteRule \^storage\/(.*)?\$ \/ \[F,L\]|\ \ RewriteRule \^storage\/(.*)?\$ \/ \[F,L\]|' default/public/.htaccess
  sed -i 's|\ \ \#\ RewriteRule \^vendor\/(.*)?\$ \/ \[F,L\]|\ \ RewriteRule \^vendor\/(.*)?\$ \/ \[F,L\]|' default/public/.htaccess
fi

rm -rf .composer config.yml

shopt -s dotglob
mv default/* .
rmdir default
