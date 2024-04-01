#!/bin/bash

# Function to display section header
display_section_header() {
    local header_color="${1:-$RED}"  # Use provided color or default to red
    printf "\n${header_color}$2${NC}\n\n"
}

# Color codes
RED='\033[0;31m'   # Red color code
BABY_BLUE='\033[0;34m'  # Baby blue color code
BLUE='\033[0;34m'   # Blue color code
GREEN='\033[38;2;22;196;12m'  # Green -Terminal Green
ORANGE='\033[0;33m' # Orange color code
NC='\033[0m' # No Color

# Check if requirements.txt file exists
if [ -f "requirements.txt" ]; then
    display_section_header "$BLUE" "Installing packages from requirements.txt:"

    # Read each line in requirements.txt and install the packages
    while IFS= read -r package; do
        display_section_header "$BLUE" "Installing $package..."
        sudo apt-get install -y "$package"
        display_section_header "$GREEN" "Installed $package"
    done < requirements.txt

    display_section_header "$GREEN" "Requirements installation complete."
else
    display_section_header "$RED" "Error: requirements.txt file not found."
fi
#===============================[ Install (search) ]===============================

# Get the current directory of the script
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# Check if the current user is root
if [ "$(id -u)" = "0" ]; then
    # If user is root, no need for sudo
    if [ -f "/bin/search" ]; then
        display_section_header "$ORANGE" "Search has been previously installed."
    else
        cp "$SCRIPT_DIR/search" /bin/search
        chmod +x /bin/search
        display_section_header "$GREEN" "Search has been installed successfully."
    fi
else
    # If user is not root, use sudo
    if [ -f "/bin/search" ]; then
        display_section_header "$ORANGE" "Search has been previously installed."
    else
        sudo cp "$SCRIPT_DIR/search" /bin/search
        sudo chmod +x /bin/search
        display_section_header "$GREEN" "Search has been installed successfully."
    fi
fi

#===============================[ Install (banner) ]===============================

# Specify the URL of the file to download
url="http://www.figlet.org/fonts/rowancap.flf"

# Specify the target directory
target_dir="/usr/share/figlet"

# Specify the filename
filename="rowancap.flf"

display_section_header "$GREEN" "Installing font for (banner)"

# Check if the file already exists in the target directory
if sudo [ ! -f "$target_dir/$filename" ]; then
    # File doesn't exist, so download it
    sudo wget -P "$target_dir" "$url"
    display_section_header "$GREEN" "figlet font (rowancap) downloaded successfully."
else
    # File already exists
    display_section_header "$ORANGE" "figlet font (rowancap) file already exists in the target directory."
fi

#==

# Get the current directory of the script
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# Check if the current user is root
if [ "$(id -u)" = "0" ]; then
    # If user is root, no need for sudo
    if [ -f "/bin/banner" ]; then
        display_section_header "$ORANGE" "banner has been previously installed."
    else
        cp "$SCRIPT_DIR/banner" /bin/banner
        chmod +x /bin/banner
        display_section_header "$GREEN" "banner has been installed successfully."
    fi
else
    # If user is not root, use sudo
    if [ -f "/bin/banner" ]; then
        display_section_header "$ORANGE" "banner has been previously installed."
    else
        sudo cp "$SCRIPT_DIR/banner" /bin/banner
        sudo chmod +x /bin/banner
        display_section_header "$GREEN" "banner has been installed successfully."
    fi
fi
