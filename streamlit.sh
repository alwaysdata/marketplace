#!/bin/bash

# site:
#     type: user_program
#     working_directory: '{INSTALL_PATH}'
#     command: 'env/bin/streamlit hello'
#     ssl_force: true
# requirements:
#     disk: 500

set -e

# https://docs.streamlit.io/library/get-started/installation

export PYTHON_VERSION=3.11

python -m venv env
./env/bin/pip install --upgrade pip
./env/bin/python -m pip install streamlit

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
