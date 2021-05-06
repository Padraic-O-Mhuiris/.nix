#!/usr/bin/env bash
set -euo pipefail

source ./disks.sh

destory_partitions () {
    let X=1
    PARTITIONS="$(get_encrypted_partitions)"

    for PART in $PARTITIONS;
    do
        FILE="/dev/mapper/CRYPTED-$X"
        if [[ -f "$FILE" ]]; then
            cryptsetup remove "/dev/mapper/CRYPTED-$X"
            ((X=X+1))
        fi
        sgdisk -Z $PART
        wipefs -af $PART
        dd if=/dev/zero of=$PART bs=1M count=10

    done

    for DISK in $DISKS; do
        sgdisk -Z $DISK
        wipefs -af $DISK
        dd if=/dev/zero of=$DISK bs=1M count=10
    done;
}
