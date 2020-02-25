#!/bin/bash

# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}/public/'
#     php_version: '7.4'

set -e

# https://symfony.com/doc/current/setup.html
composer create-project symfony/website-skeleton default

rm -rf .composer

shopt -s dotglob nullglob
mv default/* .
rmdir default
