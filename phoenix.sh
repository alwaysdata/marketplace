#!/bin/bash

# site:
#     type: elixir
#     elixir_version: '1.7'
#     working_directory: '{INSTALL_PATH}/hello'
#     command: 'mix phx.server'
#     environment: 'MIX_HOME={INSTALL_PATH}/.mix MIX_ENV=prod'
#     path_trim: true

set -e

# https://hexdocs.pm/phoenix

export MIX_HOME=$INSTALL_PATH/.mix

echo 'Y' | mix local.hex 
mix local.rebar 
echo 'Y' | mix archive.install hex phx_new 1.4.1
echo 'Y' | mix phx.new hello --no-ecto 
cd hello

sed -i 's|:inet6|:inet|' config/prod.exs

mix deps.get
MIX_ENV=prod mix compile
MIX_ENV=prod mix phx.digest
