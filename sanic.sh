#!/bin/bash

# site:
#     type: user_program
#     working_directory: '{INSTALL_PATH}'
#     command: 'env/bin/sanic hello.app --host="::" --port=$PORT'
#     path_trim: true
#     ssl_force: true
# requirements:
#     disk: 50

set -e

export PYTHON_VERSION=3.11

python -m venv env
source env/bin/activate

# https://sanic.dev/en/guide/getting-started.html

pip --cache-dir=/dev/null install sanic

cat << EOF > hello.py
from sanic import Sanic
from sanic.response import text

app = Sanic(__name__)

@app.get("/")
async def hello(request):
    return text("Hello, world.")
EOF
