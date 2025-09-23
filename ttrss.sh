#!/bin/bash

# Declare site in YAML, as documented on the documentation: https://help.alwaysdata.com/en/marketplace/build-application-script/
# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}'
#     php_version: '8.3'
#     ssl_force: true
# database:
#     type: postgresql
# requirements:
#     disk: 80

set -e

# https://tt-rss.org/wiki/InstallationNotes

# Download
git clone https://gitlab.tt-rss.org/tt-rss/tt-rss.git  . --depth 1

# Configuration
cat << EOF > config.php

<?php

putenv('TTRSS_DB_TYPE=pgsql');
putenv('TTRSS_DB_HOST=$DATABASE_HOST');
putenv('TTRSS_DB_USER=$DATABASE_USERNAME');
putenv('TTRSS_DB_NAME=$DATABASE_NAME');
putenv('TTRSS_DB_PASS=$DATABASE_PASSWORD');
putenv('TTRSS_DB_PORT=5432');
putenv('TTRSS_SELF_URL_PATH=https://$INSTALL_URL');

EOF

echo "yes" | php update.php --update-schema

# Default credentials for first login: admin / password
