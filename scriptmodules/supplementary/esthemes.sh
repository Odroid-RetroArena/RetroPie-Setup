#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="esthemes"
rp_module_desc="Install themes for Emulation Station"
rp_module_section="config"

function depends_esthemes() {
    if isPlatform "x11"; then
        getDepends feh
    else
        getDepends fbi
    fi
}

function install_theme_esthemes() {
    local theme="$1"
    local repo="$2"
    if [[ -z "$repo" ]]; then
        repo="Retro-Arena"
    fi
    if [[ -z "$theme" ]]; then
        theme="es-showcase"
        repo="Retro-Arena"
    fi
    mkdir -p "/etc/emulationstation/themes"
    gitPullOrClone "/etc/emulationstation/themes/$theme" "https://github.com/$repo/$theme.git"
}

function uninstall_theme_esthemes() {
    local theme="$1"
    if [[ -d "/etc/emulationstation/themes/$theme" ]]; then
        rm -rf "/etc/emulationstation/themes/$theme"
    fi
}

function gui_esthemes() {
    local themes=(
        'Retro-Arena es-showcase'
        'Retro-Arena es-unified'
    )
    while true; do
        local theme
        local installed_themes=()
        local repo
        local options=()
        local status=()
        local default

        local gallerydir="/etc/emulationstation/es-theme-gallery"
        if [[ -d "$gallerydir" ]]; then
            status+=("i")
            options+=(G "View or Update Theme Gallery")
        else
            status+=("n")
            options+=(G "Download Theme Gallery")
        fi

        options+=(U "Update all installed themes")

        local i=1
        for theme in "${themes[@]}"; do
            theme=($theme)
            repo="${theme[0]}"
            theme="${theme[1]}"
            if [[ -d "/etc/emulationstation/themes/$theme" ]]; then
                status+=("i")
                options+=("$i" "Update or Uninstall $repo/$theme (installed)")
                installed_themes+=("$theme $repo")
            else
                status+=("n")
                options+=("$i" "Install $repo/$theme (not installed)")
            fi
            ((i++))
        done
        local cmd=(dialog --default-item "$default" --backtitle "$__backtitle" --menu "Choose an option" 22 76 16)
        local choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
        default="$choice"
        [[ -z "$choice" ]] && break
        case "$choice" in
            G)
                if [[ "${status[0]}" == "i" ]]; then
                    options=(1 "View Theme Gallery" 2 "Update Theme Gallery" 3 "Remove Theme Gallery")
                    cmd=(dialog --backtitle "$__backtitle" --menu "Choose an option for gallery" 12 40 06)
                    local choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
                    case "$choice" in
                        1)
                            cd "$gallerydir"
                            if isPlatform "x11"; then
                                feh --info "echo %f" --slideshow-delay 6 --fullscreen --auto-zoom --filelist images.list
                            else
                                fbi --timeout 6 --once --autozoom --list images.list
                            fi
                            ;;
                        2)
                            gitPullOrClone "$gallerydir" "https://github.com/Retro-Arena/es-theme-gallery"
                            ;;
                        3)
                            if [[ -d "$gallerydir" ]]; then
                                rm -rf "$gallerydir"
                            fi
                            ;;
                    esac
                else
                    gitPullOrClone "$gallerydir" "http://github.com/Retro-Arena/es-theme-gallery"
                fi
                ;;
            U)
                for theme in "${installed_themes[@]}"; do
                    theme=($theme)
                    rp_callModule esthemes install_theme "${theme[0]}" "${theme[1]}"
                done
                ;;
            *)
                theme=(${themes[choice-1]})
                repo="${theme[0]}"
                theme="${theme[1]}"
                if [[ "${status[choice]}" == "i" ]]; then
                    options=(1 "Update $repo/$theme" 2 "Uninstall $repo/$theme")
                    cmd=(dialog --backtitle "$__backtitle" --menu "Choose an option for theme" 12 40 06)
                    local choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
                    case "$choice" in
                        1)
                            rp_callModule esthemes install_theme "$theme" "$repo"
                            ;;
                        2)
                            rp_callModule esthemes uninstall_theme "$theme"
                            ;;
                    esac
                else
                    rp_callModule esthemes install_theme "$theme" "$repo"
                fi
                ;;
        esac
    done
}
