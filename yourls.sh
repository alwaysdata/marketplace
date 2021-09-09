#!/bin/bash

# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}'
#     php_version: '8'
# database:
#     type: mysql
# form:
#     admin_username:
#         label: Administrator username
#         regex: ^[ a-zA-Z0-9.@_-]+$
#         min_length: 5
#         max_length: 255
#     admin_password:
#         type: password
#         label: Administrator password
#         min_length: 5
#         max_length: 255
set -e

wget -O- https://github.com/YOURLS/YOURLS/archive/refs/tags/1.8.2.tar.gz| tar -xz --strip-components=1

mv user/config-sample.php user/config.php

sed -i "s|'your db user name'|'$DATABASE_USERNAME'|" user/config.php
sed -i "s|'your db password'|'$DATABASE_PASSWORD'|" user/config.php
sed -i "s|'YOURLS_DB_NAME', 'yourls'|'YOURLS_DB_NAME', '$DATABASE_NAME'|" user/config.php
sed -i "s|'localhost'|'$DATABASE_HOST'|" user/config.php
sed -i "s|'http://your-own-domain-here.com'|'http://$INSTALL_URL'|" user/config.php
sed -i "s|'username' => 'password'|'$FORM_ADMIN_USERNAME' => '$FORM_ADMIN_PASSWORD'|" user/config.php

curl -X POST -F install="Install YOURLS" http://$INSTALL_URL/admin/install.php
curl https://$INSTALL_URL/admin/index.php?action=logout

# https://github.com/YOURLS/YOURLS/wiki/.htaccess
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
