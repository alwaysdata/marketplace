#!/bin/bash

# site:
#     type: static
#     path: '{INSTALL_PATH_RELATIVE}'
# requirements:
#     disk: 26

set -e

git clone https://github.com/apankrat/nullboard.git .

mv nullboard.html index.html
