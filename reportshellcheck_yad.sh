#!/bin/bash
# Title: Give a report of shellcheck on most common used system directories. with YAD
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
# Additional_Notes: Creates on the User's Desktop a directory named 
# Additional_Notes: include YAD in it.
# Version: 01.03
# Date: 08-19-2024
# Last_Modified: 08-19-2024
# Last_Modified: 08-20-2024
# Last_Modified: 
# Source: 
# Additional_Sources: 
# License: The 2-Clause BSD License https://opensource.org/license/BSD-2-Clause
# Additional_Licenses: 
# Credits: Gregory Wienands
# Additional Credits: ChatGPT
# Additional Credits: 
# Article: This tool is for Linux analyzes of your entire system in one pass, generating a detailed report on the condition of each script file if needed. Ideal for system administrators and developers, it ensures that every script is scrutinized for issues, providing an overview of the system's script health.

# OPTIONS FOR YAD ARE:
# 
# SEARCH_LOCATIONS
# 
# REPORT_DIR
# 
# DefaultFileBrowser
# 
DEBUG=0
# DEBUG=1

# CompanyName="ashersprograms"
CompanyNameProper="Ashers Programs.com"
# ProgramsName="reportshellcheck_yad.sh"
ProgramsNameProper="Report Shellcheck"
ProgramsIconName="reportshellcheck.png"
WebsiteAbout="https://ashersprograms.com/?program=reportshellcheck"
IconLocation="reportshellcheck.png"
SplashImage="reportshellcheck_large.png"
DisplaySeconds=10
# Define locations to search for potential BASH scripts
SEARCH_LOCATIONS=("/bin" "/sbin" "/usr/bin" "/usr/sbin" "/usr/local/bin" "$HOME/bin" "" "" "")
SEARCH_LOCATIONS_CHANGEABLE=("" "" "" "" "" "" "" "" "")

DesktopMode=1 # this is currently the only mode.

# Directory to store the reports
BASE_DIR="$HOME/Desktop"
REPORTS_NAME="Report"
REPORT_DIR="$BASE_DIR/$REPORTS_NAME"

OpenFileBrowser=""
DefaultFileBrowser=""

EXCLUDE_USE=("FALSE" "FALSE" "FALSE")
EXCLUDE=("" "" "")

# This is for dealing with the updates

# Function to check if the file is a BASH script and report on it
check_scripts() {
    local file_path
    local first_line
    local report_output
    local ReportDir
    local report_file
    local file
    local ThisCount
    local Exclusion1
    local Exclusion2
    local Exclusion3
    file_path="$1"
    ReportDir="$2"
    Exclusion1="$3"
    Exclusion2="$4"
    Exclusion3="$5"
    ThisCount=0
    if [ -n "$Exclusion1" ]; then
        # if exclusion is only a number then add words is not just leave as is.
        if [[ "$Exclusion1" != *"-"* ]]; then
            Exclusion1="--exclude $Exclude1"
        fi
        ((ThisCount++))
    fi
    if [ -n "$Exclusion2" ]; then
        if [[ "$Exclusion2" != *"-"* ]]; then
            Exclusion2="--exclude $Exclude2"
        fi
        
        ((ThisCount++))
    fi
    if [ -n "$Exclusion3" ]; then
        if [[ "$Exclusion3" != *"-"* ]]; then
            Exclusion2="--exclude $Exclude2"
        fi
        ((ThisCount++))
    fi
    if file "$file_path" | grep -q "text" && [ -x "$file_path" ]; then # The file in question is a Text file and is executable
        # Read the first line to check for bash shebang
        read -r first_line < "$file_path"
        if [[ "$first_line" =~ ^#!.*(bash|sh|ksh|zsh|ash)$ ]]; then
            # get rid of the .git/ files that have mistakes
            if [[ "$file_path" != *".git/"* ]]; then
                # Run shellcheck and capture the output
                case $ThisCount in
                    0)
                        report_output=$(shellcheck -x "$file_path")
                        ;;
                    1)
                        report_output=$(shellcheck "$Exclusion1" -x "$file_path")
                        ;;
                    2)
                        report_output=$(shellcheck "$Exclusion1" "$Exclusion2" -x "$file_path")
                        ;;
                    3)
                        report_output=$(shellcheck "$Exclusion1" "$Exclusion2" "$Exclusion3" -x "$file_path")
                        ;;
                esac

                report_output=$(shellcheck -x -S error "$file_path")
                # Check if the output is not empty
                if [[ -n "$report_output" ]]; then
                    file=$(basename "$file_path")
                    report_file="$ReportDir/$file.txt"
                    printf "report_file: %s" "$report_file"
                    printf " file_path: %s\n" "$file_path"

                    # Attempt to write the details and output to a report file
                    if ! {
                        printf "Date: %s\n" "$(date '+%Y-%m-%d %H:%M:%S')"
                        printf "Location: %s\n" "$file_path"
                        printf "Filename: %s\n" "$(basename "$file_path")"
                        printf "Shellcheck Output:\n%s\n" "$report_output"
                    } > "$report_file" 2>/dev/null; then
                        printf "Failed to write report for %s. Permission denied. %s\n" "$file_path" "$report_file"
                        exit 3
                    fi

                fi
            fi
        fi
    fi
}

