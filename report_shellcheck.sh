#!/bin/bash
# Title: Give a report of shellcheck on most common used system directories.
# Author: Asher Simcha
# _____/\\\\\\\\\________/\\\\\\\\\\\____/\\\________/\\\__/\\\\\\\\\\\\\\\____/\\\\\\\\\_____        
#  ___/\\\\\\\\\\\\\____/\\\/////////\\\_\/\\\_______\/\\\_\/\\\///////////___/\\\///////\\\___       
#   __/\\\/////////\\\__\//\\\______\///__\/\\\_______\/\\\_\/\\\_____________\/\\\_____\/\\\___      
#    _\/\\\_______\/\\\___\////\\\_________\/\\\\\\\\\\\\\\\_\/\\\\\\\\\\\_____\/\\\\\\\\\\\/____     
#     _\/\\\\\\\\\\\\\\\______\////\\\______\/\\\/////////\\\_\/\\\///////______\/\\\//////\\\____    
#      _\/\\\/////////\\\_________\////\\\___\/\\\_______\/\\\_\/\\\_____________\/\\\____\//\\\___   
#       _\/\\\_______\/\\\__/\\\______\//\\\__\/\\\_______\/\\\_\/\\\_____________\/\\\_____\//\\\__  
#        _\/\\\_______\/\\\_\///\\\\\\\\\\\/___\/\\\_______\/\\\_\/\\\\\\\\\\\\\\\_\/\\\______\//\\\_ 
#         _\///________\///____\///////////_____\///________\///__\///////////////__\///________\///__2024
# Additional Authors: ChatGPT
# Additional Authors: 
# Filename: report_shellcheck.sh
# Description: Creates a Report if there are warnings or errors in Script files
# Version: 01.05
# Date: 08-19-2024
# Last_Modified: 08-19-2024
# Last_Modified: 08-20-2024
# Last_Modified: 08-21-2024
# Last_Modified: 08-23-2024
# Last_Modified: 
# Additional_Notes: Creates on the User's Desktop a directory named Report and for each file that 
# Additional_Notes: If any Script needs attention, creates a companion file named FILENAME.txt
# Additional_Notes: Version 1.04 Now only one place to store the REPORT_DIR
# Additional_Notes: Version 1.04 If 2 or more files by the same name are being recorded each file has an additional extension _Count (Numeral Character)
# Additional_Notes: 
# Source: https://github.com/Asher-Simcha/Report_Shellcheck/tree/main
# Additional_Sources: 
# License: The 2-Clause BSD License https://opensource.org/license/BSD-2-Clause
# Additional_Licenses: 
# Credits: Gregory Wienands
# Additional Credits: ChatGPT
# Additional Credits: 
# Article: This tool is for Linux analyzes of your entire system in one pass, generating a detailed report on the condition of each script file if needed. Ideal for system administrators and developers, it ensures that every script is scrutinized for issues, providing an overview of the system's script health.

# Define locations to search for potential BASH scripts
SEARCH_LOCATIONS=("/bin" "/usr/bin" "/usr/local/bin" "/usr/sbin" "/sbin" "$HOME/bin" )

# Directory to store the reports
REPORT_DIR="$HOME/Desktop/Report"

# Create report directory if it doesn't exist
mkdir -p "$REPORT_DIR"
if [[ ! -w "$REPORT_DIR" ]]; then
    printf "Cannot write to %s. Please check permissions.\n" "$REPORT_DIR"
    exit 1
fi
# Function to check if the file is a BASH script and report on it
check_scripts() {
    local file_path
    local first_line
    local report_output
    local REPORT_DIR
    local report_file
    local file
    local count
    file_path="$1"
    REPORT_DIR="$2"
    count=1
    if file "$file_path" | grep -q "text" && [ -x "$file_path" ]; then # The file in question is a Text file and is executable
            # Read the first line to check for bash shebang
            read -r first_line < "$file_path"
            if [[ "$first_line" =~ ^#!.*(bash|sh|ksh|zsh|ash)$ ]]; then
                # Run shellcheck and capture the output
                report_output=$(shellcheck -x "$file_path") # To Report ONLY Critical Error Comment this line out and uncomment the next line.
                # report_output=$(shellcheck -x -S error "$file_path") # To Report only Critical Errors Uncomment this line comment out previous line.
                # Check if the output is not empty
                if [[ -n "$report_output" ]]; then
                    file=$(basename "$file_path")
                    report_file="$REPORT_DIR/$file.txt"
                    if [ -e "$report_file" ]; then
                        report_file="${REPORT_DIR}/${file}_${count}.txt"
                        ((count++))
                    fi
                    printf "report_file: %s\n" "$report_file"
                    printf "file_path: %s\n" "$file_path"
                    # Attempt to write the details and output to a report file
                    if ! {
                        printf "Date: %s\n" "$(date '+%Y-%m-%d %H:%M:%S')"
                        printf "Location: %s\n" "$file_path"
                        printf "Filename: %s\n" "$(basename "$file_path")"
                        printf "Shellcheck Output:\n%s\n" "$report_output"
                    } > "$report_file" 2>/dev/null; then
                        printf "Failed to write report for %s. Permission denied. %s\n" "$file_path" "$report_file"
                        exit 1
                    fi

                fi
            fi
#     else # if you want a very long read out of what else it is doing un-comment out these two lines.
#         printf "Not a text file or is not executable %s\n" "$file_path"
    fi
}
# Export function to use in find command
export -f check_scripts
# Search and process potential script files
for location in "${SEARCH_LOCATIONS[@]}"; do
    if [ -d "$location" ]; then
        find "$location" -type f -exec bash -c 'check_scripts "$1" "$2"' _ {} "$REPORT_DIR" \;
    else
        printf "Directory did not exists: %s" "$location"
    fi
done
printf "Shellcheck analysis complete. Reports are saved in %s.\n" "$REPORT_DIR"
#EOF
