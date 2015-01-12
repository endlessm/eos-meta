#!/bin/sh
# -*- mode: shell-script; indent-tabs-mode: nil; sh-basic-offset: 4; -*-
# ex: ts=8 sw=4 sts=4 et filetype=sh
#
# Licensed under the GPLv2
#
# Copyright 2011, Red Hat, Inc.
# Harald Hoyer <harald@redhat.com>
exec > /dev/kmsg
exec 2>&1

dmesg -E
dmesg -n info

printf "Beginning reflashing process.\n"
printf "Searching for USB disk...\n"
sleep 2

BLKS=$(lsblk -l -o Name)
for LAST_BLK in $BLKS; do true; done
USB_PATH="/dev/${LAST_BLK}"

printf "Found USB at ${USB_PATH}\n"
printf "Mounting USB at /mnt...\n"

if [ ! -d /mnt ]; then
    mkdir /mnt
fi

if mount ${USB_PATH} /mnt ; then
    for file in /mnt/*.gz ; do
        printf "Flashing ${file} located at USB's '/' directory. This will take a few minutes...\n"
        dmesg -n alert
        if ! gzip -cd $file | dd oflag=nonblock bs=1M of=/dev/sda conv=sparse,fsync ; then
            dmesg -n info
            printf "Flashing failed. Machine must now be flashed from backup USB."
            sleep 100
        fi
        break
    done
else
    dmesg -n info
    printf 'Unable to mount USB...aborting.\n'
    exit 1
fi
umount /mnt

export TERM=linux
export PATH=/usr/sbin:/usr/bin:/sbin:/bin
. /lib/dracut-lib.sh

mkdir /oldsys
for i in sys proc run dev; do
    mkdir /oldsys/$i
    mount --move /oldroot/$i /oldsys/$i
done

killall_proc_mountpoint /oldroot
# Plymouthd is not killed by killall_proc_mountpoint
pkill -f plymouthd

umount_a() {
    local _did_umount="n"
    while read a mp a; do
        if strstr "$mp" oldroot; then
            if umount "$mp"; then
                _did_umount="y"
                warn "Unmounted $mp."
            fi
        fi
    done </proc/mounts
    losetup -D
    [ "$_did_umount" = "y" ] && return 0
    return 1
}

_cnt=0
while [ $_cnt -le 40 ]; do
    umount_a 2>/dev/null || break
    _cnt=$(($_cnt+1))
done

[ $_cnt -ge 40 ] && umount_a

if strstr "$(cat /proc/mounts)" "/oldroot"; then
    warn "Cannot umount /oldroot"
    for _pid in /proc/*; do
        _pid=${_pid##/proc/}
        case $_pid in
            *[!0-9]*) continue;;
        esac
        [ -e /proc/$_pid/exe ] || continue
        [ -e /proc/$_pid/root ] || continue
        if strstr "$(ls -l /proc/$_pid /proc/$_pid/fd 2>/dev/null)" "oldroot"; then
            warn "Blocking umount of /oldroot [$_pid] $(cat /proc/$_pid/cmdline)"
        elif [ $_pid -ne $$ ]; then
            warn "Still running [$_pid] $(cat /proc/$_pid/cmdline)"
        fi
        ls -l /proc/$_pid/fd 2>&1 | vwarn
    done
fi

dmesg -n info
printf "Flashing is complete!\n"
printf 'Powering off. Remove the USB before restarting the computer.'
sleep 5
poweroff -f