function Check_File_System(){
    [ "$DEBUG" -eq 1 ] && printf "Check_File_System line: %i\n" "$LINENO"
    if [ -e "source/display_splash.sh" ]; then
        source "source/display_splash.sh"
    else
        printf "Could not find source file. Exiting\n"
        exit 2
    fi
    DefaultFileBrowser=$(FindDefaultWebBrowser)
    if [ -x "$DefaultFileBrowser" ]; then OpenFileBrowser="TRUE"; else OpenFileBrowser="FALSE"; fi
    
    if [ ! -e "$IconLocation" ]; then
        if [ -e "reportshellcheck.png" ]; then
            IconLocation=""
        elif [ -e "img/reportshellcheck.png" ]; then
            IconLocation="img/reportshellcheck.png"
        else
            IconLocation=""
        fi
    fi
    if [ ! -e "$SplashImage" ]; then
        if [ -e "reportshellcheck_large.png" ]; then
            SplashImage="reportshellcheck_large.png"
        elif [ -e "img/reportshellcheck_large.png" ]; then
            SplashImage="img/reportshellcheck_large.png"
        elif [ -e "$IconLocation" ]; then
            SplashImage="$IconLocation"
        else
            SplashImage=""
        fi
    fi
}

function CreateDirectory(){
    # Create report directory if it doesn't exist
    local ReportDir
    ReportDir="$1"
    mkdir -p "$ReportDir"
    if [[ -w "$ReportDir" ]]; then
        printf "Created directory: %s. " "$ReportDir"
        return 0
    else
        printf "Cannot write to %s. Please check permissions.\n" "$ReportDir"
        return 1
    fi
}

function FindDefaultWebBrowser(){
    # ok so this is a little bit excessive but it works.
    local DefaultFileBrowser
    if [ -e "/usr/bin/xdg-open" ]; then
        DefaultFileBrowser="/usr/bin/xdg-open"
    elif [ -e "/usr/bin/thunar" ]; then # Default XFCE
        DefaultFileBrowser="/usr/bin/thunar"
    elif [ -e "/usr/bin/dolphin" ]; then # Default KDE
        DefaultFileBrowser="/usr/bin/dolphin"
    elif [ -e "/usr/bin/pcmanfm" ]; then
        DefaultFileBrowser="/usr/bin/pcmanfm"
    elif [ -e "/usr/bin/spacefm" ]; then
        DefaultFileBrowser="/usr/bin/spacefm"
    else
        DefaultFileBrowser=""
    fi
    printf "%s" "$DefaultFileBrowser"
}

function DesktopAbout(){
    xdg-open "$WebsiteAbout"
    DesktopReportShellcheck ""
}

