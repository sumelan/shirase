# Shirase

This is my personal flake.

## Features

### ZFS + Impermanence

My system consists of an encrypted disk that restores itself to a pristine state
on each boot. To return the root, I use a systemd service that runs after the
base zpool is imported but before the root is actually mounted.

### Custom Neovim

My flake includes custom Neovim packages configured with
[nvf](https://github.com/NotAShelf/nvf). Those are separated into `nvfMini` and
`nvf`. Both are portable, and you can use my Neovim on other Nix-installed
systems. `nvfMini` is minimal and focuses on only editing Nix files.

```sh
nix run github:sumelan/shirase#nvf
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
swap disk or not. If you will encrypt the swap disk, you need to write the
PARTUUID of the swap partition after partitioning, not the UUID.

```sh
lsblk -dno PARTUUID /dev/nvme0n1p2
```

To generate a hardware config without filesystem info, you can run the command
below.

```sh
nixos-generate-config --no-filesystems --show-hardware-config
```

After writing the swap mount, you can finally install my flake.

```sh
sudo nixos-install --no-root-password --flake "github:sumelan/shirase/main#HOST" --option tarball-ttl 0
```

## Resource

- [Full Disk Encryption and Impermanence on NixOS](https://notashelf.dev/posts/impermanence)
  Raf wrote a detailed setup about encryption and impermanence. Also, the
  programs he is involved with (nh, nvf, flint, and more) always help me use
  NixOS.

- [iynaix/dotfiles](https://github.com/iynaix/dotfiles)

  I shamelessly copied many configs from his repo.

- [Vimjoyer's YouTube](https://www.youtube.com/@vimjoyer)

  If you consider using nixos, check on his YouTube channel!
