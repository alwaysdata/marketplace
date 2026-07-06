#!/bin/bash

# Declare site in YAML, as documented here: https://help.alwaysdata.com/en/docs/development/marketplace/build-application-script/
# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}'
#     php_version: '8.5'
#     php_ini: |
#         extension=mcrypt.so
#     ssl_force: true
# requirements:
#     disk: 5

set -e

wget -O- --no-hsts https://github.com/PrivateBin/PrivateBin/archive/refs/tags/2.0.4.tar.gz | tar -xz --strip-components=1
