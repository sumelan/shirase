# Shirase

This is my personal flake.

## Features

### Filesystem: zfs + impermanence

My system consists of an encrypted disk that restores itself to a pristine state on each boot. To return the root, I use a systemd service that runs after the base zpool is imported but before the root is actually mounted.

### Wrapping: pre-bundling configuration

I create a number of wrapped packages. Those are portable, and I can use them on other Nix-installed systems without breaking the host's settings. Note that some configuration, like file paths, is excluded from wrapping because it depends on my config.
```sh
nix run github:sumelan/shirase#WRAPPED_PACKAGE
```

## Install

There is a script to create the zpool and partition. I know disko exists but
prefer this method.

```sh
sh <(curl -L https://raw.githubusercontent.com/sumelan/shirase/main/partition.sh)
```

Before running `nixos-install`, one task is required: writing the hardware
configuration for the target host. Filesystem mounts are already written in this
flake, but they lack info about the swap mount. You can choose to encrypt the
swap disk or not. If you encrypt the swap disk, you need to write the
PARTUUID of the swap partition after partitioning, not the UUID.

```sh
lsblk -dno PARTUUID /dev/nvme0n1p2
```

To generate a hardware config without filesystem info, run the command
below.

```sh
nixos-generate-config --no-filesystems --show-hardware-config
```

After writing the swap mount, you finally reach the install phase.

```sh
sudo nixos-install --no-root-password --flake "github:sumelan/shirase/main#HOST" --option tarball-ttl 0
```

## Resources
- Took inspiration from these dotfiles:
  [iynaix/dotfiles](https://github.com/iynaix/dotfiles), [Michael-C-Buckley/nixos](https://github.com/Michael-C-Buckley/nixos), [poz/niksos](https://git.poz.pet/poz/niksos)

- [Vimjoyer's YouTube](https://www.youtube.com/@vimjoyer)  
  If you consider using NixOS, check out his YouTube channel!
