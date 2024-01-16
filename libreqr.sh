#!/bin/bash

# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}'
#     php_version: '8.3'
# requirements:
#     disk: 25

set -e

wget -O- --no-hsts https://code.antopie.org/miraty/libreqr/archive/2.0.1.zip | bsdtar --strip-components=1 -xf -
