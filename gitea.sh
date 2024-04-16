#!/bin/bash

# Declare site in YAML, as documented on the documentation: https://help.alwaysdata.com/en/marketplace/build-application-script/
# site:
#     type: user_program
#     working_directory: '{INSTALL_PATH}'
#     command: './gitea web'
#     path_trim: true
#     ssl_force: true
# database:
#     type: postgresql
# requirements:
#     disk: 115

set -e

# https://docs.gitea.io/en-us/install-from-binary/

# Download
wget  --no-hsts -O gitea https://github.com/go-gitea/gitea/releases/download/v1.21.10/gitea-1.21.10-linux-amd64
chmod +x gitea

# Configuration
mkdir -p custom/conf data indexers public log

cat << EOF > custom/conf/app.ini
# More options https://docs.gitea.io/en-us/config-cheat-sheet/
   
RUN_MODE = prod
    
[server]
HTTP_ADDR = 0.0.0.0
HTTP_PORT = $PORT
ROOT_URL = https://$INSTALL_URL/
LOCAL_ROOT_URL = https://$INSTALL_URL/
ENABLE_GZIP = true

[database]
DB_TYPE  = postgres
HOST     = $DATABASE_HOST:5432
NAME     = $DATABASE_NAME
USER     = $DATABASE_USERNAME
PASSWD   = \`$DATABASE_PASSWORD\`

[security]
INSTALL_LOCK = true

[mailer]
ENABLED = true
USE_SENDMAIL = true
SENDMAIL_PATH = /usr/sbin/sendmail
FROM = $USER@$RESELLER_DOMAIN
EOF

# This install does not create a Gitea admin user. The first registered user will have admin permissions and will be able to manage the instance.
