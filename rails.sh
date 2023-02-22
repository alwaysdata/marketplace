#!/bin/bash

# site:
#     type: ruby_rack
#     ruby_version: '3.1'
#     path: '{INSTALL_PATH_RELATIVE}/config.ru'
#     bundler: true
#     path_trim: false
#     environment: RAILS_ENV=production
# requirements:
#     disk: 160

set -e

# https://guides.rubyonrails.org/getting_started.html

gem install rails
.local/share/gem/ruby/3.1.0/bin/rails new .

bundle config set deployment 'true'
bundle install

echo "Rails.application.config.hosts << '${INSTALL_URL_HOSTNAME}'" >> config/environments/production.rb

cat << EOF > config.ru
require_relative 'config/environment'

map '${INSTALL_URL_PATH}' do
  run Rails.application
end
EOF

cat << EOF > config/routes.rb
Rails.application.routes.draw do
  root "articles#index"
  get "/articles", to: "articles#index"

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
EOF

bin/rails generate controller Articles index --skip-routes

cat << EOF > app/views/articles/index.html.erb
<h1>Hello, Rails!</h1>
EOF

RAILS_ENV=production bundle exec rake assets:precompile 
