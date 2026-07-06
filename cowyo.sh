#!/bin/bash

# Declare site in YAML, as documented here: https://help.alwaysdata.com/en/docs/development/marketplace/build-application-script/
# site:
#     type: user_program
#     working_directory: '{INSTALL_PATH_RELATIVE}'
#     command: './cowyo --port $PORT --host "[::]"'
# requirements:
#     disk: 20

set -e 

wget --no-hsts -qO cowyo https://github.com/schollz/cowyo/releases/download/v2.12.0/cowyo_linux_amd64
chmod +x cowyo
