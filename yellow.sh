#!/bin/bash

# Declare site in YAML, as documented on the documentation: https://help.alwaysdata.com/en/marketplace/build-application-script/
# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}'
#     php_version: '8.3'
# requirements:
#     disk: 5

set -e

wget -O- --no-hsts https://github.com/datenstrom/yellow/archive/main.zip | bsdtar --strip-components=1 -xf -
