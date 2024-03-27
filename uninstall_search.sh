#!/bin/bash

# Check if the current user is root
if [ "$(id -u)" = "0" ]; then
    # If user is root, no need for sudo
    rm /bin/search
    echo "Search has been uninstalled successfully."
else
    # If user is not root, use sudo
    sudo rm /bin/search
    echo "Search has been uninstalled successfully."
fi
