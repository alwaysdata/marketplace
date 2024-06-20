#!/bin/bash

# Declare site in YAML, as documented on the documentation: https://help.alwaysdata.com/en/marketplace/build-application-script/
# site:
#     type: user_program
#     working_directory: '{INSTALL_PATH_RELATIVE}'
#     command: './bin/rails server -b "::"'
#     environment: |
#         RAILS_ENV=production
#         RUBY_VERSION=3.2
# requirements:
#     disk: 240

set -e

# https://guides.rubyonrails.org/getting_started.html

export RUBY_VERSION=3.2

gem install rails
.local/share/gem/ruby/3.2.0/bin/rails new .

bundle config set deployment 'true'
bundle install

echo "Rails.application.config.hosts << '${INSTALL_URL_HOSTNAME}'" >> config/environments/production.rb

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

# Rails runs with a Puma embedded webserver - https://puma.io/
