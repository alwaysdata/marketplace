#!/bin/bash

# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}'
#     php_version: '7.4'

set -e

wget -O- https://code.antopie.org/miraty/libreqr/archive/1.3.0.zip | bsdtar --strip-components=1 -xf -
