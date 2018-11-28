#!/bin/bash

# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}/public/'
#     php_version: '7.2'

set -e

# https://docs.zendframework.com/tutorials/getting-started/skeleton-application/

echo 'Y' | composer create-project zendframework/skeleton-application default

rm -rf .composer

shopt -s dotglob nullglob
mv default/* .
rmdir default
