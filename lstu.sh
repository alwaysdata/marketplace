#!/bin/bash

# Declare site in YAML, as documented on the documentation: https://help.alwaysdata.com/en/marketplace/build-application-script/
# site:
#       type: user_program
#       working_directory: '{INSTALL_PATH}/app'
#       command: '{INSTALL_PATH}/perl5/bin/carton exec hypnotoad -f script/lstu'
#       environment: 'PERL5LIB={INSTALL_PATH}/perl5/lib/perl5 PERL_LOCAL_LIB_ROOT={INSTALL_PATH}/perl5'
# database:
#       type: postgresql
# requirements:
#     disk: 240

set -e

# https://framagit.org/fiat-tux/hat-softwares/lstu/wikis/installation

# Dependencies
export PATH="${INSTALL_PATH%/}/perl5/bin${PATH:+:${PATH}}"
export PERL5LIB="${INSTALL_PATH%/}/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"
export PERL_LOCAL_LIB_ROOT="${INSTALL_PATH%/}/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"
export PERL_MB_OPT="--install_base \"${INSTALL_PATH%/}/perl5\""
export PERL_MM_OPT="INSTALL_BASE=${INSTALL_PATH%/}/perl5"

# Use http://search.cpan.org/dist/App-cpanminus instead of cpan installer
# for automation
curl -L http://cpanmin.us | perl - --self-upgrade

# Install Carton package manager
cpan -f Carton

# Install
git clone --depth 1 https://framagit.org/luc/lstu.git app
cd app
carton install \
    --without=cache \
    --without=ldap \
    --without=test \
    --without=mysql \
    --without=sqlite

# Config
sed -e "s/127.0.0.1:8080/$IP:$PORT/" \
    -e "s/#proxy/proxy/" \
    -e "s/#contact/contact/" \
    -e "s/admin\[at\]example.com/$USER@$RESELLER_DOMAIN/" \
    -e "s/#secret/secret/" \
    -e "21s/fdjsofjoihrei/$(openssl rand -hex 24)/" \
    -e "s/#prefix/prefix/" \
    -e "s~'/'~'$INSTALL_URL_PATH'~" \
    -e "s/#dbtype => 'sqlite'/dbtype => 'postgresql'/" \
    -e "s/#pgdb/pgdb/" \
    -e "94s/#    database => 'lstu'/    database => '$DATABASE_NAME'/" \
    -e "95s/#    host     => 'localhost'/    host     => '$DATABASE_HOST'/" \
    -e "98s/#    user     => 'DBUSER'/    user     => '$DATABASE_USERNAME'/" \
    -e "99s/#    pwd      => 'DBPASSWORD'/    pwd      => '$DATABASE_PASSWORD'/" \
    -e "102s/#}/}/" \
    lstu.conf.template > lstu.conf
