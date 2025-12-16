#!/bin/bash

# Declare site in YAML, as documented on the documentation: https://help.alwaysdata.com/en/marketplace/build-application-script/
# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}'
#     php_version: '8.5'
# requirements:
#     disk: 10

set -e

# https://docs.bludit.com/en/getting-started/requirements

wget -O- --no-hsts https://github.com/bludit/bludit/archive/refs/tags/3.16.2.zip | bsdtar --strip-components=1 -xf -


if [ "$INSTALL_URL_PATH" != "/" ]
then
    sed -i "s|# RewriteBase /$|RewriteBase $INSTALL_URL_PATH|" .htaccess
fi
