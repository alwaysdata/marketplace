#!/bin/bash

# site:
#     type: ruby_rack
#     ruby_version: '2.5'
#     path:  '{INSTALL_PATH_RELATIVE}/config.ru'
#     bundler: true
#     path_trim: true

set -e 

# https://guides.rubyonrails.org/getting_started.html

gem install rails
rails new default

shopt -s dotglob nullglob
mv default/* .
rmdir default

bundle install --deployment
