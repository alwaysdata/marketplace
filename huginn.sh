#!/bin/bash

# site:
#     type: user_program
#     working_directory: '{INSTALL_PATH}'
#     command: 'bundle exec rails server -b "::"'
#     ssl_force: true
#     environment: |
#         RUBY_VERSION=2.7
#         HOME={INSTALL_PATH}
# database:
#     type: mysql
# requirements:
#     disk: 1000
# form:
#     admin_username:
#         label:
#             en: Administrator username
#             fr: Nom d'utilisateur de l'administrateur
#         regex: ^[a-zA-Z]+$
#     admin_password:
#         type: password
#         label:
#             en: Administrator password
#             fr: Mot de passe de l'administrateur
#         min_length: 8

set -e

export RUBY_VERSION=2.7

wget -O- --no-hsts https://github.com/huginn/huginn/archive/refs/tags/v2022.08.18.tar.gz|tar -xz --strip-components=1

cat << EOF > .env

DOMAIN=$INSTALL_URL
PORT=$PORT

############################
#      Database Setup      #
############################

DATABASE_ADAPTER=mysql2
DATABASE_ENCODING=utf8mb4
DATABASE_RECONNECT=true
DATABASE_NAME=$DATABASE_NAME
DATABASE_POOL=20
DATABASE_USERNAME=$DATABASE_USERNAME
DATABASE_PASSWORD="$DATABASE_PASSWORD"
DATABASE_HOST=$DATABASE_HOST
DATABASE_PORT=3306
DATABASE_SOCKET=/home/$USER/admin/tmp/mysql.sock

RAILS_ENV=production

#############################
#    Email Configuration    #
#############################
SMTP_DELIVERY_METHOD=sendmail
EMAIL_FROM_ADDRESS=$USER@$RESELLER_DOMAIN
EOF

RAILS_ENV=production bundle install

sed -i "1iAPP_SECRET_TOKEN=$(rake secret | sed 's/ .*//')" .env
sed -i "s|config.assets.compile = false|config.assets.compile = true|" config/environments/production.rb

RAILS_ENV=production bundle exec rake db:migrate
RAILS_ENV=production bundle exec rake db:seed  SEED_USERNAME="$FORM_ADMIN_USERNAME" SEED_PASSWORD="$FORM_ADMIN_PASSWORD"
RAILS_ENV=production bundle exec rake assets:precompile
