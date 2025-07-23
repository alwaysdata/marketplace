#!/bin/bash

# Declare site in YAML, as documented on the documentation: https://help.alwaysdata.com/en/marketplace/build-application-script/
# site:
#     type: user_program
#     working_directory: '{INSTALL_PATH_RELATIVE}'
#     command: 'env/bin/streamlit hello'
#     ssl_force: true
#     environment: |
#          HOME={INSTALL_PATH}
# requirements:
#     disk: 520

set -e

# https://docs.streamlit.io/library/get-started/installation

export PYTHON_VERSION=3.12

# Create a virtualenv and install Streamlit in it
python -m venv env
./env/bin/pip install --upgrade pip
./env/bin/python -m pip install streamlit

# Configuration
mkdir .streamlit
cat << EOF > .streamlit/config.toml
[server]
address = "::"
port = $PORT
baseUrlPath = "${INSTALL_URL_PATH#*/}"

[browser]
serverAddress = "$INSTALL_URL_HOSTNAME"
serverPort = 443
EOF
