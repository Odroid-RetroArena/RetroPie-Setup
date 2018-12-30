#!/usr/bin/env bash

# This file is part of The-RA Project
#
# The The-RA Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#

rp_module_id="fancontrol"
rp_module_desc="Change the fan settings to control cooling and fan noise."
rp_module_section="config"

function gui_fancontrol() {
    local cmd=(dialog --backtitle "$__backtitle" --menu "Fan Control" 22 86 16)
    local options=(
        1 "Fan Control 1 - Default"
        2 "Fan Control 2 - Medium"
        3 "Fan Control 3 - Aggressive"
    )
    local choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
    if [[ -n "$choice" ]]; then
        case "$choice" in
            1)
                source /home/pigaming/RetroPie/settingsmenu/fancontrol/fan1-default.sh
                printMsgs "dialog" "Fan is now restored to the factory Odroid settings."
                ;;
            2)
                source /home/pigaming/RetroPie/settingsmenu/fancontrol/fan2-medium.sh
                printMsgs "dialog" "Fan is now set to the HIGHER COOLING RATE than the factory Odroid settings.\n\nNOTE: PERFORM AT YOUR OWN RISK. NO IMPLIED WARRANTIES."
                ;;
            3)
                source /home/pigaming/RetroPie/settingsmenu/fancontrol/fan3-aggressive.sh
                printMsgs "dialog" "Fan is now set to the most AGGRESSIVE COOLING RATE than the factory Odroid settings. The fan will become noticeably loud.\n\nNOTE: PERFORM AT YOUR OWN RISK. NO IMPLIED WARRANTIES."
                ;;
        esac
    fi
}
