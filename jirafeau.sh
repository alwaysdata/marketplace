#!/bin/bash

# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}'
#     php_version: '8.2'
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

COMPOSER_CACHE_DIR=/dev/null composer2 create-project mojo42/jirafeau

cp jirafeau/lib/config.original.php jirafeau/lib/config.local.php

mkdir -p jirafeau/data/{files,links,async}

cat << EOF > jirafeau/lib/config.local.php
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

rm -rf .config .local .subversion
shopt -s dotglob
mv jirafeau/* .
rmdir jirafeau
