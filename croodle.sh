#!/bin/bash

# Declare site in YAML, as documented on the documentation: https://help.alwaysdata.com/en/marketplace/build-application-script/
# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}'
#     php_version: '8.3'
# requirements:
#     disk: 160
set -e

wget -O- --no-hsts https://github.com/jelhan/croodle/releases/download/v0.7.0/croodle-v0.7.0.tar.gz | tar -xz --strip-components=0
