#!/bin/bash

# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}'
#     php_version: '8.3'
# requirements:
#     disk: 160
set -e

wget -O- https://github.com/jelhan/croodle/releases/download/v0.7.0/croodle-v0.7.0.tar.gz | tar -xz --strip-components=0
