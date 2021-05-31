#!/bin/bash

# site:
#     type: user_program
#     working_directory: '{INSTALL_PATH}'
#     command: '~{INSTALL_PATH_RELATIVE}/cowyo --port $PORT --host "[::]"'

set -e 

# https://github.com/schollz/cowyo

wget -qO cowyo https://github.com/schollz/cowyo/releases/download/v2.12.0/cowyo_linux_amd64
chmod +x cowyo
