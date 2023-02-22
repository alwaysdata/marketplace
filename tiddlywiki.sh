#!/bin/bash

# site:
#     type: nodejs
#     working_directory: '{INSTALL_PATH}'
#     nodejs_version: '18'
#     command: './node_modules/.bin/tiddlywiki ~{INSTALL_PATH_RELATIVE} --listen host="::" port=$PORT credentials=users.csv "readers=(authenticated)" "writers={FORM_USERNAME}"'
#     path_trim: true
#     ssl_force: true
# requirements:
#     disk: 50
# form:
#     username:
#         label:
#             en: Username
#             fr: Nom d'utilisateur
#         max_length: 255
#     password:
#         type: password
#         label:
#             en: Password
#             fr: Mot de passe
#         max_length: 255

set -e

npm install tiddlywiki

node_modules/.bin/tiddlywiki default --init server

cat << EOF > users.csv
username,password
$FORM_USERNAME,$FORM_PASSWORD
EOF

if [ "$INSTALL_URL_PATH" != "/" ]
then
  mkdir tiddlers
  cat << EOF > tiddlers/\$__config_tiddlyweb_host.tid
title: $:/config/tiddlyweb/host

\$protocol\$//\$host\$$INSTALL_URL_PATH/
EOF
fi

shopt -s dotglob
mv default/* .
rmdir default
