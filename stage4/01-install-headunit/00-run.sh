#!/bin/bash -e

##Compile and install headunit-desktop
if [ ! -d ${ROOTFS_DIR}/opt/headunit-desktop ] || [ ! -z ${BUILD_HEADUNIT+x} ]; then    

    install -v -d					                "${ROOTFS_DIR}/opt/headunit-desktop"

    log "Building headunit-desktop..."
on_chroot << EOF
    cd /home/pi

    ### Build headunit 
    if [ -d "headunit-desktop" ]; then
        cd headunit-desktop
        echo "Pulling headunit from git"
        git pull --recurse-submodules
    else
        echo "Cloning headunit from git"
        git clone --recursive --depth 10 https://github.com/viktorgino/headunit-desktop.git
        cd headunit-desktop
    fi

    echo "Generate protobuf with proto"
    
    protoc --proto_path=modules/android-auto/headunit/hu/ --cpp_out=modules/android-auto/headunit/hu/generated.x64/ modules/android-auto/headunit/hu/hu.proto

    echo "Compile headunit-desktop"
    echo "Run qmake"
    qmake PREFIX=/opt/headunit-desktop RPI=1 headunit-desktop.pro
    echo "Run make"
    make -j4
    echo "Run make install"
    make install
EOF
else
    log "Skipping headunit-desktop compilation"
fi 
