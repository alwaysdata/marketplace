#!/bin/bash

# site:
#     type: wsgi
#     path_trim: true
#     python_version: '3.12'
#     working_directory: '{INSTALL_PATH_RELATIVE}'
#     virtualenv_directory: '{INSTALL_PATH_RELATIVE}/env'
#     path: '{INSTALL_PATH_RELATIVE}/dpaste/wsgi.py'
# requirements:
#     disk: 115


set -e

VERSION=3.8

# Python environment
python -m venv env
source env/bin/activate
env/bin/pip install -U pip

# Get sources
curl -sSL \
  https://github.com/DarrenOfficial/dpaste/archive/refs/tags/v${VERSION}.tar.gz \
| tar xz --strip-components=1 -C ${INSTALL_PATH}

# Follow https://github.com/DarrenOfficial/dpaste/blob/master/Dockerfile for
# standalone app install
npm ci --ignore-scripts
mkdir -p dpaste/static

make css
make js

env/bin/pip install -e .[production]

./manage.py collectstatic --noinput
./manage.py migrate --noinput

# Install local config
cat << EOF > dpaste/settings/local.py
import sys

from dpaste.settings.base import *

DEBUG = False
TIME_ZONE = "Europe/Paris"

EMAIL_BACKEND = 'django.core.mail.backends.console.EmailBackend'

from dpaste.apps import dpasteAppConfig
from django.utils.translation import gettext_lazy as _

# Check https://docs.dpaste.org/settings/ for config options
class ProductionDpasteAppConfig(dpasteAppConfig):
    @staticmethod
    def get_base_url(request=None):
        return "https://${INSTALL_URL}"

INSTALLED_APPS.remove('dpaste.apps.dpasteAppConfig')
INSTALLED_APPS.append('dpaste.settings.local.ProductionDpasteAppConfig')
EOF
