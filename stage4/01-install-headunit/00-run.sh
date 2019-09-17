#!/bin/bash -e

##Compile and install headunit-desktop
if [ ! -d ${ROOTFS_DIR}/opt/headunit-desktop ] || [ ! -z ${BUILD_HEADUNIT+x} ]; then    
    log "Compiling headunit-desktop..."
on_chroot << EOF
    mkdir /opt/headunit-desktop
    cd /home/pi

    ### Build headunit 
    if [ -d "headunit-desktop" ]; then
        cd headunit-desktop
        echo "Pulling headunit from git"
        git pull
    else
        echo "Cloning headunit from git"
        git clone --recursive --depth 10 https://github.com/viktorgino/headunit-desktop.git
        cd headunit-desktop
    fi

    #Generate protobuf with proto
    protoc --proto_path=modules/android-auto/headunit/hu/ --cpp_out=modules/android-auto/headunit/hu/generated.x64/ modules/android-auto/headunit/hu/hu.proto

    # compile headunit-desktop
    PREFIX=/opt/headunit-desktop qmake headunit-desktop.pro
    make -j4
    make install
    chown -R pi:pi /opt/headunit-desktop
EOF
else
    log "Skipping headunit-desktop compilation"
fi 
