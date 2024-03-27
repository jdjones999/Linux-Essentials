#!/bin/bash

# Color codes
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to display section header
display_section_header() {
    printf "\n${RED}$1${NC}\n\n"
}

# Check if the current user is root
if [ "$(id -u)" = "0" ]; then
    # If user is root, no need for sudo
    if [ -f "/bin/search" ]; then
        display_section_header "Search has been previously installed."
    else
        cp ~/search /bin/search
        display_section_header "Search has been installed successfully."
    fi
else
    # If user is not root, use sudo
    if [ -f "/bin/search" ]; then
        display_section_header "Search has been previously installed."
    else
        sudo cp ~/search /bin/search
        display_section_header "Search has been installed successfully."
    fi
fi
