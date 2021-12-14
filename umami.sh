#!/bin/bash

# site:
#     type: nodejs
#     nodejs_version: '12'
#     working_directory: '{INSTALL_PATH}/umami'
#     command: 'npm run start-env'
#     environment: |
#         HOME='{INSTALL_PATH}'
# database:
#     type: mysql
# requirements:
#     disk: 1540

set -e

# https://umami.is/docs/install

git clone https://github.com/mikecao/umami.git
cd umami
npm install -f

mysql -h "$DATABASE_HOST" -u "$DATABASE_USERNAME" --password="$DATABASE_PASSWORD" $DATABASE_NAME < sql/schema.mysql.sql

cat << EOF > .env
DATABASE_URL=mysql://$DATABASE_USERNAME:$DATABASE_PASSWORD@$DATABASE_HOST:3306/$DATABASE_NAME
HASH_SALT='$(sha256sum -b | sed 's/ .*//')'
PORT=PORT
HOSTNAME="::"
EOF

if [ "$INSTALL_URL_PATH" != "/" ]
then
echo BASE_PATH="$INSTALL_URL_PATH" >> .env
fi

npm run build -f

# default credentials: admin / umami
