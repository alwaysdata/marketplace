#!/bin/bash

# Declare site in YAML, as documented on the documentation: https://help.alwaysdata.com/en/marketplace/build-application-script/
# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}'
#     php_version: '8.3'
#     php_ini: |
#         extension=mcrypt.so
#     ssl_force: true
# requirements:
#     disk: 5

set -e

wget -O- --no-hsts https://github.com/PrivateBin/PrivateBin/archive/refs/tags/2.0.3.tar.gz | tar -xz --strip-components=1
