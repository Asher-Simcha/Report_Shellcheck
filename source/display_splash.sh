#!/bin/bash
# Title: Displays a image as a splash screen to the Linux Desktop
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
# Filename: display_splash.sh
# Description: Splash Screen for an Application.
# Version: 01.01
# Date: 08-21-2024
# Last_Modified: 08-21-2024
# Last_Modified: 
# Additional_Notes: 
# Source: 
# Additional_Sources: 
# License: All Right Reserved 2024 
# Additional_Licenses: 
# Credits: 
# Additional Credits: 
# Additional Credits: 
# Audio_Location: 
# Location_of_the_Video: 
# Embed_YouTube: 
# Website_For_Video: 
# Start_Time: 
# Parent_File: ...
# Sibling_File: display_splash.sh
# Linkable: 1
# Display_Links: 1
# Display_Code: 1
# Visible: 1
# Article: 

# options: 
# Display_Splash "/image/location.png" "" "" "" ""
# Display_Splash "/image/location.png" "7" "" "" ""
# Display_Splash "/image/location.png" "7" "/icon/location.png" "Company Name" "Applications Name"

function Display_Splash() {
    local ProgramsName
    local CompanyNameProper
    local Image
    local Icon
    local Timeout
    Image="$1"
    Timeout="$2"
    Icon="$3"
    CompanyNameProper="$4"
    ProgramsName="$5"
    if [ -z "$Image" ]; then # #1
        return 1
    fi
    if [ -z "$Timeout" ]; then # #2
        Timeout=7
    fi
    if [ -z "$Icon" ]; then # #3
        Icon="$Image"
    fi
    if [ -z "$CompanyNameProper" ]; then # #4
        CompanyNameProper="Ashers Programs.com"
    fi
    if [ -z "$ProgramsName" ]; then # #5
        ProgramsName="Always On Top"
    fi
    if [ -e "/usr/bin/splash" ]; then
        splash -d "$Timeout" -f "$Image" > /dev/null 2>&1 &
        sleep 2 && Always_On_Top "splash" & 
    else
        yad --picture \
        --window-icon="$Icon" \
        --title="$ProgramsName by: $CompanyNameProper" \
        --filename="$Image" \
        --geometry="800x600+100+100" \
        --on-top \
        --no-buttons \
        --timeout="$Timeout" \
        --center \
        &
    fi
}

function Always_On_Top(){
    [ "$DEBUG" -eq 1 ] && printf "function Always_On_Top line: %i\n" "$LINENO"
    local ProgramOnTop
    local WindowId
    ProgramOnTop="$1"
    WindowId=$(wmctrl -l | grep "$ProgramOnTop" | awk '{print $1}')
    if [ -n "$WindowId" ]; then wmctrl -i -r "$WindowId" -b add,above; fi
}
#EOF
