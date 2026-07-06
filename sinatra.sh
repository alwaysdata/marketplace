#!/bin/bash

# Declare site in YAML, as documented here: https://help.alwaysdata.com/en/docs/development/marketplace/build-application-script/
# site:
#     type: user_program
#     working_directory: '{INSTALL_PATH_RELATIVE}'
#     command: 'ruby myapp.rb'
#     environment: |
#         RUBY_VERSION=4.0
#         HOME={INSTALL_PATH}
#         APP_ENV=production
# requirements:
#     disk: 70

set -e

# http://sinatrarb.com/documentation.html
# https://github.com/sinatra/sinatra

export RUBY_VERSION=4.0

gem install sinatra rackup puma

cat  << EOF > myapp.rb
require 'sinatra'
set :bind, '::'

get '/' do
  'Hello world!'
end
EOF

rm -rf .cache
