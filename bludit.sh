#!/bin/bash

# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}'
#     php_version: '8.0'
# requirements:
#     disk: 10

set -e

wget -O- https://www.bludit.com/releases/bludit-3-13-1.zip | bsdtar --strip-components=1 -xf -

if [ "$INSTALL_URL_PATH" != "/" ]
then
    sed -i "s|# RewriteBase /$|RewriteBase $INSTALL_URL_PATH|" .htaccess
fi

# After is GUI (language & admin credentials)
