#!/bin/bash

# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}'
#     php_version: '8'
#     php_ini: extension=intl.so
# database:
#     type: postgresql

set -e

# https://git.tt-rss.org/fox/tt-rss/wiki/InstallationNotes

git clone https://tt-rss.org/git/tt-rss.git .

cat << EOF > config.php

<?php

putenv('TTRSS_DB_TYPE=pgsql');
putenv('TTRSS_DB_HOST=$DATABASE_HOST');
putenv('TTRSS_DB_USER=$DATABASE_USERNAME');
putenv('TTRSS_DB_NAME=$DATABASE_NAME');
putenv('TTRSS_DB_PASS=$DATABASE_PASSWORD');
putenv('TTRSS_DB_PORT=5432');
putenv('TTRSS_SELF_URL_PATH=http://$INSTALL_URL');

EOF

echo "yes" | php update.php --update-schema
