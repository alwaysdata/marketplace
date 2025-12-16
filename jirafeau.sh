#!/bin/bash

# Declare site in YAML, as documented on the documentation: https://help.alwaysdata.com/en/marketplace/build-application-script/
# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}'
#     php_version: '8.5'
# requirements:
#     disk: 5
# form:
#     language:
#         type: choices
#         label:
#             en: Language
#             fr: Langue
#         choices:
#             en: English
#             fr: Français
#     admin_password:
#         type: password
#         label:
#             en: Administrator password
#             fr: Mot de passe administrateur
#         min_length: 5
#         max_length: 255

set -e

# Download

wget -O- --no-hsts https://gitlab.com/jirafeau/Jirafeau/-/archive/4.7.0/Jirafeau-4.7.0.tar.gz | tar -xz --strip-components=1

# Configuration
cp lib/config.original.php lib/config.local.php

mkdir -p data/{files,links,async}

cat << EOF > lib/config.local.php
<?php
\$cfg = array (
  'web_root' => '$INSTALL_URL',
  'var_root' => '$INSTALL_PATH/data/',
  'lang' => '$FORM_LANGUAGE',
  'style' => 'dark-courgette',
  'organisation' => 'ACME',
  'contactperson' => '',
  'title' => '',
  'preview' => true,
  'enable_crypt' => false,
  'link_name_length' => 8,
  'upload_password' => 
  array (
  ),
  'upload_ip' => 
  array (
  ),
  'upload_ip_nopassword' => 
  array (
  ),
  'admin_password' => '$(echo -n $FORM_ADMIN_PASSWORD|sha256sum|sed 's/ .*//')',
  'admin_http_auth_user' => '',
  'availabilities' => 
  array (
    'minute' => true,
    'hour' => true,
    'day' => true,
    'week' => true,
    'month' => true,
    'quarter' => false,
    'year' => false,
    'none' => false,
  ),
  'availability_default' => 'month',
  'one_time_download' => true,
  'maximal_upload_size' => 0,
  'proxy_ip' => 
  array (
  ),
  'file_hash' => 'md5',
  'litespeed_workaround' => false,
  'store_uploader_ip' => true,
  'installation_done' => true,
  'debug' => false,
);
EOF
