#!/bin/bash

# site:
#     type: php
#     path: '{INSTALL_PATH_RELATIVE}'
#     php_version: '7.4'
# database:
#     type: mysql
# form:
#     language:
#         type: choices
#         label: Language
#         initial: en
#         choices:
#             de: German
#             en: English
#             es: Spanish
#             fr: French
#             it: Italian

set -e

wget -O- https://github.com/maxpozdeev/mytinytodo/releases/download/v1.6.4/mytinytodo-v1.6.4.zip | bsdtar --strip-components=1 -xf -

mv db/config.php db/config.template.php

cat << EOF > db/config.php
<?php
\$config = array();
\$config['db'] = 'mysql';
\$config['mysql.host'] = '$DATABASE_HOST';
\$config['mysql.db'] = '$DATABASE_NAME';
\$config['mysql.user'] = '$DATABASE_USERNAME';
\$config['mysql.password'] = '$DATABASE_PASSWORD';
\$config['prefix'] = 'mtt_';
\$config['url'] = '';
\$config['mtt_url'] = '';
\$config['title'] = '';
\$config['lang'] = '$FORM_LANGUAGE';
\$config['password'] = '';
\$config['smartsyntax'] = 1;
\$config['timezone'] = 'Europe/Paris';
\$config['autotag'] = 1;
\$config['duedateformat'] = 1;
\$config['firstdayofweek'] = 1;
\$config['session'] = 'files';
\$config['clock'] = 24;
\$config['dateformat'] = 'j M Y';
\$config['dateformat2'] = 'n/j/y';
\$config['dateformatshort'] = 'j M';
\$config['template'] = 'default';
\$config['showdate'] = 0;
\$config['detectmobile'] = 1;
?>

EOF

curl -X POST -F installdb=mysql -F mysql_host='$DATABASE_HOST' -F mysql-db='$DATABASE_NAME' -F mysql_user='$DATABASE_USERNAME' -F mysql_password='$DATABASE_PASSWORD' -F submit=Next https://$INSTALL_URL/setup.php
curl -X POST -F install=Install https://$INSTALL_URL/setup.php
  
rm setup.php
