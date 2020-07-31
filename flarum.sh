#!/bin/bash

# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}/public'
#     php_version: '7.4'
#     ssl_force: true
# database:
#     type: mysql
# form:
#     title:
#         label: Forum title
#         max_length: 255
#     email:
#         type: email
#         label: Email
#     admin_username:
#         label: Administrator username
#         regex: ^[a-zA-Z0-9_-]+$
#         max_length: 255
#     admin_password:
#         type: password
#         label: Administrator password
#         regex: ^[a-zA-Z0-9!#$€%&'[]()*+,./:;<=>?@^_`{|}~-]+$
#         max_length: 255
#         min_length: 8

set -e

composer create-project flarum/flarum default --stability=beta

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

shopt -s dotglob nullglob
mv default/* .
rmdir default
