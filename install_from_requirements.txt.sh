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

    display_section_header "$GREEN" "Installation complete."
else
    display_section_header "$RED" "Error: requirements.txt file not found."
fi
