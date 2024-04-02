#!/bin/bash

# Function to convert HEX to ANSI color code
convert_hex_to_ansi() {
    local hex_code="${1:-#FF0000}"  # Default to "#FF0000" if hex_code is empty or not provided
    hex_code="${hex_code#"#"}"  # Remove the '#' from the HEX code

    # Convert HEX to RGB
    local r=$(printf "%d" 0x${hex_code:0:2})
    local g=$(printf "%d" 0x${hex_code:2:2})
    local b=$(printf "%d" 0x${hex_code:4:2})

    # Convert RGB to ANSI color code
    local ansi_code="\033[38;2;${r};${g};${b}m"
    echo "$ansi_code"
}

# Prompt for input HEX code with default value
read -p "Enter HEX code [default: #FF0000]: " hex_code
hex_code="${hex_code:-#FF0000}"  # Default to "#FF0000" if hex_code is empty

# Convert HEX to ANSI color code
ansi_color=$(convert_hex_to_ansi "$hex_code")

# Define color variables
BLUE="${ansi_color}"

# Prompt for color label with default value
read -p "Enter color label [default: RED]: " color_label
color_label="${color_label:-RED}"  # Default to "RED" if color_label is empty

# Output the result
echo "${color_label}='${ansi_color}'"

# Print "Hello World" in the specified color
echo -e "${ansi_color}Hello World\033[0m"

#================[ This was rough!!]================
# EXAMPLE: Using predefined color variables
color_label_value="${!color_label}"  # Getting the value of the color label variable

# Define the ANSI escape sequence for resetting the color and the double quote
reset_color='\\033[0m"'

# Concatenate the color label value, "Hello World", and the reset_color variable
result="\"\${${color_label}}Hello World${reset_color}"

# Print the result
echo -e "${result}"
