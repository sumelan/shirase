# Shirase

This is my personal flake.

## Features

### ZFS + Impermanence

My system consists from encrypted disk that restores itself to pristine state on
each boot. To return the root, I use a systemd service that runs after base
zpool are imported but before the root is actually mounted.

### Custom Neovim

My flake includes custom neovim packages configured with
[nvf](https://github.com/NotAShelf/nvf). Those are separated to `nvfMini` and
`nvf`. Both are portable and you can use my neovim on other nix-installed
system. `nvfMini` is minimal and focus on only editting nix files.

```sh
nix run github:sumelan/shirase#nvf
```

## Install

There is a script to create zpool and partition. I know disko exists but I
prefer this method.

```sh
sh <(curl -L https://raw.githubusercontent.com/sumelan/shirase/main/partition.sh)
```

Before run `nixos-install`, one task required; writing hardware configuration
about target host. Filesystem mounts are already wrote on this flake but they
lack of swap mount. This is because I choose to encrypt my swap and need to
write the partUUID of swap disk after the partitioning. This is optional so you
can write swap mount in advance to automatically install.

```sh
lsblk -dno PARTUUID /dev/nvme0n1p2
```

To generate hardware config without filesystem info you can run below command.

```sh
nixos-generate-config --no-filesystems --show-hardware-config
```

After writing swap mount, finally I can install my flake.

```sh
sudo nixos-install --no-root-password --flake "github:sumelan/shirase/main#HOST" --option tarball-ttl 0
```

## Resource

- [Full Disk Encryption and Impermanence on NixOS](https://notashelf.dev/posts/impermanence)
  Raf wrote detail setup about encryption and impermanence. Also the Programs he
  involved with (nh, nvf, flint, and more!) always help me to use nixos.

- [iynaix/dotfiles](https://github.com/iynaix/dotfiles)

  I shamelessly copied many configs from his repo.

- [Vimjoyer's YouTube](https://www.youtube.com/@vimjoyer)

  If you consider using nixos, check on his YouTube channel!
