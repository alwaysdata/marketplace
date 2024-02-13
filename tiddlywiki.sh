#!/bin/bash

# Declare site in YAML, as documented on the documentation: https://help.alwaysdata.com/en/marketplace/build-application-script/
# site:
#     type: nodejs
#     working_directory: '{INSTALL_PATH}'
#     nodejs_version: '20'
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

# https://tiddlywiki.com/static/Installing%2520TiddlyWiki%2520on%2520Node.js.html

npm install tiddlywiki

node_modules/.bin/tiddlywiki default --init server

# Create admin user
cat << EOF > users.csv
username,password
$FORM_USERNAME,$FORM_PASSWORD
EOF

# Handle subdirectories base URL
if [ "$INSTALL_URL_PATH" != "/" ]
then
  mkdir tiddlers
  cat << EOF > tiddlers/\$__config_tiddlyweb_host.tid
title: $:/config/tiddlyweb/host

\$protocol\$//\$host\$$INSTALL_URL_PATH/
EOF
fi

# Clean install environment
shopt -s dotglob
mv default/* .
rmdir default
