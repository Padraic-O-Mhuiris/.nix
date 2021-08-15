#!/usr/bin/env bash
set -euo pipefail

declare -a DISKS=("/dev/nvme0n1" "/dev/sda")

FIRST_DISK=${DISKS[0]}
OTHER_DISK=${DISKS[@]:1}

LUKS_PART="CRYPTED"
LUKS_PASSPHRASE="abc123"

ZFS_POOL="zroot"
ZFS_ROOT="$ZFS_POOL/root"
ZFS_NIXOS="$ZFS_POOL/root/nixos"
ZFS_HOME="$ZFS_POOL/home"

MOUNTPOINT_ROOT="/mnt"
MOUNTPOINT_BOOT="/mnt/boot"
MOUNTPOINT_HOME="/mnt/home"

function all_partitions () {
    for DISK in "${DISKS[@]}"; do
        lsblk -fnpl -o NAME,TYPE,PARTLABEL $DISK
    done
}

function boot_partition {
    all_partitions | grep 'BOOT' | awk '{print $1}'
}

function swap_partition {
    all_partitions | grep 'SWAP' | awk '{print $1}'
}

function filesystem_partitions {
    all_partitions | grep 'ZFS-*' | awk '{print $1}' | xargs
}

function crypted_partitions {
    all_partitions | grep 'crypt' | awk '{print $1}' | xargs
}

function by-uuid {
    lsblk $1 -no UUID | xargs
}

function zpools {
    zpool list -Ho name | xargs
}

function destroy_partitions {
    mountpoint -q $MOUNTPOINT_ROOT && umount -R $MOUNTPOINT_ROOT
       
    for DISK in "${DISKS[@]}"; do
        partprobe $DISK
        sleep 1
    done;

    if [ $(zpools) ]
    then
       zpool destroy $(zpools)
    fi

    for PART in $(crypted_partitions)
    do
        cryptsetup luksClose $PART
    done

    for DISK in "${DISKS[@]}"; do
        sgdisk -Z $DISK
        wipefs -af $DISK
        dd if=/dev/zero of=$DISK bs=1M count=10
    done;
}

function create_partitions {
    i=0
    sgdisk -n 0:0:+1GiB -t 0:EF00 -c 0:BOOT $FIRST_DISK
    sgdisk -n 0:0:+32GiB -t 0:8200 -c 0:SWAP $FIRST_DISK
    sgdisk -n 0:0:0 -t 0:BF01 -c "0:ZFS-$i" $FIRST_DISK
    sgdisk -p $FIRST_DISK
    partprobe $FIRST_DISK
    sleep 1

    for DISK in "$OTHER_DISK"; do
        ((i=i+1))
        sgdisk -n 0:0:0 -t 0:BF01 -c "0:ZFS-$i" $DISK
        sgdisk -p $DISK
        partprobe $DISK
        sleep 1
    done
}

# function encrypt_partitions {
#     i=0
#     for PART in $(filesystem_partitions)
#     do
#         echo "$LUKS_PASSPHRASE" | cryptsetup -q luksFormat $PART
#         echo "$LUKS_PASSPHRASE" | cryptsetup -q luksOpen $PART "$LUKS_PART-$i"
#         ((i=i+1))
#     done
# }

function setup_zfs {
   zpool create \
        -o ashift=12 \
        -o altroot="/mnt" \
        -O mountpoint=none \
        -O encryption=aes-256-gcm \
        -O keyformat=passphrase \
        $ZFS_POOL $(filesystem_partitions)

    zfs create -o mountpoint=none $ZFS_ROOT
    zfs create -o mountpoint=legacy $ZFS_NIXOS
    zfs create -o mountpoint=legacy -o com.sun:auto-snapshot=true $ZFS_HOME

    zfs set compression=lz4 $ZFS_HOME
}

function mount_filesystem {
    mount -t zfs $ZFS_NIXOS $MOUNTPOINT_ROOT
    mkdir -p $MOUNTPOINT_HOME
    mount -t zfs $ZFS_HOME $MOUNTPOINT_HOME

    mkfs.vfat $(boot_partition)
    mkdir -p $MOUNTPOINT_BOOT
    mount $(boot_partition) $MOUNTPOINT_BOOT

    mkswap -L swap $(swap_partition)
}

function build_nixos {
    nixos-generate-config --root /mnt

    NIXOS_CONFIG_DIR="$MOUNTPOINT_ROOT/etc/nixos"
    NIXOS_CONFIG="$NIXOS_CONFIG_DIR/configuration.nix"
    NIXOS_HARDWARE="$NIXOS_CONFIG_DIR/hardware-configuration.nix"

    SWAP_UUID=$(by-uuid $(swap_partition))
    SWAP_ENTRY="swapDevices = [\{ device = \"/dev/disk/by-uuid/$SWAP_UUID\"; \}];"

    sed -i "/swapDevices/c\  $SWAP_ENTRY" $NIXOS_HARDWARE

    cat $NIXOS_HARDWARE

    ## TODO Add hostid to config
}

destroy_partitions
create_partitions
#encrypt_partitions
setup_zfs
mount_filesystem
build_nixos
