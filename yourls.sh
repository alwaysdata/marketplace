#!/bin/bash

# Declare site in YAML, as documented on the documentation: https://help.alwaysdata.com/en/marketplace/build-application-script/
# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}'
#     php_version: '8.3'
# database:
#     type: mysql
# requirements:
#     disk: 10
# form:
#     admin_username:
#         label:
#             en: Administrator username
#             fr: Nom d'utilisateur de l'administrateur
#         regex: ^[ a-zA-Z0-9.@_-]+$
#         regex_text:
#             en: "It must include at least 5 characters, which can be uppercase, lowercase, numbers, spaces and special characters: .@_-."
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

# https://yourls.org/docs#requirements

# Download
wget -O- --no-hsts https://github.com/YOURLS/YOURLS/archive/refs/tags/1.10.1.tar.gz| tar -xz --strip-components=1

# Configuration
mv user/config-sample.php user/config.php

sed -i "s|'your db user name'|'$DATABASE_USERNAME'|" user/config.php
sed -i "s|'your db password'|'$DATABASE_PASSWORD'|" user/config.php
sed -i "s|'YOURLS_DB_NAME', 'yourls'|'YOURLS_DB_NAME', '$DATABASE_NAME'|" user/config.php
sed -i "s|'localhost'|'$DATABASE_HOST'|" user/config.php
sed -i "s|'http://your-own-domain-here.com'|'http://$INSTALL_URL'|" user/config.php
sed -i "s|'username' => 'password'|'$FORM_ADMIN_USERNAME' => '$FORM_ADMIN_PASSWORD'|" user/config.php

# Install
curl -X POST -F install="Install YOURLS" http://$INSTALL_URL/admin/install.php
curl https://$INSTALL_URL/admin/index.php?action=logout


# Handle Base URL with subdirectories
# https://yourls.org/docs/guide/server-configuration#make-a-htaccess-file
cat << EOF > .htaccess
# BEGIN YOURLS
<IfModule mod_rewrite.c>
RewriteEngine On
RewriteBase $INSTALL_URL_PATH
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule ^.*\$ $INSTALL_URL_PATH/yourls-loader.php [L]
</IfModule>
# END YOURLS
EOF

mv sample-public-front-page.txt index.php
