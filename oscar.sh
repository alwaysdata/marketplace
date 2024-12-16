#!/bin/bash

# Declare site in YAML, as documented on the documentation: https://help.alwaysdata.com/en/marketplace/build-application-script/
# site:
#     type: wsgi
#     python_version: '3.11'
#     working_directory: '{INSTALL_PATH_RELATIVE}'
#     virtualenv_directory: '{INSTALL_PATH_RELATIVE}/env'
#     path: '{INSTALL_PATH_RELATIVE}/{FORM_PROJECT}/wsgi.py'
#     static_paths: /static=static
# database:
#     type: postgresql
# requirements:
#     disk: 250
# form:
#     project:
#         label:
#             en: Project name
#             fr: Nom du projet
#         regex: ^[a-zA-Z][a-zA-Z0-9_]+$
#         regex_text: "Il doit comporter des majuscules et minuscules et peut aussi utiliser des chiffres et le tiret bas (_)."
#         max_length: 255
#     email:
#         type: email
#         label:
#             en: Email
#             fr: Email
#         max_length: 255
#     admin_username:
#         label:
#             en: Administrator username
#             fr: Nom d'utilisateur de l'administrateur
#         max_length: 255
#     admin_password:
#         type: password
#         label:
#             en: Administrator password
#             fr: Mot de passe de l'administrateur
#         max_length: 255

set -e

# http://docs.oscarcommerce.com/en/latest/internals/getting_started.html#install-oscar-and-its-dependencies

# Create a virtualenv and install Oscar in it
python -m venv env
source env/bin/activate

python -m pip install django-oscar[sorl-thumbnail]

./env/bin/django-admin startproject $FORM_PROJECT .

# Configuration
sed -i "s|DEBUG = True|DEBUG = False|" $FORM_PROJECT/settings.py
sed -i "s|ALLOWED_HOSTS = \[\]|ALLOWED_HOSTS = \[\'*\'\]|" $FORM_PROJECT/settings.py
sed -i "/from pathlib import Path/a from oscar.defaults import *" $FORM_PROJECT/settings.py

cat << EOF | sed -i "/'django.contrib.messages.context_processors.messages',/r /dev/stdin" $FORM_PROJECT/settings.py
                'oscar.apps.search.context_processors.search_form',
                'oscar.apps.checkout.context_processors.checkout',
                'oscar.apps.communication.notifications.context_processors.notifications',
                'oscar.core.context_processors.metadata',
EOF

cat << EOF | sed -i "/'django.contrib.staticfiles',/r /dev/stdin" $FORM_PROJECT/settings.py
    'django.contrib.sites',
    'django.contrib.flatpages',
    
    'oscar.config.Shop',
    'oscar.apps.analytics.apps.AnalyticsConfig',
    'oscar.apps.checkout.apps.CheckoutConfig',
    'oscar.apps.address.apps.AddressConfig',
    'oscar.apps.shipping.apps.ShippingConfig',
    'oscar.apps.catalogue.apps.CatalogueConfig',
    'oscar.apps.catalogue.reviews.apps.CatalogueReviewsConfig',
    'oscar.apps.communication.apps.CommunicationConfig',
    'oscar.apps.partner.apps.PartnerConfig',
    'oscar.apps.basket.apps.BasketConfig',
    'oscar.apps.payment.apps.PaymentConfig',
    'oscar.apps.offer.apps.OfferConfig',
    'oscar.apps.order.apps.OrderConfig',
    'oscar.apps.customer.apps.CustomerConfig',
    'oscar.apps.search.apps.SearchConfig',
    'oscar.apps.voucher.apps.VoucherConfig',
    'oscar.apps.wishlists.apps.WishlistsConfig',
    'oscar.apps.dashboard.apps.DashboardConfig',
    'oscar.apps.dashboard.reports.apps.ReportsDashboardConfig',
    'oscar.apps.dashboard.users.apps.UsersDashboardConfig',
    'oscar.apps.dashboard.orders.apps.OrdersDashboardConfig',
    'oscar.apps.dashboard.catalogue.apps.CatalogueDashboardConfig',
    'oscar.apps.dashboard.offers.apps.OffersDashboardConfig',
    'oscar.apps.dashboard.partners.apps.PartnersDashboardConfig',
    'oscar.apps.dashboard.pages.apps.PagesDashboardConfig',
    'oscar.apps.dashboard.ranges.apps.RangesDashboardConfig',
    'oscar.apps.dashboard.reviews.apps.ReviewsDashboardConfig',
    'oscar.apps.dashboard.vouchers.apps.VouchersDashboardConfig',
    'oscar.apps.dashboard.communications.apps.CommunicationsDashboardConfig',
    'oscar.apps.dashboard.shipping.apps.ShippingDashboardConfig',
    
    # 3rd-party apps that oscar depends on
    'widget_tweaks',
    'haystack',
    'treebeard',
    'sorl.thumbnail',   # Default thumbnail backend, can be replaced
    'django_tables2',
