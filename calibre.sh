#!/bin/bash

# site:
#     type: user_program
#     working_directory: '{INSTALL_PATH}'
#     command: './env/bin/cps -i "::"'
#     ssl_force: true
#     environment: |
#         HOME={INSTALL_PATH}
# requirements:
#     disk: 150

set -e

export PYTHON_VERSION="3.10"

# Python environment
python -m venv env
source env/bin/activate

pip install calibreweb

# The port is stored in database (~/.calibre-webb/app.db by default) and CALIBRE_PORT is only used at database initialization, so at first launch
# Initialize the database using the port we specify
CALIBRE_PORT=$PORT timeout 5s cps || true

# default credentials: admin / admin123
# You will need to upload your Calibre library (books and metadata database) in your alwaysdata account via SSH/SFTP/FTP.
