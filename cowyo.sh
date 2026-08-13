#!/bin/bash

# Declare site in YAML, as documented here: https://help.alwaysdata.com/en/docs/development/marketplace/build-application-script/
# site:
#     type: user_program
#     working_directory: '{INSTALL_PATH_RELATIVE}'
#     command: './cowyo -port=$PORT'
# requirements:
#     disk: 100

set -e 

wget -O- --no-hsts https://github.com/schollz/cowyo/archive/refs/tags/v3.0.1.tar.gz|tar -xz --strip-components=0
cd cowyo-3.0.1
make build

# Cleaning the directory
cd
chmod -R 755 go
rm -rf go .cache .config .npm
shopt -s dotglob
mv cowyo-3.0.1/* .
rmdir cowyo-3.0.1
