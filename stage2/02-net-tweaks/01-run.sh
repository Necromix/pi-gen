#!/bin/bash -e

install -v -d					                "${ROOTFS_DIR}/etc/wpa_supplicant"
install -v -m 600 files/wpa_supplicant.conf	    "${ROOTFS_DIR}/etc/wpa_supplicant/"
install -v -m 644 files/no-wait.conf            "${ROOTFS_DIR}/etc/systemd/system/dhcpcd@.service.d/"

