#!/usr/bin/env bash


rp_module_id="fruitbox"
rp_module_desc="Fruitbox Jukebox music player."
rp_module_section="opt"
rp_module_flags=""

function depends_fruitbox() {
    getDepends libsm-dev libxcursor-dev libxi-dev libxinerama-dev libxrandr-dev libxpm-dev libvorbis-dev libtheora-dev
}

function sources_fruitbox() {
    gitPullOrClone "$md_build/allegro5" "https://github.com/dos1/allegro5.git"
    gitPullOrClone "$md_build/fruitbox" "https://github.com/Retro-Arena/rpi-fruitbox.git"
    downloadAndExtract "https://ftp.osuosl.org/pub/blfs/conglomeration/mpg123/mpg123-1.24.0.tar.bz2" "$md_build"
    wget http://odroidarena.com/pub/additional-files/CMakeLists.txt
    wget http://odroidarena.com/pub/additional-files/Toolchain-odroid.cmake
}

function build_fruitbox() {
    # Build mpg123
    cd "$md_build/mpg123-1.24.0"
    chmod +x configure
    ./configure --with-cpu=arm_fpu --disable-shared
    make -j4 && make install
    cd ..
    # Overwrite build files.
    cp -vf "$md_build/CMakeLists.txt" "$md_build/allegro5/"
    cp -vf "$md_build/Toolchain-odroid.cmake" "$md_build/allegro5/cmake/"
    # Build Allegro5
    cd "$md_build/allegro5"
    mkdir build && cd build
    cmake .. -DCMAKE_TOOLCHAIN_FILE=../cmake/Toolchain-odroid.cmake -DSHARED=off
    make -j4 && make install
    export PKG_CONFIG_PATH=/opt/retropie/ports/fruitbox/build/allegro5/build/lib/pkgconfig
    ldconfig
    cd ../..

    # Build fruitbox
    cd "$md_build/fruitbox/build"
    make -j4
    
    md_ret_require="$md_build/fruitbox/build/fruitbox"
}

function install_fruitbox() {
    #mkdir "$md_inst/bin"
    cp -v "$md_build/fruitbox/build/fruitbox" "$md_inst/"
	cp -v "$md_build/fruitbox/skins.txt" "$md_inst/"
	cp -vR "$md_build/fruitbox/skins" "$md_inst/"
}

function configure_fruitbox() {
    mkRomDir "jukebox"

    cat > "$romdir/jukebox/+Start fruitbox.sh" << _EOF_
#!/bin/bash
/opt/retropie/supplementary/fruitbox/fruitbox --cfg /opt/retropie/supplementary/fruitbox/skins/Modern/fruitbox.cfg
_EOF_
    chmod a+x "$romdir/jukebox/+Start fruitbox.sh"
    chown $user:$user "$romdir/jukebox/+Start fruitbox.sh"

    addEmulator 0 "$md_id" "jukebox" "fruitbox %ROM%"
    addSystem "jukebox" "Fruitbox Jukebox" ".sh"
}
