#!/bin/bash -e

log "Getting udev rules"
wget -P ${ROOTFS_DIR}/etc/udev/rules.d https://raw.githubusercontent.com/snowdream/51-android/master/51-android.rules

log "copying environment file"
install -m 644 files/environment ${ROOTFS_DIR}/etc
install -m 644 files/headunit.service ${ROOTFS_DIR}/lib/systemd/system
install -m 644 files/splashscreen.service ${ROOTFS_DIR}/lib/systemd/system
install -m 644 files/boot-logo.bmp ${ROOTFS_DIR}/opt

on_chroot << EOF
systemctl daemon-reload
systemctl enable headunit.service
systemctl enable splashscreen.service
EOF

log "Setting bluetooth permissions"
on_chroot << EOF
adduser pi bluetooth
adduser pulse bluetooth
EOF

log "Edit /boot/config.txt and /boot/cmdline.txt"
on_chroot << EOF
echo "gpu_mem=256" >> /boot/config.txt
echo "dtoverlay=vc4-fkms-v3d" >> /boot/config.txt
echo "lcd_rotate=2" >> /boot/config.txt
echo "dtoverlay=pi3-disable-bt" >> /boot/config.txt
echo "disable_splash=1" >> /boot/config.txt
sed -i ' 1 s/.*/& splash logo.nologo vt.global_cursor_default=0/' /boot/cmdline.txt
EOF

log "Run raspberry pi firmware update "
on_chroot << EOF
SKIP_WARNING=1 rpi-update
EOF