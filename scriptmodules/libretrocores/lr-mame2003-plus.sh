#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="mame2003_plus"
rp_module_desc="Arcade emu - updated MAME 0.78 port for libretro with added game support"
rp_module_help="ROM Extension: .zip\n\nCopy your MAME roms to either $romdir/mame-libretro or\n$romdir/arcade"
rp_module_licence="NONCOM https://raw.githubusercontent.com/libretro/mame2003-plus-libretro/master/LICENSE.md"
rp_module_section="exp"

function sources_mame2003_plus() {
    gitPullOrClone "$md_build" https://github.com/libretro/mame2003-plus-libretro.git
}

function build_mame2003_plus() {
    build_lr-mame2003
}

function install_mame2003_plus() {
    install_lr-mame2003
}

function configure_mame2003_plus() {
    configure_lr-mame2003
}
