#!/bin/bash

# site:
#     type: php
#     path: '{installation_directory}'
#     php_version: '7.2'
# database:
#     type: mysql
# form:
#     language:
#         type: choices
#         label: Language
#         initial: en
#         choices:
#             en: English
#             fr: French
#     admin_username:
#         label: Administrator username
#         regex: ^[ a-zA-Z0-9.@_-]+$
#         max_length: 255
#     admin_password:
#         type: password
#         label: Administrator password
#         max_length: 255
#     admin_email:
#         type: email
#         label: Administrator email address

cat << EOF > .htaccess
<Directory $INSTALL_PATH>
    AllowOverride None
    Order Allow,Deny
    Allow from All

    <IfModule mod_rewrite.c>
        Options -MultiViews
        RewriteEngine On
        RewriteCond %{REQUEST_FILENAME} !-f
        RewriteRule ^(.*)$ app.php [QSA,L]
    </IfModule>
</Directory>
EOF

wget -qO- https://wllbg.org/latest-v2-package | tar -xz --strip-components=1

CONFIGURATION_FILE="app/config/parameters.yml"
sed -i "s|database_host: 127.0.0.1|database_host: $DATABASE_HOST|" $CONFIGURATION_FILE
sed -i "s|database_name: wallabag|database_name: $DATABASE_NAME|" $CONFIGURATION_FILE
sed -i "s|database_user: root|database_user: $DATABASE_USERNAME|" $CONFIGURATION_FILE
sed -i "s|database_password: null|database_password: $DATABASE_PASSWORD|" $CONFIGURATION_FILE
sed -i "s|your-wallabag-url-instance.com|$INSTALL_URL|" $CONFIGURATION_FILE
sed -i "s|locale: en|locale: $FORM_LANGUAGE|" $CONFIGURATION_FILE

bin/console cache:clear -e=prod
bin/console wallabag:install -e=prod -n
bin/console fos:user:create -e=prod "$FORM_ADMIN_USERNAME" "$FORM_ADMIN_EMAIL" "$FORM_ADMIN_PASSWORD"
