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
#===============================[ Install Updates & Upgrades ]===============================
# Check if the user is root or can run sudo
if [ "$(id -u)" -ne 0 ] && ! sudo -v >/dev/null 2>&1; then
    echo "This script must be run as root or with sudo privileges."
    exit 1
fi

# Update package lists
echo "Updating package lists..."
if [ "$(id -u)" -eq 0 ]; then
    apt update -y
else
    sudo apt update -y
fi

# Upgrade installed packages
echo "Upgrading installed packages..."
if [ "$(id -u)" -eq 0 ]; then
    apt upgrade -y
else
    sudo apt upgrade -y
fi
#===============================[ Install form requirements.txt ]===============================
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
#===============================[ Install (Cockpit) ]===============================
# Function to install Cockpit using apt
install_cockpit() {
    local codename=$(grep VERSION_CODENAME /etc/os-release | cut -d'=' -f2)
    sudo apt update
    sudo apt install -t ${codename}-backports cockpit -y
}

# Check if script is run as root or with sudo privileges
if [ "$EUID" -eq 0 ]; then
    install_cockpit
else
    echo "This script requires root privileges. Running with sudo..."
    sudo -E bash -c "$(declare -f install_cockpit); install_cockpit"
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
        sudo chmod +x /bin/search # make an executable
        display_section_header "$GREEN" "Search has been installed successfully."
    fi
fi
# 1. Installing "figlet & lolcat", downloading the font for figlet.
#======================/ Figlet & Lolcat Install /======================

# Check if figlet is installed
if ! command -v figlet &> /dev/null; then
    display_section_header "Installing figlet..."
    sudo apt install figlet -y > /dev/null 2>&1
    display_section_header "Figlet has been successfully installed."
fi

# Check if lolcat is installed
if ! command -v lolcat &> /dev/null; then
    display_section_header "Installing lolcat..."
    sudo apt install lolcat -y > /dev/null 2>&1
    display_section_header "Lolcat has been successfully installed."
fi

#======================/ Download figlet font /======================

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
#======================[ Curl Install ]======================
# 2. Installing curl

# Check if figlet is installed
if ! command -v curl &> /dev/null; then
    display_section_header "Installing curl..."
    sudo apt install curl -y > /dev/null 2>&1
    display_section_header "Curl has been successfully installed."
fi
#======================[ Banner move to /bin/ ]======================

# Get the current directory of the script
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# Check if the current user is root
if [ "$(id -u)" = "0" ]; then
    # If user is root, no need for sudo
    if [ -f "/bin/banner" ]; then
        display_section_header "$ORANGE" "banner has been previously installed."
    else
        cp "$SCRIPT_DIR/banner" /bin/banner
        chmod +x /bin/banner # make an executable
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
#======================[ change_banner move to /bin/ ]======================

# Get the current directory of the script
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# Check if the current user is root
if [ "$(id -u)" = "0" ]; then
    # If user is root, no need for sudo
    if [ -f "/bin/change_banner" ]; then
        display_section_header "$ORANGE" "change_banner has been previously installed."
    else
        cp "$SCRIPT_DIR/change_banner" /bin/change_banner
        chmod +x /bin/change_banner # make an executable
        display_section_header "$GREEN" "change_banner has been installed successfully."
    fi
else
    # If user is not root, use sudo
    if [ -f "/bin/change_banner" ]; then
        display_section_header "$ORANGE" "change_banner has been previously installed."
    else
        sudo cp "$SCRIPT_DIR/change_banner" /bin/change_banner
        sudo chmod +x /bin/change_banner
        display_section_header "$GREEN" "change_banner has been installed successfully."
    fi
fi
#==
touch banner.conf
echo "neoconn" > banner.conf

# Define the source and destination paths
source_path="banner.conf"
destination_path="/etc/banner.conf"

# Check if the user is root
if [ "$(id -u)" -eq 0 ]; then
    # If the user is root, move the file directly
    mv "$source_path" "$destination_path"
    echo "File moved to $destination_path"
else
    # If not root, check if sudo is available
    if [ -x "$(command -v sudo)" ]; then
        # If sudo is available, use it to move the file
        sudo mv "$source_path" "$destination_path"
        echo "File moved to $destination_path using sudo"
    else
        # If sudo is not available, exit with an error message
        echo "Error: sudo is not available. Please run this script as root or with sudo."
        exit 1
    fi
fi

#======================[ **Add text to last row ~/.bashrc ]======================
# To add text to the last row
echo "banner" >> ~/.bashrc
# Add comment for "change_banner" --here--
# change_banner # Command to change "banner"
banner
