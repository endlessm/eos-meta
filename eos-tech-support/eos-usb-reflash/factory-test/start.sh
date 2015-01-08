#!/bin/bash
# This is a factory test script that places a barebones system in
# /run/intramfs. This fs will mount the USB disk and flash its 
# image to internal storage.

set -e

KERNEL_VERSION="$(uname -r)"

echo "Copying initramfs for reflash..."
if cp  "/var/wistron/initramfs-${KERNEL_VERSION}.img" "/boot/initramfs-${KERNEL_VERSION}.img"; then
    echo "Copy was successful!"
else
    echo "Copy failed. Use backup flashing method."
    exit 1
fi
sleep 2

echo "Creating the files that dracut needs to execute dracut-initramfs-restore."
mkdir /run/initramfs
touch /run/initramfs/.need_shutdown
sleep 2

echo "Running /usr/lib/dracut/dracut-initramfs-restore manually."
/usr/lib/dracut/dracut-initramfs-restore
sleep 2

echo "Removing testsuite directory and powering off."
sleep 2
rm -rf /var/wistron
poweroff
