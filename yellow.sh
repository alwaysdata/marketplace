#!/bin/bash

# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}'
#     php_version: '8.3'
# requirements:
#     disk: 5

set -e

wget -O- https://github.com/datenstrom/yellow/archive/main.zip | bsdtar --strip-components=1 -xf -

rm .wget-hsts
