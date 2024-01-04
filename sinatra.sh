#!/bin/bash

# site:
#     ruby_version: '3.2'
#     type: 'ruby_rack'
#     working_directory: '{INSTALL_PATH_RELATIVE}'
#     path: '{INSTALL_PATH_RELATIVE}/config.ru'
#     path_trim: true
# requirements:
#     disk: 20

set -e

# http://sinatrarb.com/documentation.html

cat << EOF > Gemfile
source "http://rubygems.org"

gem 'sinatra', require: 'sinatra/base'
gem 'sinatra-reloader', require: 'sinatra/reloader'

EOF
bundle install --path vendor/bundle

cat << EOF > server.rb
# Requires the Gemfile
require 'bundler' ; Bundler.require

# Sinatra server
module Server
  class App < Sinatra::Base
    register Sinatra::Reloader

    get '/' do
      erb :index
    end
  end
end

EOF

cat << EOF > config.ru
require './server.rb'

run Server::App

EOF

mkdir views
cat << EOF > views/index.erb
<!DOCTYPE html>
<html lang="en">

<head>
	<title>Hello World!</title>
</head>

<body>
	<h1>Hello World!</h1>
	<p>Today is <%= Time.now.strftime('%A') %></p>
</body>

</html>

EOF
