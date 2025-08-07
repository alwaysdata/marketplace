#!/bin/bash

# Declare site in YAML, as documented on the documentation: https://help.alwaysdata.com/en/marketplace/build-application-script/
# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}/dist'
#     php_version: '8.3'
# requirements:
#     disk: 20

set -e

# https://docs.filegator.io/install.html
wget -O- --no-hsts  https://github.com/filegator/static/raw/master/builds/filegator_latest.zip | bsdtar --strip-components=1 -xf -

# Default credentials for first login: admin/admin123