function DesktopReportShellcheck(){
    local CountArray
    local CountExclude
    local Browser
    local CheckBoxExtra
    local ErrorMessage
    local HomeDir
    local MessageError
    local Pass
    local ReportDir
    local Run
    local RunTheProgram
    local text
    local yad_results
    local Check1
    local Check2
    local Check3
    local Check4
    local Check5
    local Check6
    local Check7
    local Check8
    local Check9
    local SearchLoc1
    local SearchLoc2
    local SearchLoc3
    local SearchLoc4
    local SearchLoc5
    local SearchLoc6
    local SearchLoc7
    local SearchLoc8
    local SearchLoc9
    local ExcludeCHK1
    local ExcludeCHK2
    local ExcludeCHK3
    local Exclude1
    local Exclude2
    local Exclude3
    ErrorMessage="$1"
    RunTheProgram=0
    ExcludeCHK1="${EXCLUDE_USE[0]}"
    ExcludeCHK2="${EXCLUDE_USE[1]}"
    ExcludeCHK3="${EXCLUDE_USE[2]}"
    Exclude1="${EXCLUDE[0]}"
    Exclude2="${EXCLUDE[1]}"
    Exclude3="${EXCLUDE[2]}"
    CheckBoxExtra=0
    CountArray=0
    CountExclude=0
    
    text+="$ProgramsNameProper by $CompanyNameProper"
    text+="\n"
    text+="Add your own directories to have your scripts double checked with one of the best tools in the business!\n"
    text+="\n"
    text+="You can add exclusions or any number of exceptions here are a few examples\n"
    text+="   To only show errors and no warnings type:\n"
    text+="     -S error\n"
    text+="   If you want to suppress the warning of unused Variables type:\n"
    text+="     SC2034\n"
    text+="Type of Scripts that this program will analyzes are: ash, bash, ksh, sh, and zsh\n"
    
    if [ -n "$ErrorMessage" ]; then # Error being reported
        text="The Application has issued, some errors, Please resolve these issues."
        text="$1"
    fi
    text+="For more information check out: $CompanyNameProper"
    Run=0
    ReportDir="$REPORTS_NAME"
    SearchLoc1="${SEARCH_LOCATIONS[0]}"  
    SearchLoc2="${SEARCH_LOCATIONS[1]}"  
    SearchLoc3="${SEARCH_LOCATIONS[2]}"
    SearchLoc4="${SEARCH_LOCATIONS[3]}"
    SearchLoc5="${SEARCH_LOCATIONS[4]}"
    SearchLoc6="${SEARCH_LOCATIONS[5]}"
    SearchLoc7="${SEARCH_LOCATIONS[6]}"
    SearchLoc8="${SEARCH_LOCATIONS[7]}"
    SearchLoc9="${SEARCH_LOCATIONS[8]}"
    Check1="TRUE"
    Check2="TRUE"
    Check3="TRUE"
    Check4="TRUE"
    Check5="TRUE"
    Check6="FALSE"
    Check7="FALSE"
    Check8="FALSE"
    Check9="FALSE"
    OpenFileBrowser="TRUE"
### Using Grid Layout with Columns
yad_results=$(yad \
    --form \
    --center \
    --window-icon="$IconLocation" \
    --title="Examples by: $CompanyNameProper" \
    --width=1250 \
    --height=300 \
    --columns=3 \
    --text="$text" \
    --field="Directory Name and Location:" "$ReportDir" \
    --field="Open File Browser:CHK" "$OpenFileBrowser" \
    --field="Default File Browser:" "$DefaultFileBrowser" \
    --field="1) Search Location 1:CHK" "$Check1" \
    --field="1) Location:RO" "$SearchLoc1" \
    --field="2) Search Location 2:CHK" "$Check2" \
    --field="2) Location:RO" "$SearchLoc2" \
    --field="3) Search Location 3:CHK" "$Check3" \
    --field="3) Location:RO" "$SearchLoc3" \
    --field="4) Search Location 4:CHK" "$Check4" \
    --field="4) Location:RO" "$SearchLoc4" \
    --field="5) Search Location 5:CHK" "$Check5" \
    --field="5) Location:RO" "$SearchLoc5" \
    --field="6) Search Location 6:CHK" "$Check6" \
    --field="6) Location:RO" "$SearchLoc6" \
    --field="7) Search Location 7:CHK" "$Check7" \
    --field="7) Location:" "$SearchLoc7" \
    --field="8) Search Location 8:CHK" "$Check8" \
    --field="8) Location:" "$SearchLoc8" \
    --field="9) Search Location 9:CHK" "$Check9" \
    --field="9) Location:" "$SearchLoc9" \
    --field="1a) Activate Exclude:CHK" "$ExcludeCHK1" \
    --field="1a) Exclude:" "$Exclude1" \
    --field="2a) Activate Exclude:CHK" "$ExcludeCHK2" \
    --field="2a) Exclude:" "$Exclude2" \
    --field="3a) Activate Exclude:CHK" "$ExcludeCHK3" \
    --field="3a) Exclude:" "$Exclude3" \
    --button="About:3" \
    --button="Quit:1" \
    --button="Run Program:0")
    results="$?" 
    case $results in
        1) # Quit
            exit 0
            ;;
        3) # About
            DesktopAbout
            ;;
        *) # Run the program
            Run=1
            ;;
    esac
    Pass=1 # 1 will pass 0 does not pass the test.
    local RunBrowser
    if [ "$Run" -eq 1 ]; then
        IFS='|' read -r ReportDir RunBrowser Browser Check1 SearchLoc1 Check2 SearchLoc2 Check3 SearchLoc3 Check4 SearchLoc4 Check5 SearchLoc5 Check6 SearchLoc6 Check7 SearchLoc7 cb8 SearchLoc8 Check9 SearchLoc9 ExcludeCHK1 Exclude1 ExcludeCHK2 Exclude2 ExcludeCHK3 Exclude3 <<< "$yad_results"
        if [ "$DEBUG" -eq 1 ]; then
            printf "\nDebug Full Report on Variables\n\n"
            printf "ReportDir: %s line: %i\n" "$ReportDir" "$LINENO"
            printf "RunBrowser: %s line: %i\n" "$RunBrowser" "$LINENO"
            printf "Browser: %s line: %i\n" "$Browser" "$LINENO"
            printf "Check1: %s line: %i\n" "$Check1" "$LINENO"
            printf "SearchLoc1: %s line: %i\n" "$SearchLoc1" "$LINENO"
            printf "Check2: %s line: %i\n" "$Check2" "$LINENO"
            printf "SearchLoc2: %s line: %i\n" "$SearchLoc2" "$LINENO"
            printf "Check3: %s line: %i\n" "$Check3" "$LINENO"
            printf "SearchLoc3: %s line: %i\n" "$SearchLoc3" "$LINENO"
            printf "Check4: %s line: %i\n" "$Check4" "$LINENO"
            printf "SearchLoc4: %s line: %i\n" "$SearchLoc4" "$LINENO"
            printf "Check5: %s line: %i\n" "$Check5" "$LINENO"
            printf "SearchLoc5: %s line: %i\n" "$SearchLoc5" "$LINENO"
            printf "Check6: %s line: %i\n" "$Check6" "$LINENO"
            printf "SearchLoc6: %s line: %i\n" "$SearchLoc7" "$LINENO"
            printf "Check7: %s line: %i\n" "$Check7" "$LINENO"
            printf "SearchLoc7: %s line: %i\n" "$SearchLoc7" "$LINENO"
            printf "cb8: %s line: %i\n" "$cb8" "$LINENO"
            printf "SearchLoc8: %s line: %i\n" "$SearchLoc8" "$LINENO"
            printf "Check9: %s line: %i\n" "$Check9" "$LINENO"
            printf "SearchLoc9: %s line: %i\n" "$SearchLoc9" "$LINENO"
            printf "ExcludeCHK1: %s line: %i\n" "$ExcludeCHK1" "$LINENO"
            printf "Exclude1: %s line: %i\n" "$Exclude1" "$LINENO"
            printf "ExcludeCHK2: %s line: %i\n" "$ExcludeCHK2" "$LINENO"
            printf "Exclude2: %s line: %i\n" "$Exclude2" "$LINENO"
            printf "ExcludeCHK3: %s line: %i\n" "$ExcludeCHK3" "$LINENO"
            printf "Exclude3: %s line: %i\n" "$Exclude3" "$LINENO"
            printf "\nDebug End of Full Report on Variables\n\n"
        fi
        if [ -n "$ReportDir" ]; then
            [ "$DEBUG" -eq 1 ] && printf "ReportDir %s line: %i\n" "$ReportDir" "$LINENO"
            if [[ -n "$ReportDir" && $ReportDir =~ ^[a-zA-Z0-9._-]+$ ]]; then
                if [ -d "$BASE_DIR" ]; then
                    HomeDir="$BASE_DIR"
                else
                    HomeDir="$HOME"
                fi
                REPORT_DIR="$HomeDir/$ReportDir"
            else
                MessageError+="The Report Name Must be a valid directory name.\n"
                Pass=0
            fi
        fi
        if [[ "$RunBrowser" == "TRUE" ]]; then
            if [ -n "$Browser" ]; then
                [ "$DEBUG" -eq 1 ] && printf "Browser: %s line: %i\n" "$Browser" "$LINENO"
                if [ -x "$Browser" ]; then
                    DefaultFileBrowser="$Browser"
                else
                    MessageError+="The Browser that you choose has an issue\n"
                    Pass=0
                fi
            else
                MessageError+="Please fill out the Default file browser to use.\n"
                Pass=0
            fi
        else
            DefaultFileBrowser=""
        fi
        if [[ "$Check1" == "TRUE"  ]]; then
            if [ -n "$SearchLoc1" ]; then
                if [ -d "$SearchLoc1" ]; then
                    SEARCH_LOCATIONS_CHANGEABLE[$CountArray]="$SearchLoc1"
                    ((CountArray++))
                else
                    MessageError+="Location 1 is not a directory or does not exists.\n"
                    Pass=0
                fi
            else
                MessageError+="You clicked Search Location 1 but the line was blank.\n"
                Pass=0
                CheckBoxExtra=1
            fi
        fi
        if [[ "$Check2" == "TRUE"  ]]; then
            if [ -n "$SearchLoc2" ]; then
                if [ -d "$SearchLoc2" ]; then
                    SEARCH_LOCATIONS_CHANGEABLE[$CountArray]="$SearchLoc2"
                    ((CountArray++))
                else
                    MessageError+="Location 2 is not a directory or does not exists.\n"
                    Pass=0
                fi
            else
                MessageError+="You clicked Search Location 2 but the line was blank.\n"
                Pass=0
                CheckBoxExtra=1
            fi
        fi
        if [[ "$Check3" == "TRUE"  ]]; then
            if [ -n "$SearchLoc3" ]; then
                if [ -d "$SearchLoc3" ]; then
                    SEARCH_LOCATIONS_CHANGEABLE[$CountArray]="$SearchLoc3"
                    ((CountArray++))
                else
                    MessageError+="Location 3 is not a directory or does not exists.\n"
                    Pass=0
                fi
            else
                MessageError+="You clicked Search Location 3 but the line was blank.\n"
                Pass=0
                CheckBoxExtra=1
                SEARCH_LOCATIONS[2]=""
            fi
        fi
        if [[ "$Check4" == "TRUE"  ]]; then
            if [ -n "$SearchLoc4" ]; then
                if [ -d "$SearchLoc4" ]; then
                SEARCH_LOCATIONS_CHANGEABLE[$CountArray]="$SearchLoc4"
                ((CountArray++))
                else
                    MessageError+="Location 4 is not a directory or does not exists.\n"
                    Pass=0
                fi
            else
                MessageError+="You clicked Search Location 4 but the line was blank.\n"
                Pass=0
                CheckBoxExtra=1
            fi
        fi
        if [[ "$Check5" == "TRUE"  ]]; then
            if [ -n "$SearchLoc5" ]; then
                if [ -d "$SearchLoc5" ]; then
                SEARCH_LOCATIONS_CHANGEABLE[$CountArray]="$SearchLoc5"
                ((CountArray++))
                else
                    MessageError+="Location 5 is not a directory or does not exists.\n"
                    Pass=0
                fi
            else
                MessageError+="You clicked Search Location 5 but the line was blank.\n"
                Pass=0
                CheckBoxExtra=1
            fi
        fi
        if [[ "$Check6" == "TRUE"  ]]; then
            if [ -n "$SearchLoc6" ]; then
                if [ -d "$SearchLoc6" ]; then
                SEARCH_LOCATIONS_CHANGEABLE[$CountArray]="$SearchLoc6"
                ((CountArray++))
                else
                    MessageError+="Location 6 is not a directory or does not exists.\n"
                    Pass=0
                fi
            else
                MessageError+="You clicked Search Location 6 but the line was blank.\n"
                Pass=0
                CheckBoxExtra=1
            fi
        fi
        if [[ "$Check7" == "TRUE"  ]]; then
            if [ -n "$SearchLoc7" ]; then
                if [ -d "$SearchLoc7" ]; then
                SEARCH_LOCATIONS_CHANGEABLE[$CountArray]="$SearchLoc7"
                ((CountArray++))
                else
                    MessageError+="Location 7 is not a directory or does not exists.\n"
                    Pass=0
                fi
            else
                MessageError+="You clicked Search Location 7 but the line was blank.\n"
                Pass=0
                CheckBoxExtra=1
            fi
        fi
        if [[ "$cb8" == "TRUE"  ]]; then
            if [ -n "$SearchLoc8" ]; then
                if [ -d "$SearchLoc8" ]; then
                SEARCH_LOCATIONS_CHANGEABLE[$CountArray]="$SearchLoc8"
                ((CountArray++))
                else
                    MessageError+="Location 8 is not a directory or does not exists.\n"
                    Pass=0
                fi
            else
                MessageError+="You clicked Search Location 8 but the line was blank.\n"
                Pass=0
                CheckBoxExtra=1
            fi
        fi
        if [[ "$Check9" == "TRUE"  ]]; then
            if [ -n "$SearchLoc9" ]; then
                if [ -d "$SearchLoc9" ]; then
                SEARCH_LOCATIONS_CHANGEABLE[$CountArray]="$SearchLoc9"
                else
                    MessageError+="Location 9 is not a directory or does not exists.\n"
                    Pass=0
                fi
            else
                MessageError+="You clicked Search Location 9 but the line was blank.\n"
                Pass=0
                CheckBoxExtra=1
            fi
        fi
        if [ "$CheckBoxExtra" -eq 1 ]; then
            MessageError+="\n***Please check only your intended search directories that are filled out\n."
        fi
        #1 Exclude Checkbox
        if [[ "$ExcludeCHK1" == "TRUE" ]]; then
            if [ -n "$Exclude1" ]; then
                EXCLUDE_USE[$CountExclude]="TRUE"
                EXCLUDE[$CountExclude]="$Exclude1"
                ((CountExclude++))
            else
                Pass=0
                MessageError+="# 1a) You indicated that you wanted to use an exclusion but non was given\n"
                EXCLUDE_USE[0]="FALSE"
                EXCLUDE[0]=""
            fi
        fi 
        #2 Exclude Checkbox
        if [[ "$ExcludeCHK2" == "TRUE" ]]; then
            if [ -n "$Exclude2" ]; then
                EXCLUDE_USE[$CountExclude]="TRUE"
                EXCLUDE[$CountExclude]="$Exclude2"
                ((CountExclude++))
            else
                Pass=0
                MessageError+="# 2a) You indicated that you wanted to use an exclusion but non was given\n"
                EXCLUDE_USE[1]="FALSE"
                EXCLUDE[1]=""
            fi
        fi 
        #3 Exclude Checkbox
        if [[ "$ExcludeCHK3" == "TRUE" ]]; then
            if [ -n "$Exclude3" ]; then
                EXCLUDE_USE[$CountExclude]="TRUE"
                EXCLUDE[$CountExclude]="$Exclude3"
                ((CountExclude++))
            else
                Pass=0
                MessageError+="# 3a) You indicated that you wanted to use an exclusion but non was given\n"
                EXCLUDE_USE[2]="FALSE"
                EXCLUDE[2]=""
            fi
        fi 
        if [ "$Pass" -eq 0 ]; then
            # Report Errors that have occured
            DesktopReportShellcheck "$MessageError"
        else
            # Call the function now with the parameters.
            [ "$DEBUG" -eq 1 ] && printf "everything passed line: %i\n" "$LINENO"
            RunTheProgram=1
        fi
    fi # end of if Run=1
    if [ "$RunTheProgram" -eq 1 ]; then
        if [ "$DEBUG" -eq 1 ]; then
            printf "Report Directory will be: %s\n" "$REPORT_DIR"
            if [ "${#SEARCH_LOCATIONS_CHANGEABLE[@]}" -gt 0 ]; then
                for location in "${SEARCH_LOCATIONS_CHANGEABLE[@]}"; do
                    printf "Search Location: %s\n" "$location"
                done
            else 
                printf "No directories to search\n"
            fi
            printf "open the File Browser: %s\n" "$OpenFileBrowser"
            if [ -x "$DefaultFileBrowser" ]; then
                printf "default file browser is: %s\n" "$DefaultFileBrowser"
            else
                printf "no default file browser found.\n"
            fi
            

            if [[ "${EXCLUDE_USE[0]}" == "TRUE" ]]; then
                if [ -n "${EXCLUDE[0]}" ]; then
                    printf "Exclusion 1 is: %s\n" "${EXCLUDE[0]}"
                else
                    printf "EXCLUDE 1 is NULL, not good. line: %i\n" "$LINENO"
                fi
            else
                printf "Don't use an exclude\n"
            fi
            if [[ "${EXCLUDE_USE[1]}" == "TRUE" ]]; then
                if [ -n "${EXCLUDE[1]}" ]; then
                    printf "Exclusion 2 is: %s\n" "${EXCLUDE[1]}"
                else
                    printf "EXCLUDE 2 is NULL, not good. line: %i\n" "$LINENO"
                fi            
            else
                printf "Don't use an exclude\n"
            fi
            if [[ "${EXCLUDE_USE[2]}" == "TRUE" ]]; then
                if [ -n "${EXCLUDE[2]}" ]; then
                    printf "Exclusion 3 is: %s\n" "${EXCLUDE[2]}"
                else
                    printf "EXCLUDE 3 is NULL, not good. line: %i\n" "$LINENO"
                fi            
            else
                printf "Don't use an exclude\n"
            fi
        fi
        SearchScripts
    fi
}

