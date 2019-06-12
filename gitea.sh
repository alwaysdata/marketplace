#!/bin/bash

# site:
#     type: user_program
#     working_directory: '{INSTALL_PATH}'
#     command: '~{INSTALL_PATH_RELATIVE}/gitea web'
#     path_trim: true
# database:
#     type: postgresql

set -e

# https://docs.gitea.io/en-us/install-from-binary/

wget -qO gitea https://dl.gitea.io/gitea/1.8.2/gitea-1.8.2-linux-amd64
chmod +x gitea

mkdir -p custom/conf data indexers public log

cat << EOF > custom/conf/app.ini
   
RUN_MODE = prod
    
[server]
HTTP_ADDR = $IP
HTTP_PORT = $PORT
ROOT_URL = https://$INSTALL_URL
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
FROM = $USER@$RESELLER_DOMAIN

EOF
