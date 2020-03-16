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
echo 'Y' | mix archive.install hex phx_new 1.4.12
echo 'Y' | mix phx.new hello --no-ecto 
cd hello

cat << EOF > config/prod.secret.exs
# In this file, we load production configuration and
# secrets from environment variables. You can also
# hardcode secrets, although such is generally not
# recommended and you have to remember to add this
# file to your .gitignore.
use Mix.Config

secret_key_base = '$(mix phx.gen.secret| sha256sum -b | sed 's/ .*//')'
#  System.get_env("SECRET_KEY_BASE") ||
#    raise """
#    environment variable SECRET_KEY_BASE is missing.
#    You can generate one by calling: mix phx.gen.secret
#    """

config :hello, HelloWeb.Endpoint,
  http: [$(test $(head -c1 /etc/debian_version) == 8 && echo ':inet' || echo ':inet6'), port: String.to_integer(System.get_env("PORT") || "4000")],
  secret_key_base: secret_key_base
EOF

mix deps.get

MIX_ENV=prod mix compile
MIX_ENV=prod mix phx.digest
