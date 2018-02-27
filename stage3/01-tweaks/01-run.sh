#!/bin/bash -e

log "Getting udev rules"
wget -P ${ROOTFS_DIR}/etc/udev/rules.d https://raw.githubusercontent.com/snowdream/51-android/master/51-android.rules

log "copying environment file"
install -m 644 files/environment ${ROOTFS_DIR}/etc

log "Setting bluetooth permissions"
on_chroot << EOF
adduser pi bluetooth
adduser pulse bluetooth
EOF
