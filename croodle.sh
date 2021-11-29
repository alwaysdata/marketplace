#!/bin/bash

# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}'
#     php_version: '8.0'
# requirements:
#     disk: 160
set -e

wget -O- https://github.com/jelhan/croodle/releases/download/v0.6.2/croodle-v0.6.2.tar.gz | tar -xz --strip-components=0
