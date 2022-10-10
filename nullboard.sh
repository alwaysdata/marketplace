#!/bin/bash

# site:
#     type: static
#     path: '{INSTALL_PATH_RELATIVE}'
# requirements:
#     disk: 25

set -e

git clone --depth 1 https://github.com/apankrat/nullboard.git .

mv nullboard.html index.html
