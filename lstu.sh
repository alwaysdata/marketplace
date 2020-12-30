#!/bin/bash
#
# site:
#       type: user_program
#       working_directory: '{INSTALL_PATH}/app'
#       command: '{INSTALL_PATH}/perl5/bin/carton exec hypnotoad -f script/lstu'
#       environment: 'PERL5LIB={INSTALL_PATH}/perl5/lib/perl5 PERL_LOCAL_LIB_ROOT={INSTALL_PATH}/perl5'
# database:
#       type: postgresql

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
cpan Carton

# Install
git clone https://framagit.org/luc/lstu.git app
cd app
carton install --without=cache --without=ldap --without=test --without=mysql

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
    -e "85s/#    database => 'lstu'/    database => '$DATABASE_NAME'/" \
    -e "86s/#    host     => 'localhost'/    host     => '$DATABASE_HOST'/" \
    -e "89s/#    user     => 'DBUSER'/    user     => '$DATABASE_USERNAME'/" \
    -e "90s/#    pwd      => 'DBPASSWORD'/    pwd      => '$DATABASE_PASSWORD'/" \
    -e "93s/#}/}/" \
    lstu.conf.template > lstu.conf
