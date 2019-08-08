#!/bin/bash -e

Compile and install headunit-desktop
if [ ! -d ${ROOTFS_DIR}/opt/headunit-desktop ] || [ ! -z ${BUILD_HEADUNIT+x} ]; then    
    log "Compiling headunit-desktop..."
on_chroot << EOF
    cd /opt

    ### Build headunit 
    if [ -d "headunit-desktop" ]; then
        cd headunit-desktop
        echo "Pulling headunit from git"
        git pull
    else
        echo "Cloning headunit from git"
        git clone --recursive --depth 1 https://github.com/viktorgino/headunit-desktop.git
        cd headunit-desktop
    fi

    #Generate protobuf with proto
    protoc --proto_path=headunit/hu/ --cpp_out=headunit/hu/generated.x64/ headunit/hu/hu.proto

    #compile headunit-desktop
    make clean
    qmake CONFIG+=welleio CONFIG+=rpi -config release 
    make -j4
    chown -R pi:pi /opt/headunit-desktop
EOF
else
    log "Skipping headunit-desktop compilation"
fi 
