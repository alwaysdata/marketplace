#!/bin/bash

# site:
#     type: ruby_rack
#     ruby_version: '3.1.0'
#     path: '{INSTALL_PATH_RELATIVE}/config.ru'
#     bundler: true
#     path_trim: false
#     environment: RAILS_ENV=development
# requirements:
#     disk: 140

set -e

# https://guides.rubyonrails.org/getting_started.html

gem install rails
.local/share/gem/ruby/3.1.0/bin/rails new .

bundle config set deployment 'true'
bundle install

echo "Rails.application.config.hosts << '${INSTALL_URL_HOSTNAME}'" >> config/environments/development.rb

cat << EOF > config.ru
require_relative 'config/environment'

map '${INSTALL_URL_PATH}' do
  run Rails.application
end
EOF
