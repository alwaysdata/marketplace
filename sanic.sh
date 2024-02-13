#!/bin/bash

# Declare site in YAML, as documented on the documentation: https://help.alwaysdata.com/en/marketplace/build-application-script/
# site:
#     type: user_program
#     working_directory: '{INSTALL_PATH}'
#     command: 'env/bin/sanic hello.app --host="::" --port=$PORT'
#     path_trim: true
#     ssl_force: true
# requirements:
#     disk: 50

set -e

# https://sanic.dev/en/guide/getting-started.html

export PYTHON_VERSION=3.11

# Create a virtualenv
python -m venv env
source env/bin/activate

# Install Sanic in it
pip --cache-dir=/dev/null install sanic

cat << EOF > hello.py
from sanic import Sanic
from sanic.response import text

app = Sanic(__name__)

@app.get("/")
async def hello(request):
    return text("Hello, world.")
EOF
