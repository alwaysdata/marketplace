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

sed -i "s|host = \"\*\"|host = \"::\"|"  hello/start-server.lua
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
