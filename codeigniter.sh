#!/bin/bash

# Declare site in YAML, as documented on the documentation: https://help.alwaysdata.com/en/marketplace/build-application-script/
# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}/public'
#     php_version: '8.5'
# requirements:
#     disk: 30

set -e

# https://codeigniter.com/user_guide/installation/
# https://codeigniter.com/user_guide/intro/requirements.html

 COMPOSER_CACHE_DIR=/dev/null composer2 create-project codeigniter4/appstarter default
 
 # Clean install environment
rm -rf .config .local .subversion
shopt -s dotglob
mv default/* .
rmdir default
