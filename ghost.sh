#!/bin/bash

# site:
#     type: nodejs
#     nodejs_version: '18'
#     working_directory: '{INSTALL_PATH}/website'
#     command: 'node current/index.js'
#     ssl_force: true
#     environment: |
#         NODE_ENV=production
#         HOME='{INSTALL_PATH}'
# database:
#     type: mysql
# requirements:
#     disk: 1300


# https://ghost.org/docs/faq/node-versions/
# https://ghost.org/docs/install/local/
# https://ghost.org/docs/config/

npm install ghost-cli@latest

node_modules/ghost-cli/bin/ghost install local -d website

cat << EOF > website/config.production.json
{
  "url": "https://$INSTALL_URL/",
  "server": {
    "port": $PORT,
    "host": "::"
  },
  "database": {
    "client": "mysql",
    "connection": {
    "host": "$DATABASE_HOST",
    "port": 3306,
    "user": "$DATABASE_USERNAME",
    "password": "$DATABASE_PASSWORD",
    "database": "$DATABASE_NAME"
    }
  },
  "mail": {
    "transport": "Direct",
    "from": "$USER@$RESELLER_DOMAIN"
  },
  "logging": {
    "level": "error",
    "transports": [
      "stdout"
    ]
  },
  "paths": {
    "contentPath": "$INSTALL_PATH/website/content"
  }
}
EOF