function SearchScripts(){
    # Search and process potential script files
    if CreateDirectory "$REPORT_DIR"; then
        Display_Splash "$SplashImage" "$DisplaySeconds" "$IconLocation" "$CompanyNameProper" "$ProgramsNameProper"
        if [ -x "$DefaultFileBrowser" ]; then
            $DefaultFileBrowser "$REPORT_DIR" >/dev/null 2>&1
        fi
        for location in "${SEARCH_LOCATIONS_CHANGEABLE[@]}"; do
            if [ -d "$location" ]; then
                find "$location" -type f -exec bash -c 'check_scripts "$1" "$2" "$3"' _ {} "$REPORT_DIR" "${EXCLUDE[0]}" "${EXCLUDE[1]}" "${EXCLUDE[2]}" \;
            else
                printf "Directory did not exists: %s\n" "$location" 
            fi
        done
        printf "Shellcheck analysis complete. Reports are saved in %s.\n" "$REPORT_DIR"
        exit 0
    else
        [ "$DEBUG" -eq 1 ] && printf "Count not create the directory: REPORT_DIR %s line: %i\n" "$REPORT_DIR" "$LINENO"
        printf "Count not create the directory: %s exiting the program.\n" "$REPORT_DIR"
        exit 3
    fi
}

function main(){
    if [ "$DesktopMode" -eq 1 ]; then
        [ "$DEBUG" -eq 1 ] && printf "Desktop Mode ON line: %i\n" "$LINENO"
        Check_File_System
        DesktopReportShellcheck ""
    else
        [ "$DEBUG" -eq 1 ] && printf "Desktop Mode OFF line: %i\n" "$LINENO"
    fi
}
# Export function to use in find command
export -f check_scripts
main
#EOF