EOF

cat << EOF | sed -i "/'django.middleware.clickjacking.XFrameOptionsMiddleware',/r /dev/stdin" $FORM_PROJECT/settings.py
    'oscar.apps.basket.middleware.BasketMiddleware',
    'django.contrib.flatpages.middleware.FlatpageFallbackMiddleware',
EOF

# Statics
sed -i "s|STATIC_URL = '\/static\/'|STATIC_URL = 'static\/'|" $FORM_PROJECT/settings.py
cat << EOF  | sed -i "/'static\/'/r /dev/stdin" $FORM_PROJECT/settings.py
import os
STATIC_ROOT = os.path.join(BASE_DIR, "static")
EOF

echo "
# Authentication backend
AUTHENTICATION_BACKENDS = (
    'oscar.apps.customer.auth_backends.EmailBackend',
    'django.contrib.auth.backends.ModelBackend',
)

# Search backend
HAYSTACK_CONNECTIONS = {
    'default': {
        'ENGINE': 'haystack.backends.simple_backend.SimpleEngine',
    },
}

SITE_ID = 1

# Order pipeline
OSCAR_INITIAL_ORDER_STATUS = 'Pending'
OSCAR_INITIAL_LINE_STATUS = 'Pending'
OSCAR_ORDER_STATUS_PIPELINE = {
    'Pending': ('Being processed', 'Cancelled',),
    'Being processed': ('Processed', 'Cancelled',),
    'Cancelled': (),
}" >> $FORM_PROJECT/settings.py

# Urls
sed -i "/from django.contrib import admin/a from django.apps import apps" $FORM_PROJECT/urls.py
sed -i "s|from django.urls import path|from django.urls import include, path|"  $FORM_PROJECT/urls.py
sed -i "/urlpatterns = \[/a \ \ \ \ path('i18n\/', include('django.conf.urls.i18n'))," $FORM_PROJECT/urls.py
sed -i "/path('admin\/', admin.site.urls),/a  \ \ \ \ path('', include(apps.get_app_config('oscar').urls[0]))," $FORM_PROJECT/urls.py

# Database
sed -i "s|django.db.backends.sqlite3|django.db.backends.postgresql|" $FORM_PROJECT/settings.py
sed -i "s|BASE_DIR / 'db.sqlite3'|'$DATABASE_NAME'|" $FORM_PROJECT/settings.py
cat << EOF  | sed -i "/'$DATABASE_NAME',/r /dev/stdin" $FORM_PROJECT/settings.py
        'USER': '$DATABASE_USERNAME',
        'PASSWORD': '$DATABASE_PASSWORD',
        'HOST': '$DATABASE_HOST',
        'PORT': '5432',
EOF

python -m pip install psycopg2 pycountry

python manage.py migrate
echo "yes"| python manage.py collectstatic
python manage.py oscar_populate_countries

# Create admin user
DJANGO_SUPERUSER_PASSWORD="$FORM_ADMIN_PASSWORD" python manage.py createsuperuser --username $FORM_ADMIN_USERNAME --email $FORM_EMAIL --noinput

# Clean install environment
rm -rf ~/.cache
