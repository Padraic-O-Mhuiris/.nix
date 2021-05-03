#!/usr/bin/env bash

set -euo pipefail

#IFS=$'\n' DEVICE_IDS=($(ls /dev/disk/by-id))

# find_device_id () {
#     PART="$1"
#     id=""
#     for i in "${DEVICE_IDS[@]}"; do
#         ID_PATH=$(readlink -f "/dev/disk/by-id/$i")
#         if [ "$ID_PATH" == "$PART" ] && [ ${#i} -gt ${#id} ]; then
#             id=$i
#         fi
#     done
#     echo $id
# }

# BOOT_ID=$(find_device_id $BOOT_PARTITION)
# SWAP_ID=$(find_device_id $SWAP_PARTITION)
# ROOT_ID=$(find_device_id $ROOT_PARTITION)
# REST_IDS=$(for i in "${ENCRYPTED_PARTITIONS[@]}"; do find_device_id $i; done)

DISKS=$@

MAIN_DISK=$1
OTHER_DISKS="${@:2}"

mk_main_partition () {
    DISK="$1"
    sgdisk -n 0:0:+1GiB -t 0:EF00 -c 0:BOOT $DISK
    sgdisk -n 0:0:+12GiB -t 0:8200 -c 0:SWAP $DISK
    sgdisk -n 0:0:0 -t 0:BF01 -c 0:ROOT $DISK
    sgdisk -p $DISK
}

mk_other_partition () {
    DISKS=$1
    i=1
    for DISK in $DISKS
    do
        sgdisk -n 0:0:0 -t 0:BF01 -c "0:ZFS-$i" $DISK
        sgdisk -p $DISK
        ((i=i+1))
    done
}

tear_down () {
    let X=1
    for i in "${ENCRYPTED_PARTITIONS[@]}";
    do
        FILE="/dev/mapper/CRYPTED-$X"
        if [[ -f "$FILE" ]]; then
            cryptsetup remove "/dev/mapper/CRYPTED-$X"
            ((X=X+1))
        fi
    done


    for DISK in $DISKS; do
        wipefs -af $DISK
        sgdisk -Z $DISK
        dd if=/dev/zero of=$DISK bs=1M count=10
    done;
}

create_partitions() {
    tear_down
    mk_main_partition $MAIN_DISK
    mk_other_partition $OTHER_DISKS
}

find_partitions () {
    array=()
    for DISK in "$@"; do
        array+=($(lsblk -fl -o NAME $DISK | awk 'NR > 3 { print }' | sed 's/\</\/dev\//g'))
    done
    echo "${array[@]}"
}

#mkfs.vfat $BOOT_PARTITION


get_main_partition () {
    echo $(find_partitions $MAIN_DISK)
}

get_other_partitions () {
    echo $(find_partitions $OTHER_DISKS)
}

get_all_partitions () {
    echo "$(get_main_partition) $(get_other_partitions)"
}

get_boot_partition () {
    echo $(echo $(get_all_partitions) | awk '{print $0}')
}

get_swap_partition () {
    echo $(echo $(get_all_partitions) | awk '{print $1}')
}

get_root_partition () {
    echo $(echo $(get_all_partitions) | awk '{print $2}')
}

get_encrypted_partitions () {
    echo $(echo $(get_all_partitions) | cut -d " " -f3-)
}
    
encrypt_partitions () {
    LUKS_SECRET="abc123"
    echo $ALL_PARTITIONS
    echo $BOOT_PARTITION

    for i in "${ENCRYPTED_PARTITIONS[@]}";
    do
        cryptsetup luksFormat -c aes-xts-plain64 -s 512 -h sha512 $i;
        echo "YES\n"
        echo "$LUKS_SECRET\n"
        echo "$LUKS_SECRET\n"
    done

    let i=1
    for i in "${ENCRYPTED_PARTITIONS[@]}";
    do
        cryptsetup luksOpen $i "CRYPTED-$1"
        echo "YES\n"
        echo "$LUKS_SECRET\n"
        echo "$LUKS_SECRET\n"
    done
}

create_partitions
get_main_partition
get_other_partitions
#encrypt_partitions
