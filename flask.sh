#!/bin/bash

# site:
#     python_version: '3.9'
#     type: 'wsgi'
#     working_directory: '{INSTALL_PATH_RELATIVE}'
#     virtualenv_directory: '{INSTALL_PATH_RELATIVE}/env'
#     path: '{INSTALL_PATH_RELATIVE}:app'
#     path_trim: true
# requirements:
#     disk: 20

set -e

# https://flask.palletsprojects.com/en/1.1.x/installation/

python -m venv env
env/bin/pip install Flask

cat << EOF > __init__.py
from flask import Flask
from flask import render_template

app = Flask(__name__)

@app.route('/')
def hello_world():
    return render_template('hello.html')

if __name__ == "__main__":
  app.run(debug=True)

EOF

mkdir templates
cat << EOF > templates/hello.html
<!doctype html>
<title>Hello from Flask</title>
<h1>Hello, World!</h1>

EOF
