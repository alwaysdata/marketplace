#!/bin/bash

#site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}'
#     php_version: '8'
     
set -e

wget -O- https://github.com/jelhan/croodle/releases/tag/v0.6.2 | tar -xz --strip-components=0
