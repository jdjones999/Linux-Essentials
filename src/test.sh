#!/bin/bash

# Update package lists
echo "Updating package lists..."

# Fetching and updating package information progress bar
fetch_update_progress() {
    local width=40
    local packages=$(apt list --upgradable 2>/dev/null | grep -c '\[upgradable\]')
    local current=0

    # Determine number of packages
    echo "Total packages to update: $packages"

    # Pre-generated colors for the progress bar
    local colors=("31" "32" "33" "34" "35")  # ANSI color codes for red, green, yellow, blue, magenta

    # Simulate update progress
    while [[ $current -le 100 ]]; do
        printf "\r["
        local progress_width=$((current * width / 100))
        local remaining_width=$((width - progress_width))
        local color_index=$((current % ${#colors[@]}))
        local color=${colors[$color_index]}
        printf "%-${progress_width}s" "" | tr ' ' '=' | sed "s/./\x1b[38;5;${color}m&\x1b[0m/g"
        printf "%$remaining_width""s] %d%%" "" "$current"
        sleep 0.03  # Simulate update progress
        ((current++))
    done
    printf "\n"
}

# Display the progress bar for fetching and updating package information
fetch_update_progress

# Upgrade packages
echo "Upgrading packages..."

# Upgrade each package
upgrade_packages() {
    local packages=$(apt list --upgradable 2>/dev/null | grep -c '\[upgradable\]')
    local current=0
    if [[ $packages -eq 0 ]]; then
        local width=40
        printf "\r["
        printf "%-${width}s" "" | tr ' ' '=' | lolcat
        printf "] %d%%" "100"
        printf "%${width}s" ""
        printf "\n"
    else
        while IFS= read -r package; do
            ((current++))
            local percent=$((current * 100 / packages))
            local width=40
            local progress_width=$((percent * width / 100))
            printf "\r["
            printf "%-${progress_width}s" ""
            printf "%$((width - progress_width))s"
            printf "] %d%%" "$percent%%"
            sleep 0.1
        done < <(sudo apt upgrade --assume-no -y 2>&1) | lolcat
    fi
    printf "\n"
}

# Display the progress bar for upgrading packages
upgrade_packages

echo "Upgrade complete."

# Check if figlet is installed
if ! command -v figlet &> /dev/null; then
    echo "Installing figlet..."
    sudo apt install figlet -y > /dev/null 2>&1
    echo "Figlet has been successfully installed."
fi

# Check if lolcat is installed
if ! command -v lolcat &> /dev/null; then
    echo "Installing lolcat..."
    sudo apt install lolcat -y > /dev/null 2>&1
    echo "Lolcat has been successfully installed."
fi

#========================================================

# Specify the URL of the file to download
url="http://www.figlet.org/fonts/rowancap.flf"

# Specify the target directory
target_dir="/usr/share/figlet"

# Specify the filename
filename="rowancap.flf"

# Check if the file already exists in the target directory
if [ ! -f "$target_dir/$filename" ]; then
    # File doesn't exist, so download it
    echo "Downloading figlet font..."
    sudo wget -P "$target_dir" "$url" > /dev/null 2>&1
    echo "Font downloaded successfully."
else
    echo "Font already exists in the target directory."
fi
