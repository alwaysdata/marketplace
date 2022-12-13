#!/bin/bash

# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}'
#     php_version: '8.2'
#     php_ini: |
#         extension=mcrypt.so
#         extension=sodium.so
#     ssl_force: true
# requirements:
#     disk: 5

set -e

wget -O- https://github.com/PrivateBin/PrivateBin/archive/refs/tags/1.5.0.tar.gz | tar -xz --strip-components=1
