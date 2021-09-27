#!/bin/bash

# site:
#     type: nodejs
#     nodejs_version: '16'
#     working_directory: '{INSTALL_PATH}'
#     command: 'node app.js'
#     environment: 'NODE_ENV=production'

set -e

git clone https://github.com/joemccann/dillinger.git .
echo y | npm install --production