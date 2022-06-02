#!/bin/bash

# site:
#     type: ruby_rack
#     ruby_version: '3.1'
#     path: '{INSTALL_PATH_RELATIVE}/config.ru'
#     environment: 'RAILS_ENV=production'
#     bundler: true
#     path_trim: true
# database:
#     type: postgresql
# requirements:
#     disk: 150
# form:
#     language:
#         type: choices
#         label:
#             en: Language
#             fr: Langue
#         choices:
#             de: Deutsch
#             en: English
#             es: Español
#             fr: Français
#             it: Italiano

set -e

# https://www.redmine.org/projects/redmine/wiki/RedmineInstall

wget -O- --no-check-certificate https://www.redmine.org/releases/redmine-5.0.1.tar.gz | tar -xz --strip-components=1

# Database configuration
cat << EOF > config/database.yml
production:
  adapter: postgresql
  database: $DATABASE_NAME
  host: $DATABASE_HOST
  username: $DATABASE_USERNAME
  password: "$DATABASE_PASSWORD"
EOF

# Email configuration
cat << EOF > config/configuration.yml
production:
  email_delivery:
    delivery_method: :smtp
    smtp_settings:
      address: $SMTP_HOST
      port: 25
      domain: $INSTALL_URL_HOSTNAME
EOF

bundle install --path vendor/bundle --without development test
bundle exec rake generate_secret_token

RAILS_ENV=production bundle exec rake db:migrate
RAILS_ENV=production REDMINE_LANG=$FORM_LANGUAGE bundle exec rake redmine:load_default_data

# default credentials: admin / admin
