#!/bin/bash

# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}'
#     php_version: '8'
# requirements:
#     disk: 5

set -e

wget -O- https://github.com/datenstrom/yellow/archive/master.zip | bsdtar --strip-components=1 -xf -
