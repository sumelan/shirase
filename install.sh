#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

function yesno() {
  local prompt="$1"

  while true; do
    read -rp "$prompt [y/n] " yn
    case $yn in
    [Yy]*)
      echo "y"
      return
      ;;
    [Nn]*)
      echo "n"
      return
      ;;
    *) echo "Please answer yes or no." ;;
    esac
  done
}

cat <<Introduction
The *entire* disk will be formatted with a 1GB boot partition
(labelled NIXBOOT), and the rest allocated to BTRFS (labelled NIXOS).

The following BTRFS subvolumes will be created:
    - root(/) (mounted at / with blank snapshot)
    - /nix (mounted at /nix)
    - /persist (mounted at /persist)
    - /cache (mounted at /cache)

** IMPORTANT **
This script assumes that the relevant "fileSystems" are declared within the
NixOS config to be installed. It does not create any hardware configuration
or modify the NixOS config to be installed in any way. If you have not done
so, you will need to add the necessary btrfs options and filesystems before
proceeding or your install WILL NOT BOOT.

Introduction

# NOTE: during rebuild, there will be warnings about setting multiple password options, this is expected :(
# (https://github.com/NixOS/nixpkgs/pull/287506#issuecomment-1950958990)
# see nixos/users.nix for a fix to silence the warnings

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
    printf "%d) %s\n" $((i + 1)) "${disks[i]}"
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
  DISK="/dev/$(echo "${disks[$selection - 1]}" | awk '{print $1}')"
fi

# if disk contains "nvme", append "p" to partitions
if [[ "$DISK" =~ "nvme" ]]; then
  BOOTDISK="${DISK}p2"
  BTRFSDISK="${DISK}p1"
else
  BOOTDISK="${DISK}2"
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

sudo sgdisk -n2:1M:+1G -t2:EF00 "$DISK"
sudo sgdisk -n1:0:0 -t1:8300 "$DISK"

# notify kernel of partition changes
sudo sgdisk -p "$DISK" >/dev/null
sleep 5

echo "Creating Boot Disk"
sudo mkfs.fat -F 32 "$BOOTDISK" -n NIXBOOT

echo "Creating Btrfs disk"
sudo mkfs.btrfs -L NIXOS "$BTRFSDISK"

echo "Mounting Btrfs disk"
sudo mount "$BTRFSDISK" /mnt

echo "Creating /"
sudo btrfs subvolume create /mnt/root

echo "Creating /nix"
sudo btrfs subvolume create /mnt/nix

echo "Creating /persist"
sudo btrfs subvolume create /mnt/persist

echo "Creating /cache"
sudo btrfs subvolume create /mnt/cache

echo "taking an empty *readonly* snapshot of the root subvolum"
sudo btrfs subvolume snapshot -r /mnt/root /mnt/root-blank

echo "Unmounting /mnt"
sudo umount /mnt

echo "Mounting the subvolumes"
sudo mount -o subvol=root,compress=zstd,noatime "$BTRFSDISK" /mnt
sudo mount --mkdir -o subvol=nix,compress=zstd,noatime "$BTRFSDISK" /mnt/nix
sudo mount --mkdir -o subvol=persist,compress=zstd,noatime "$BTRFSDISK" /mnt/persist
sudo mount --mkdir -o subvol=cache,compress=zstd,noatime "$BTRFSDISK" /mnt/cache

echo "Mounting /boot (efi)"
sudo mount --mkdir "$BOOTDISK" /mnt/boot

# Get repo to install from
read -rp "Enter flake URL (default: github:sumelan/shirase): " repo
repo="${repo:-github:sumelan/shirase}"

# shirase
if [[ $repo == "github:sumelan/shirase" ]]; then
  hosts=("acer" "sakura" "minibook")

  echo "Available hosts:"
  for i in "${!hosts[@]}"; do
    printf "%d) %s\n" $((i + 1)) "${hosts[i]}"
  done

  while true; do
    echo ""
    read -rp "Enter the number of the host to install: " selection
    if [[ "$selection" =~ ^[0-9]+$ ]] && [ "$selection" -ge 1 ] && [ "$selection" -le ${#hosts[@]} ]; then
      host="${hosts[$selection - 1]}"
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
if [[ $repo == "github:sumelan/shirase" ]]; then
  # root password is irrelevant if initialPassword is set in the config
  sudo nixos-install --no-root-password --flake "$repo/${git_rev:-main}#$host" --option tarball-ttl 0
else
  sudo nixos-install --flake "$repo/${git_rev:-main}#$host" --option tarball-ttl 0
fi

echo "Installation complete. It is now safe to reboot."
