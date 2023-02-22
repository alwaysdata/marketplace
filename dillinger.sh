#!/bin/bash

# site:
#     type: nodejs
#     nodejs_version: '16.17'
#     working_directory: '{INSTALL_PATH}'
#     command: 'node app.js'
#     environment: 'NODE_ENV=production'
# requirements:
#     disk: 850

set -e

git clone https://github.com/joemccann/dillinger.git .
npm install --omit=dev
