#!/bin/bash -e


wget -P ${ROOTFS_DIR}/etc/udev/rules.d https://raw.githubusercontent.com/snowdream/51-android/master/51-android.rules

install -m 644 files/environment ${ROOTFS_DIR}/etc

on_chroot << \EOF
adduser pi bluetooth
adduser pulse bluetooth
EOF
