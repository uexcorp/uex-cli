#!/bin/bash

# UEX 2.0 CLI
# Copyright (C) 2954 United Express Corporation. All rights reserved.

set -eEuo pipefail # default error handling parameters
# -e            Exit immediately if a command exits with a non-zero status.
# -E            Allows script to access the ERR trap despite `set -e`.
# -u            Treat unset variables as an error.
# -o pipefail   Enable proper error reporting for pipelines - fail if any command in a pipeline fails.

trap 'echo "Error: Failed to install UEX CLI"; exit 1' ERR

# wrap script in function to protect against partial execution / transmission errors
function do_install {
    if [ "$EUID" -ne 0 ]; then
        echo "Error: This script requires super user privileges."
        exit
    fi

    install_directory="/usr/local/bin"
    script_name="uex"
    script_url="https://raw.githubusercontent.com/uexcorp/uex-cli/main/uex-cli.sh"

    curl -s -o "$install_directory/$script_name" -L "$script_url"
    chmod +x "$install_directory/$script_name"

    echo "UEX CLI has been installed to $install_directory/$script_name"
    echo "You can run it by typing '$script_name'"
}

do_install
