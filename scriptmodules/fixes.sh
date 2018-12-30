#!/bin/bash

if [[ ! -f /home/pigaming/scripts/update001 ]]; then
    wget -O /home/pigaming/fan/original/rc.local https://pastebin.com/raw/KVyuq0wd
    wget -O /home/pigaming/fan/cool-mode/rc.local https://pastebin.com/raw/4Vjs9nWL
    wget -O /home/pigaming/fan/aggressive/rc.local https://pastebin.com/raw/cgA7KeeY
    dos2unix /home/pigaming/fan/original/rc.local
    dos2unix /home/pigaming/fan/cool-mode/rc.local
    dos2unix /home/pigaming/fan/aggressive/rc.local
    wget -O /home/pigaming/ogst/system-pcfx.png https://raw.githubusercontent.com/Retro-Arena/ogst-retroarena/master/system-pcfx.png
    chmod a+x /home/pigaming/ogst/system-pcfx.png
    sudo cp -p /etc/rc.local.bak /etc/rc.local
    touch /home/pigaming/scripts/update001
fi

if [[ ! -f /home/pigaming/scripts/update002 ]]; then
    wget -O /opt/retropie/configs/all/retroarch-core-options.cfg https://pastebin.com/raw/ATeS35pE
    touch /home/pigaming/scripts/update002
fi

if [[ ! -f /home/pigaming/scripts/update003 ]]; then
    wget -O /opt/retropie/configs/saturn/emulators.cfg https://pastebin.com/raw/1s960yPS
    touch /home/pigaming/scripts/update003
fi

if [[ ! -f /home/pigaming/scripts/update004 ]]; then
    wget -O /etc/usbmount/usbmount.conf https://pastebin.com/raw/dNn591bL
    dos2unix /etc/usbmount/usbmount.conf
    wget -O /etc/usbmount/mount.d/10_retropie_mount https://pastebin.com/raw/M6ZG9iu8
    dos2unix /etc/usbmount/mount.d/10_retropie_mount
    rm /etc/usbmount/mount.d/01_retropie_copyroms
    touch /home/pigaming/scripts/update004
fi

# update005 deprecated

if [[ ! -f /home/pigaming/scripts/update006 ]]; then
    rm -rf /home/pigaming/ogst
    mkdir /home/pigaming/.emulationstation/ogst_themes/
    cd /home/pigaming/.emulationstation/ogst_themes/
    sudo git clone https://github.com/Retro-Arena/ogst-retroarena
    sudo chown -R pigaming:pigaming /home/pigaming/.emulationstation/ogst_themes/
    sudo chown -R pigaming:pigaming /home/pigaming/.emulationstation/ogst_themes/ogst-retroarena/
    touch /home/pigaming/scripts/update006
    touch /home/pigaming/scripts/ogst001
fi

# update007 used by retropiemenu.sh

if [[ ! -f /home/pigaming/scripts/update008 ]]; then
    wget -O /opt/retropie/configs/all/autostart.sh https://pastebin.com/raw/U3Zm4a3m
    dos2unix /opt/retropie/configs/all/autostart.sh
    touch /home/pigaming/scripts/update008
fi

if [[ ! -f /home/pigaming/scripts/update009 ]]; then
    if [[ -d "$home/RetroPie/retropiemenu" ]]; then
        rm -rf "$home/RetroPie/retropiemenu"
        rm -rf "$home/.emulationstation/gamelists/retropie"
        delSystem retropie
    fi
    sudo ./RetroPie-Setup/retropie_packages.sh settingsmenu install_bin
    sudo ./RetroPie-Setup/retropie_packages.sh settingsmenu configure
    touch /home/pigaming/scripts/update009
fi
