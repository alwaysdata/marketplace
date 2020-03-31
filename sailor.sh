#!/bin/bash

# site:
#     type: user_program
#     working_directory: '{INSTALL_PATH}'
#     command: '~{INSTALL_PATH_RELATIVE}/start-server.sh'
#     path_trim: true

set -e

LUAROCKS="luarocks --tree=$INSTALL_PATH/.luarocks"
$LUAROCKS install sailor
.luarocks/bin/sailor create hello

## Buster hotfix
if [ $(head -c1 /etc/debian_version) -eq 8 ]
then
    export IP='0.0.0.0'
else
    export IP='::'
fi

sed -i "s|host = \"\*\"|host = \"$IP\"|"  hello/start-server.lua
sed -i 's|port = 8080|port = os.getenv("PORT")|'  hello/start-server.lua

cat << EOF > hello/start-server.sh
#!/bin/sh
$($LUAROCKS path --bin)
exec lua5.1 start-server.lua
EOF

chmod +x hello/start-server.sh

shopt -s dotglob nullglob
mv hello/* .
rmdir hello
