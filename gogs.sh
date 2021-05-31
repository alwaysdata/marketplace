#!/bin/bash

# site:
#     type: user_program
#     working_directory: '{INSTALL_PATH}'
#     command: '~{INSTALL_PATH_RELATIVE}/gogs web'
#     path_trim: true
# database:
#     type: postgresql

set -e

wget -O- https://github.com/gogs/gogs/releases/download/v0.12.3/gogs_0.12.3_linux_amd64.tar.gz|tar -xz --strip-components=1

mkdir -p custom/conf

cat << EOF > custom/conf/app.ini

RUN_MODE = prod
RUN_USER  = $USER
BRAND_NAME = Gogs

[server]
HTTP_PORT = $PORT
DOMAIN = 0.0.0.0
EXTERNAL_URL = http://$INSTALL_URL/
DISABLE_SSH = false
SSH_PORT = 22
START_SSH_SERVER = false
OFFLINE_MODE = false

[repository]
ROOT = $INSTALL_PATH/gogs-repositories

[database]
TYPE = postgres
HOST = $DATABASE_HOST:5432
NAME = $DATABASE_NAME
USER = $DATABASE_USERNAME
PASSWORD = $DATABASE_PASSWORD
SSL_MODE = disable
PATH = $INSTALL_PATH/data/gogs.db

[mailer]
ENABLED = false

[service]
REGISTER_EMAIL_CONFIRM = false
ENABLE_NOTIFY_MAIL = false
DISABLE_REGISTRATION = false
ENABLE_CAPTCHA = true
REQUIRE_SIGNIN_VIEW = false

[picture]
DISABLE_GRAVATAR = false
ENABLE_FEDERATED_AVATAR = false

[session]
PROVIDER = file

[log]
MODE      = file
LEVEL     = Info
ROOT_PATH = $INSTALL_PATH/log

[security]
INSTALL_LOCK = true
SECRET_KEY   = '$(date | sha256sum -b | sed 's/ .*//')'
EOF

