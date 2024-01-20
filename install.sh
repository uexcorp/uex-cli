#!/bin/bash

install_directory="/usr/local/bin"
script_name="uex"
script_url="https://raw.githubusercontent.com/uexcorp/uex-cli/main/uex-cli.sh"

curl -s -o "$install_directory/$script_name" -L "$script_url"
chmod +x "$install_directory/$script_name"

echo "UEX CLI has been installed to $install_directory/$script_name"
echo "You can run it by typing '$script_name'"

