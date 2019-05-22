#!/bin/bash

# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}'
#     php_version: '7.3'
#     php_ini: extension=intl.so
# database:
#     type: postgresql
# form:
#     admin_username:
#         label: Administrator username
#         max_length: 255
#     admin_password:
#         type: password
#         label: Administrator password
#         max_length: 255

set -e

# https://git.tt-rss.org/fox/tt-rss/wiki/InstallationNotes

git clone https://tt-rss.org/git/tt-rss.git .
rm -rf install

export PGPASSWORD=$DATABASE_PASSWORD

psql -h $DATABASE_HOST -p 5432 -U $DATABASE_USERNAME -d $DATABASE_NAME \
        -f schema/ttrss_schema_pgsql.sql

cat << EOF > config.php
<?php
        define('DB_TYPE', 'pgsql');
        define('DB_HOST', '$DATABASE_HOST');
        define('DB_USER', '$DATABASE_USERNAME');
        define('DB_PASS', '$DATABASE_PASSWORD');
        define('DB_NAME', '$DATABASE_NAME');
        define('DB_PORT', '5432');
        define('MYSQL_CHARSET', NULL);

        define('SELF_URL_PATH', 'http://$INSTALL_URL/');

        define('SINGLE_USER_MODE', false);
        define('SIMPLE_UPDATE_MODE', false);

        define('PHP_EXECUTABLE', '/usr/bin/php');
        define('LOCK_DIRECTORY', 'lock');
        define('CACHE_DIR', 'cache');
        define('ICONS_DIR', "feed-icons");
        define('ICONS_URL', "feed-icons");

        define('AUTH_AUTO_CREATE', true);
        define('AUTH_AUTO_LOGIN', true);

        define('FORCE_ARTICLE_PURGE', 0);

        define('SPHINX_SERVER', NULL);
        define('SPHINX_INDEX', NULL);

        define('ENABLE_REGISTRATION', false);
        define('REG_NOTIFY_ADDRESS', '$USER@$RESELLER_DOMAIN');
        define('REG_MAX_USERS', 0);

        define('SESSION_COOKIE_LIFETIME', 86400);

        define('SMTP_FROM_NAME', 'Tiny Tiny RSS');
        define('SMTP_FROM_ADDRESS', '$USER@$RESELLER_DOMAIN');
        define('DIGEST_SUBJECT', '[tt-rss] New headlines for last 24 hours');

        define('CHECK_FOR_UPDATES', true);
        define('ENABLE_GZIP_OUTPUT', true);
        define('PLUGINS', 'auth_internal, note');
        define('LOG_DESTINATION', 'sql');

        define('CONFIG_VERSION', 26);
EOF

SALT=$(for i in {1..25}; do head /dev/urandom | tr -dc a-f0-9 | cut -c -10; done | tr -d '\n')
HASH=$(echo -n $SALT$FORM_ADMIN_PASSWORD | sha256sum | cut -d ' ' -f1)

psql -h $DATABASE_HOST -p 5432 -U $DATABASE_USERNAME -d $DATABASE_NAME \
        -c "update ttrss_users set login = '$FORM_ADMIN_USERNAME', email = '$USER@$RESELLER_DOMAIN', pwd_hash = 'MODE2:$HASH', salt = '$SALT' where id = 1;"
