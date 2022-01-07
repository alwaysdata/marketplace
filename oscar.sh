#!/bin/bash

# site:
#     type: wsgi
#     python_version: '3.9'
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
#         max_length: 255
#     email:
#         type: email
#         label:
#             en: Email
#             fr: Email
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

python -m venv env
source env/bin/activate

python -m pip install django-oscar[sorl-thumbnail]

./env/bin/django-admin startproject $FORM_PROJECT .
sed -i "s|DEBUG = True|DEBUG = False|" $FORM_PROJECT/settings.py
sed -i "s|ALLOWED_HOSTS = \[\]|ALLOWED_HOSTS = \[\'*\'\]|" $FORM_PROJECT/settings.py
sed -i "/from pathlib import Path/a from oscar.defaults import *" $FORM_PROJECT/settings.py
sed -i "/'django.contrib.messages.context_processors.messages',/a \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 'oscar.apps.search.context_processors.search_form'," $FORM_PROJECT/settings.py
sed -i "/'oscar.apps.search.context_processors.search_form',/a \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 'oscar.apps.checkout.context_processors.checkout'," $FORM_PROJECT/settings.py
sed -i "/'oscar.apps.checkout.context_processors.checkout',/a \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 'oscar.apps.communication.notifications.context_processors.notifications'," $FORM_PROJECT/settings.py
sed -i "/'oscar.apps.communication.notifications.context_processors.notifications',/a \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 'oscar.core.context_processors.metadata'," $FORM_PROJECT/settings.py
sed -i "/'django.contrib.staticfiles',/a \ \ \ \ 'django.contrib.sites'," $FORM_PROJECT/settings.py
sed -i "/'django.contrib.sites',/a \ \ \ \ 'django.contrib.flatpages'," $FORM_PROJECT/settings.py
sed -i "/'django.contrib.flatpages',/a \ \ \ \ 'oscar.config.Shop'," $FORM_PROJECT/settings.py
sed -i "/'oscar.config.Shop',/a \ \ \ \ 'oscar.apps.analytics.apps.AnalyticsConfig'," $FORM_PROJECT/settings.py
sed -i "/'oscar.apps.analytics.apps.AnalyticsConfig',/a \ \ \ \ 'oscar.apps.checkout.apps.CheckoutConfig'," $FORM_PROJECT/settings.py
sed -i "/'oscar.apps.checkout.apps.CheckoutConfig',/a \ \ \ \ 'oscar.apps.address.apps.AddressConfig'," $FORM_PROJECT/settings.py
sed -i "/'oscar.apps.address.apps.AddressConfig',/a \ \ \ \ 'oscar.apps.shipping.apps.ShippingConfig'," $FORM_PROJECT/settings.py
sed -i "/'oscar.apps.shipping.apps.ShippingConfig',/a \ \ \ \ 'oscar.apps.catalogue.apps.CatalogueConfig'," $FORM_PROJECT/settings.py
sed -i "/'oscar.apps.catalogue.apps.CatalogueConfig',/a \ \ \ \ 'oscar.apps.catalogue.reviews.apps.CatalogueReviewsConfig'," $FORM_PROJECT/settings.py
sed -i "/'oscar.apps.catalogue.reviews.apps.CatalogueReviewsConfig',/a \ \ \ \ 'oscar.apps.communication.apps.CommunicationConfig'," $FORM_PROJECT/settings.py
sed -i "/'oscar.apps.communication.apps.CommunicationConfig',/a \ \ \ \ 'oscar.apps.partner.apps.PartnerConfig'," $FORM_PROJECT/settings.py
sed -i "/'oscar.apps.partner.apps.PartnerConfig',/a \ \ \ \ 'oscar.apps.basket.apps.BasketConfig'," $FORM_PROJECT/settings.py
sed -i "/'oscar.apps.basket.apps.BasketConfig',/a \ \ \ \ 'oscar.apps.payment.apps.PaymentConfig'," $FORM_PROJECT/settings.py
sed -i "/'oscar.apps.payment.apps.PaymentConfig',/a \ \ \ \ 'oscar.apps.offer.apps.OfferConfig'," $FORM_PROJECT/settings.py
sed -i "/'oscar.apps.offer.apps.OfferConfig',/a \ \ \ \ 'oscar.apps.order.apps.OrderConfig'," $FORM_PROJECT/settings.py
sed -i "/'oscar.apps.order.apps.OrderConfig',/a \ \ \ \ 'oscar.apps.customer.apps.CustomerConfig'," $FORM_PROJECT/settings.py
sed -i "/'oscar.apps.customer.apps.CustomerConfig',/a \ \ \ \ 'oscar.apps.search.apps.SearchConfig'," $FORM_PROJECT/settings.py
sed -i "/'oscar.apps.search.apps.SearchConfig',/a \ \ \ \ 'oscar.apps.voucher.apps.VoucherConfig'," $FORM_PROJECT/settings.py
sed -i "/'oscar.apps.voucher.apps.VoucherConfig',/a \ \ \ \ 'oscar.apps.wishlists.apps.WishlistsConfig'," $FORM_PROJECT/settings.py
sed -i "/'oscar.apps.wishlists.apps.WishlistsConfig',/a \ \ \ \ 'oscar.apps.dashboard.apps.DashboardConfig'," $FORM_PROJECT/settings.py
sed -i "/'oscar.apps.dashboard.apps.DashboardConfig',/a \ \ \ \ 'oscar.apps.dashboard.reports.apps.ReportsDashboardConfig'," $FORM_PROJECT/settings.py
sed -i "/'oscar.apps.dashboard.reports.apps.ReportsDashboardConfig',/a \ \ \ \ 'oscar.apps.dashboard.users.apps.UsersDashboardConfig'," $FORM_PROJECT/settings.py
sed -i "/'oscar.apps.dashboard.users.apps.UsersDashboardConfig',/a \ \ \ \ 'oscar.apps.dashboard.orders.apps.OrdersDashboardConfig'," $FORM_PROJECT/settings.py
sed -i "/'oscar.apps.dashboard.orders.apps.OrdersDashboardConfig',/a \ \ \ \ 'oscar.apps.dashboard.catalogue.apps.CatalogueDashboardConfig'," $FORM_PROJECT/settings.py
sed -i "/'oscar.apps.dashboard.catalogue.apps.CatalogueDashboardConfig',/a \ \ \ \ 'oscar.apps.dashboard.offers.apps.OffersDashboardConfig'," $FORM_PROJECT/settings.py
sed -i "/'oscar.apps.dashboard.offers.apps.OffersDashboardConfig',/a \ \ \ \ 'oscar.apps.dashboard.partners.apps.PartnersDashboardConfig'," $FORM_PROJECT/settings.py
sed -i "/'oscar.apps.dashboard.partners.apps.PartnersDashboardConfig',/a \ \ \ \ 'oscar.apps.dashboard.pages.apps.PagesDashboardConfig'," $FORM_PROJECT/settings.py
sed -i "/'oscar.apps.dashboard.pages.apps.PagesDashboardConfig',/a \ \ \ \ 'oscar.apps.dashboard.ranges.apps.RangesDashboardConfig'," $FORM_PROJECT/settings.py
sed -i "/'oscar.apps.dashboard.ranges.apps.RangesDashboardConfig',/a \ \ \ \ 'oscar.apps.dashboard.reviews.apps.ReviewsDashboardConfig'," $FORM_PROJECT/settings.py
sed -i "/'oscar.apps.dashboard.reviews.apps.ReviewsDashboardConfig',/a \ \ \ \ 'oscar.apps.dashboard.vouchers.apps.VouchersDashboardConfig'," $FORM_PROJECT/settings.py
sed -i "/'oscar.apps.dashboard.vouchers.apps.VouchersDashboardConfig',/a \ \ \ \ 'oscar.apps.dashboard.communications.apps.CommunicationsDashboardConfig'," $FORM_PROJECT/settings.py
sed -i "/'oscar.apps.dashboard.communications.apps.CommunicationsDashboardConfig',/a \ \ \ \ 'oscar.apps.dashboard.shipping.apps.ShippingDashboardConfig'," $FORM_PROJECT/settings.py
sed -i "/'oscar.apps.dashboard.shipping.apps.ShippingDashboardConfig',/a \ \ \ \ 'widget_tweaks'," $FORM_PROJECT/settings.py
sed -i "/'widget_tweaks',/a \ \ \ \ 'haystack'," $FORM_PROJECT/settings.py
sed -i "/'haystack',/a \ \ \ \ 'treebeard'," $FORM_PROJECT/settings.py
sed -i "/'treebeard',/a \ \ \ \ 'sorl.thumbnail'," $FORM_PROJECT/settings.py
sed -i "/'sorl.thumbnail',/a \ \ \ \ 'django_tables2'," $FORM_PROJECT/settings.py
sed -i "/'django.middleware.clickjacking.XFrameOptionsMiddleware',/a \ \ \ \ 'oscar.apps.basket.middleware.BasketMiddleware'," $FORM_PROJECT/settings.py
sed -i "/'oscar.apps.basket.middleware.BasketMiddleware',/a \ \ \ \ 'django.contrib.flatpages.middleware.FlatpageFallbackMiddleware'," $FORM_PROJECT/settings.py
sed -i "s|STATIC_URL = '\/static\/'|STATIC_URL = 'static\/'|" $FORM_PROJECT/settings.py
sed -i "/STATIC_URL = 'static\/'/a import os" $FORM_PROJECT/settings.py
sed -i "/import os/a STATIC_ROOT = os.path.join(BASE_DIR, \"static\")" $FORM_PROJECT/settings.py
echo "AUTHENTICATION_BACKENDS = (
    'oscar.apps.customer.auth_backends.EmailBackend',
    'django.contrib.auth.backends.ModelBackend',
)" >> $FORM_PROJECT/settings.py
echo "HAYSTACK_CONNECTIONS = {
    'default': {
        'ENGINE': 'haystack.backends.simple_backend.SimpleEngine',
    },
}" >> $FORM_PROJECT/settings.py
echo "SITE_ID = 1" >> $FORM_PROJECT/settings.py

echo "OSCAR_INITIAL_ORDER_STATUS = 'Pending'
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
sed -i "/'$DATABASE_NAME',/a \ \ \ \ \ \ \ 'USER': '$DATABASE_USERNAME'," $FORM_PROJECT/settings.py
sed -i "/'$DATABASE_USERNAME',/a \ \ \ \ \ \ \ 'PASSWORD': '$DATABASE_PASSWORD'," $FORM_PROJECT/settings.py
sed -i "/'$DATABASE_PASSWORD',/a \ \ \ \ \ \ \ 'HOST': '$DATABASE_HOST'," $FORM_PROJECT/settings.py
sed -i "/'$DATABASE_HOST',/a \ \ \ \ \ \ \ 'PORT': '5432'," $FORM_PROJECT/settings.py

python -m pip install psycopg2 pycountry

python manage.py migrate
echo "yes"| python manage.py collectstatic
python manage.py oscar_populate_countries

# First admin user
DJANGO_SUPERUSER_PASSWORD="$FORM_ADMIN_PASSWORD" python manage.py createsuperuser --username $FORM_ADMIN_USERNAME --email $FORM_EMAIL --noinput

# Cleaning
rm -rf ~/.cache
