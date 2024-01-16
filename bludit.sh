#!/bin/bash

# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}'
#     php_version: '8.3'
# requirements:
#     disk: 10

set -e

wget -O- --no-hsts https://github.com/bludit/bludit/archive/refs/tags/3.15.0.zip | bsdtar --strip-components=1 -xf -


if [ "$INSTALL_URL_PATH" != "/" ]
then
    sed -i "s|# RewriteBase /$|RewriteBase $INSTALL_URL_PATH|" .htaccess
fi
# After is GUI (language & admin credentials)
