#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

function yesno() {
    local prompt="$1"

    while true; do
        read -rp "$prompt [y/n] " yn
        case $yn in
            [Yy]* ) echo "y"; return;;
            [Nn]* ) echo "n"; return;;
            * ) echo "Please answer yes or no.";;
        esac
    done
}

cat << Introduction
The *entire* disk will be formatted with a 1GB boot partition
(labelled NIXBOOT), and the rest allocated to BTRFS.

The following BTRFS subvolume will be created:
    - /root (mounted at / with blank snapshot)
    - /nix (mounted at /nix)
    - /home (mounted at /home)
    - /persist (mounted at /persist)
    - /cache (mounted at /cache)

** IMPORTANT **
This script assumes that the relevant "fileSystems" are declared within the
NixOS config to be installed. It does not create any hardware configuration
or modify the NixOS config to be installed in any way. If you have not done
so, you will need to add the necessary btrfs options and filesystems before
proceeding or your install WILL NOT BOOT.

Introduction

# in a vm, special case
if [[ -b "/dev/vda" ]]; then
    DISK="/dev/vda"
else
    # listing with the standard lsblk to help with viewing partitions
    lsblk

    # Get the list of disks
    mapfile -t disks < <(lsblk -ndo NAME,SIZE,MODEL)

    echo -e "\nAvailable disks:\n"
    for i in "${!disks[@]}"; do
        printf "%d) %s\n" $((i+1)) "${disks[i]}"
    done

    # Get user selection
    while true; do
        echo ""
        read -rp "Enter the number of the disk to install to: " selection
        if [[ "$selection" =~ ^[0-9]+$ ]] && [ "$selection" -ge 1 ] && [ "$selection" -le ${#disks[@]} ]; then
            break
        else
            echo "Invalid selection. Please try again."
        fi
    done

    # Get the selected disk
    DISK="/dev/$(echo "${disks[$selection-1]}" | awk '{print $1}')"
fi

# if disk contains "nvme", append "p" to partitions
if [[ "$DISK" =~ "nvme" ]]; then
    BOOTDISK="${DISK}p3"
    BTRFSDISK="${DISK}p1"
else
    BOOTDISK="${DISK}3"
    BTRFSDISK="${DISK}1"
fi

echo "Boot Partiton: $BOOTDISK"
echo "BTRFS Partiton: $BTRFSDISK"

echo ""
do_format=$(yesno "This irreversibly formats the entire disk. Are you sure?")
if [[ $do_format == "n" ]]; then
    exit
fi

echo "Creating partitions"
sudo blkdiscard -f "$DISK"
sudo sgdisk --clear"$DISK"

sudo sgdisk -n3:1M:+1G -t3:EF00 "$DISK"
sudo sgdisk -n1:0:0 -t1:8300 "$DISK"

# notify kernel of partition changes
sudo sgdisk -p "$DISK" > /dev/null
sleep 5

echo "Creating Boot Disk"
sudo mkfs.fat -F 32 "$BOOTDISK" -n NIXBOOT

echo "Creating base btrfs disk"
sudo mkfs.btrfs -L Butter "$BTRFSDISK"

echo "Creating BTRFS subvolume"
sudo mount "$BTRFSDISK" /mnt
sudo btrfs subvolume create /mnt/root
sudo btrfs subvolume create /mnt/nix
sudo btrfs subvolume create /mnt/home
sudo btrfs subvolume create /mnt/persist
sudo btrfs subvolume create /mnt/cache

echo "Taking snapshot of the empty volume"
sudo btrfs subvolume snapshot -r /mnt/root /mnt/root-blank

# create the boot parition after creating root
echo "Mounting /boot (efi)"
sudo mount --mkdir "$BOOTDISK" /mnt/boot

echo "Mounting subvolumes"
sudo mount -o subvol=root,compress=zstd,noatime "$BTRFSDISK" /mnt
sudo mount --mkdir -o subvol=home,compress=zstd "$BTRFSDISK" /mnt/home
sudo mount --mkdir -o subvol=nix,compress=zstd,noatime "$BTRFSDISK" /mnt/nix
sudo mount --mkdir -o subvol=persist,compress=zstd,noatime "$BTRFSDISK" /mnt/persist
sudo mount --mkdir -o subvol=cache,compress=zstd,noatime "$BTRFSDISK" /mnt/cache

# Get repo to install from
read -rp "Enter flake URL (default: github:Sumelan/wolborg): " repo
repo="${repo:-github:Sumelan/wolborg}"

# wolborg
if [[ $repo == "github:Sumelan/wolborg" ]]; then
    hosts=("acer" "sakura")

    echo "Available hosts:"
    for i in "${!hosts[@]}"; do
        printf "%d) %s\n" $((i+1)) "${hosts[i]}"
    done

    while true; do
        echo ""
        read -rp "Enter the number of the host to install: " selection
        if [[ "$selection" =~ ^[0-9]+$ ]] && [ "$selection" -ge 1 ] && [ "$selection" -le ${#hosts[@]} ]; then
            host="${hosts[$selection-1]}"
            break
        else
            echo "Invalid selection. Please enter a number between 1 and ${#hosts[@]}."
        fi
    done
else
    read -rp "Which host to install?" host
fi

read -rp "Enter git rev for flake (default: main): " git_rev

echo "Installing NixOS"
if [[ $repo == "github:Sumelan/wolborg" ]]; then
    # root password is irrelevant if initialPassword is set in the config
    sudo nixos-install --no-root-password --flake "$repo/${git_rev:-main}#$host" --option tarball-ttl 0
else
    sudo nixos-install --flake "$repo/${git_rev:-main}#$host" --option tarball-ttl 0
fi

echo "Installation complete. It is now safe to reboot."
