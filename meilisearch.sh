#!/bin/bash

# Declare site in YAML, as documented on the documentation: https://help.alwaysdata.com/en/marketplace/build-application-script/
# site:
#     type: user_program
#     working_directory: '{INSTALL_PATH_RELATIVE}'
#     command: './meilisearch --config-file-path="./config.toml"'
# requirements:
#     disk: 130

set -e
# Install the latest self-hosted Meilisearch
curl -L https://install.meilisearch.com | sh
# Fetch the default configuration file
curl https://raw.githubusercontent.com/meilisearch/meilisearch/latest/config.toml > config.toml
sed -i "s|localhost:7700|$IP:$PORT|" config.toml
# Generate and save a random master key
master_key=`uuidgen`
sed -i "s|# master_key = \"YOUR_MASTER_KEY_VALUE\"|master_key = \"$master_key\"|" config.toml
timeout 5s ./meilisearch --config-file-path="./config.toml" ||true 
# Fetch and store the default API keys in api_keys.json
curl -X GET http://$INSTALL_URL/keys -H "Authorization: Bearer $master_key" > api_keys.json