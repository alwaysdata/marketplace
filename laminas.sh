#!/bin/bash

# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}/public/'
#     addresses: '{INSTALL_URL}/web'
#     php_version: '7.4'

set -e

# https://docs.laminas.dev/tutorials/getting-started/skeleton-application/

echo 'Y' | composer create-project -s dev laminas/laminas-mvc-skeleton default

shopt -s dotglob nullglob
mv default/* .
rmdir default

composer development-disable

rm -rf .composer .subversion
