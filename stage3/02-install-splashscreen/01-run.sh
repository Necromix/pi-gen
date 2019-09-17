
log "Edit /boot/cmdline.txt"
on_chroot << EOF
sed -i ' 1 s/.*/& splash plymouth.ignore-serial-consoles vt.global_cursor_default=0/' /boot/cmdline.txt
EOF

log "Install plymouth-boot theme"
install -d "${ROOTFS_DIR}/usr/share/plymouth/themes/headunit/"
install -m 644 files/* "${ROOTFS_DIR}/usr/share/plymouth/themes/headunit/"

log "Set default plymouth theme and update initramfs"

on_chroot << EOF
plymouth-set-default-theme headunit
EOF

# on_chroot << EOF
# update-initramfs -d -k all
# update-initramfs -c -k $(uname -r)
# EOF

log "Disable login console"
on_chroot << EOF
systemctl disable getty@tty1.service
systemctl disable keyboard-setup.service
systemctl daemon-reload
EOF