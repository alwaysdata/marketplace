#!/bin/bash

# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}'
#     php_version: '8'

set -e

curl -L -O https://github.com/datenstrom/yellow/archive/master.zip
unzip master.zip

rm master.zip
shopt -s dotglob nullglob
mv yellow-master/* .
rmdir yellow-master
