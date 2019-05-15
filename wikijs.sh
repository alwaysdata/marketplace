#!/bin/bash

# site:
#     type: nodejs
#     working_directory: '{INSTALL_PATH}'
#     command: 'node server/index.js'
#     environment: 'WIKI_JS_HEROKU=true WIKI_ADMIN_EMAIL={FORM_EMAIL}'
#     nodejs_version: '11'
# database:
#     type: mongodb
# form:
#     language:
#         type: choices
#         label: Language
#         initial: en
#         choices:
#             en: English
#             es: Spanish
#             fr: French
#     email:
#         type: email
#         label: Admin email
#     title:
#         label: Wiki title
#         max_length: 255
#         regex: ^[ a-zA-Z0-9!"#$%&()*+,./:;<=>?@\^_`{|}~-]+$

set -e

# https://docs.requarks.io/wiki/install/installation

curl -sSo- https://wiki.js.org/install.sh | bash
    
cat << EOF > config.yml
# https://docs-legacy.requarks.io/wiki/install/configuration
# GENERAL
title: $FORM_TITLE
host: $IP:$PORT
port: $PORT
paths.repo: ./repo
paths.data: ./data
lang: $FORM_LANGUAGE

# AUTHENTIFICATION
public: false
auth.local.enabled: true
defaultReadAccess: false
sessionSecret: $(dd if=/dev/urandom bs=32 count=1 2>/dev/null | sha256sum -b | sed 's/ .*//')

# DATABASE
db: mongodb://$DATABASE_USERNAME:$DATABASE_PASSWORD@$DATABASE_HOST:27017/$DATABASE_NAME

# GIT REPOSITORY
git: false
EOF
