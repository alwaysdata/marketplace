#!/bin/bash

# site:
#     type: user_program
#     working_directory: '{INSTALL_PATH}'
#     command: '~{INSTALL_PATH_RELATIVE}/gitea web'
#     path_trim: true
#     ssl_force: true
# database:
#     type: postgresql
# requirements:
#     disk: 115

set -e

# https://docs.gitea.io/en-us/install-from-binary/

wget -O gitea https://github.com/go-gitea/gitea/releases/download/v1.17.2/gitea-1.17.2-linux-amd64
chmod +x gitea

mkdir -p custom/conf data indexers public log

cat << EOF > custom/conf/app.ini
   
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
