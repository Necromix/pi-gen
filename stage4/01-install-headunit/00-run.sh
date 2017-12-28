#!/bin/bash -e

#Compile qt-gstreamer
if [ ! -d ${ROOTFS_DIR}/opt/qt-gstreamer ] || [ ! -z ${BUILD_QTGSTREAMER+x} ]; then    
    log "Compiling qt-gstreamer..."
on_chroot << EOF
    cd /opt

    #Clone QtGstreamer
    if [ -d "qt-gstreamer" ]; then
        cd qt-gstreamer
        git pull
    else
        git clone git://anongit.freedesktop.org/gstreamer/qt-gstreamer
        cd qt-gstreamer
    fi

    #Create build dir
    mkdir build
    cd build

    #cmake QtGstreamer
    cmake .. -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_INSTALL_LIBDIR=lib/arm-linux-gnueabihf -DCMAKE_INSTALL_INCLUDEDIR=include -DQT_VERSION=5 -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_FLAGS=-std=c++11

    #Make and install QtGstreamer
    make -j6
    make install
EOF
else
    log "Skipping qt-gstreamer compilation"
fi

#Compile qtcharts
if [ ! -d ${ROOTFS_DIR}/opt/qtcharts ] || [ ! -z ${BUILD_QTCHARTS+x} ]; then    
    log "Compiling qtcharts"
on_chroot << EOF
    cd /opt

    #Clone qtcharts
    git clone https://github.com/qt/qtcharts.git -b 5.7

    cd qtcharts/src
    git checkout tags/v5.7.1

    #Make and install qtcharts
    qmake CONFIG+=release
    make -j4
    make install
EOF
else
    log "Skipping qtcharts compilation"
fi

#Compile and install headunit-desktop
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
    qmake CONFIG+=welleio -config release 
    make -j4
    chown -R pi:pi /opt/headunit-desktop
EOF
else
    log "Skipping headunit-desktop compilation"
fi 
