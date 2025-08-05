#!/bin/bash

# Declare site in YAML, as documented on the documentation: https://help.alwaysdata.com/en/marketplace/build-application-script/
# site:
#     type: elixir
#     elixir_version: '1.18'
#     working_directory: '{INSTALL_PATH_RELATIVE}/hello'
#     command: 'mix phx.server'
#     environment: |
#         MIX_HOME={INSTALL_PATH}/.mix
#         MIX_ENV=prod
#     path_trim: true
# requirements:
#     disk: 110

set -e

# https://hexdocs.pm/phoenix

#export MIX_HOME=$INSTALL_PATH/.mix

mix local.hex --force
mix local.rebar --force
mix archive.install hex phx_new 1.7.21 --force
echo Y | mix phx.new hello --no-ecto
cd hello

# Hardcode the secret as we have no way to define dynamic environment variables.
sed -z -i 's/# The secret.*"""\n\n  //' config/runtime.exs
sed -i "s/secret_key_base: secret_key_base/secret_key_base: \"$(mix phx.gen.secret | tr / A)\"/" config/runtime.exs

export MIX_ENV=prod
mix assets.deploy
mix phx.digest
mix compile
