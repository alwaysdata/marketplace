#!/bin/bash

# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}'
#     php_version: '8'

set -e

wget https://www.bludit.com/releases/bludit-3-13-1.zip

unzip bludit-3-13-1.zip
shopt -s dotglob nullglob
mv bludit-3-13-1/* .
rm -rf bludit-3-13-1*

if [ "$INSTALL_URL_PATH" != "/" ]
then
    sed -i "s|# RewriteBase /$|RewriteBase $INSTALL_URL_PATH|" .htaccess
fi

# After is GUI (langage & admin credentials)
