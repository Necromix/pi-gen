#!/bin/bash -e

rm -f "${ROOTFS_DIR}/etc/systemd/system/dhcpcd.service.d/wait.conf"

log "Getting udev rules"
install -v -d					                "${ROOTFS_DIR}/etc/udev/rules.d "
install -m 644 files/51-android.rules           "${ROOTFS_DIR}/etc/udev/rules.d/"

log "Copy environment file"
install -v -d					                "${ROOTFS_DIR}/etc"
install -m 644 files/environment                "${ROOTFS_DIR}/etc/"

log "Copy headunit service file"
install -v -d					                "${ROOTFS_DIR}/lib/systemd/system"
install -m 644 files/headunit.service           "${ROOTFS_DIR}/lib/systemd/system/"

log "Copy pulseaudio config file"
install -v -d					                "${ROOTFS_DIR}/home/pi/.config/pulse"
install -m 644 files/default.pa                 "${ROOTFS_DIR}/home/pi/.config/pulse/"

log "Enable services"
on_chroot << EOF
systemctl daemon-reload
systemctl enable headunit.service

systemctl enable pulseaudio.socket --user
systemctl enable pulseaudio.service --user
systemctl enable dbus.service --user
EOF

log "Set bluetooth permissions"
on_chroot << EOF
adduser pi bluetooth
adduser pulse bluetooth
EOF
