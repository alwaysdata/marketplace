#!/bin/bash

# Declare site in YAML, as documented on the documentation: https://help.alwaysdata.com/en/marketplace/build-application-script/
# site:
#     type: nodejs
#     nodejs_version: '18.5.0'
#     working_directory: '{INSTALL_PATH}'
#     command: 'node app.js'
#     environment: 'NODE_ENV=production'
# requirements:
#     disk: 850

set -e

git clone https://github.com/joemccann/dillinger.git .
npm install --omit=dev
