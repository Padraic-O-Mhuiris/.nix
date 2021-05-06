#!/usr/bin/env bash
set -euo pipefail


DISKS=("/dev/nvme0n1" "/dev/sda")

find_partitions () {
    array=()
    for DISK in "$@"; do
        array+=($(lsblk -fl -o NAME $DISK | awk 'NR > 2 { print }' | sed 's/\</\/dev\//g'))
    done
    echo "${array[@]}"
}

get_main_partition () {
    find_partitions $MAIN_DISK | echo
}

get_other_partitions () {
    echo $(find_partitions $OTHER_DISKS)
}

get_all_partitions () {
    echo "$(get_main_partition) $(get_other_partitions)"
}

get_boot_partition () {
    echo $(get_all_partitions | awk '{print $1}')
}

get_swap_partition () {
    echo $(get_all_partitions | awk '{print $2}')
}

get_root_partition () {
    echo $(get_all_partitions | awk '{print $3}')
}

get_encrypted_partitions () {
    echo $(echo $(get_all_partitions) | cut -d " " -f3-)
}
