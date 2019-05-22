#!/bin/bash

# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}'
#     php_version: '7.3'
#     php_ini: extension=intl.so
# database:
#     type: postgresql

set -e

# https://git.tt-rss.org/fox/tt-rss/wiki/InstallationNotes

git clone https://tt-rss.org/git/tt-rss.git .

curl -sL -o /dev/null \
        --data "op=installschema" \
        --data "DB_USER=$DATABASE_USERNAME" \
        --data "DB_PASS=$DATABASE_PASSWORD" \
        --data "DB_NAME=$DATABASE_NAME" \
        --data "DB_HOST=$DATABASE_HOST" \
        --data "DB_PORT=5432" \
        --data "DB_TYPE=pgsql" \
        --data "SELF_URL_PATH=http://$INSTALL_URL/" \
        http://$INSTALL_URL/install/

curl -sL -o /dev/null \
        --data "op=saveconfig" \
        --data "DB_USER=$DATABASE_USERNAME" \
        --data "DB_PASS=$DATABASE_PASSWORD" \
        --data "DB_NAME=$DATABASE_NAME" \
        --data "DB_HOST=$DATABASE_HOST" \
        --data "DB_PORT=5432" \
        --data "DB_TYPE=pgsql" \
        --data "SELF_URL_PATH=http://$INSTALL_URL/" \
        http://$INSTALL_URL/install/
