#!/bin/bash

# Prompt for input HEX code
read -p "Enter HEX code: " hex_code

# Remove the '#' from the HEX code
hex_code="${hex_code#"#"}"

# Convert HEX to RGB
r=$(printf "%d" 0x${hex_code:0:2})
g=$(printf "%d" 0x${hex_code:2:2})
b=$(printf "%d" 0x${hex_code:4:2})

# Convert RGB to ANSI color code
ansi_code="\033[38;2;${r};${g};${b}m"

# Prompt for color label
read -p "Enter color label: " color_label

# Output the result
echo "${color_label}='${ansi_code}'"

# Print "Hello World" in the specified color
echo -e "${ansi_code}Hello World\033[0m"
